import 'package:get/get.dart';
import '../models/chat_response_model.dart';
import '../services/api_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final ChatResponseModel? data;
  final bool isLoading;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.data,
    this.isLoading = false,
  });
}

class ChatController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Lista observable de mensajes
  final messages = <ChatMessage>[].obs;
  
  // Memoria del contexto
  final _memory = <Map<String, String>>[];

  @override
  void onInit() {
    super.onInit();
    // Mensaje de bienvenida inicial
    messages.add(ChatMessage(
      text: "👋 Hola, soy **Dobleu IA**.\n\nPuedo ayudarte a encontrar:\n• 🍕 Pizzas, tacos, hamburguesas y más\n• 💲 Precios reales\n• ⏰ Horarios de negocios\n• 🏆 Lo más vendido\n\nEscribe lo que se te antoje ⬇️",
      isUser: false,
    ));
  }

  void _addToMemory(String role, String text) {
    _memory.add({'role': role, 'text': text});
    if (_memory.length > 10) {
      _memory.removeRange(0, 2);
    }
  }

  String _buildContextPrefix() {
    if (_memory.isEmpty) return "";
    var lines = _memory.sublist(_memory.length > 6 ? _memory.length - 6 : 0).map((m) {
      return "${m['role'] == 'user' ? 'U' : 'IA'}: ${m['text']}";
    }).toList();
    return "[Contexto]\n${lines.join('\n')}\n[/Contexto]\n\n";
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Agregar mensaje del usuario
    messages.add(ChatMessage(text: text, isUser: true));
    _addToMemory('user', text);

    // Agregar indicador de carga
    messages.add(ChatMessage(text: "", isUser: false, isLoading: true));

    // Consumir API
    final contextPrefix = _buildContextPrefix();
    final response = await _apiService.sendMessage(text, context: contextPrefix);

    // Remover indicador de carga
    messages.removeLast();

    if (response != null) {
      // Guardar en memoria la respuesta de la IA (para que tenga algo de contexto)
      String botMemoryText = "";
      if (response.businesses != null && response.businesses!.isNotEmpty) {
        botMemoryText = response.businesses!.map((b) => b.name).join(", ");
      } else if (response.answer != null) {
        botMemoryText = response.answer!;
      }
      _addToMemory('bot', botMemoryText.length > 150 ? botMemoryText.substring(0, 150) : botMemoryText);

      // Agregar burbuja con datos estructurados o respuesta simple
      messages.add(ChatMessage(
        text: response.answer ?? "",
        isUser: false,
        data: response,
      ));
    } else {
      messages.add(ChatMessage(
        text: "Hubo un error al contactar con el servidor. Por favor, intenta de nuevo.",
        isUser: false,
      ));
    }
  }
}
