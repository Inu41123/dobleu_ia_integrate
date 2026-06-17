import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_widgets.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ChatController controller = Get.put(ChatController());
  final TextEditingController textController = TextEditingController();

  void _sendMessage() {
    if (textController.text.trim().isNotEmpty) {
      controller.sendMessage(textController.text);
      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED), // Fondo naranja claro como en el HTML
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.85),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFF39200), Color(0xFFFF7A00)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dobleu IA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                Text('Asistente Inteligente', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  if (msg.isLoading) {
                    return const LoadingBubble();
                  } else if (msg.isUser) {
                    return UserBubble(text: msg.text);
                  } else {
                    if (msg.data != null && msg.data!.businesses != null && msg.data!.businesses!.isNotEmpty) {
                      return StructuredResultCard(data: msg.data!);
                    }
                    if (msg.text.contains('Horario de')) {
                      return ScheduleCard(rawText: msg.text);
                    }
                    return BotBubble(text: msg.text);
                  }
                },
              );
            }),
          ),
          
          // Composer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              border: Border(top: BorderSide(color: Colors.orange.withOpacity(0.1))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip('👋 Hola', 'hola'),
                      _buildChip('🌮 Tacos', 'quiero tacos'),
                      _buildChip('🍕 Pizza', 'quiero pizza'),
                      _buildChip('🏆 Top ventas', 'lo más vendido'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(color: Colors.orange.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                          ],
                        ),
                        child: TextField(
                          controller: textController,
                          maxLines: 3,
                          minLines: 1,
                          decoration: const InputDecoration(
                            hintText: '¿Qué se te antoja?',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFF39200), Color(0xFFFF7A00)]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                          ],
                        ),
                        child: const Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label, style: const TextStyle(color: Color(0xFFF39200), fontSize: 12, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFFF4E3),
        side: const BorderSide(color: Color(0x38F39200)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          textController.text = value;
        },
      ),
    );
  }
}
