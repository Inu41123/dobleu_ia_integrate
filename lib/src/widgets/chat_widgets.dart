import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_response_model.dart';
import '../pages/mock_detail_page.dart';

class UserBubble extends StatelessWidget {
  final String text;
  const UserBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFF39200), Color(0xFFFF7A00)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(5)),
          boxShadow: [BoxShadow(color: Color(0x47F39200), blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class BotBubble extends StatelessWidget {
  final String text;
  const BotBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.92),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0x2EF39200)),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(5), bottomRight: Radius.circular(20)),
          boxShadow: const [BoxShadow(color: Color(0x14F39200), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5)),
      ),
    );
  }
}

class LoadingBubble extends StatelessWidget {
  const LoadingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0x2EF39200)),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(18)),
          boxShadow: const [BoxShadow(color: Color(0x14F39200), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFF39200))),
            SizedBox(width: 10),
            Text('Buscando las mejores opciones...', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class StructuredResultCard extends StatelessWidget {
  final ChatResponseModel data;
  const StructuredResultCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x2EF39200)),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(20)),
        boxShadow: const [BoxShadow(color: Color(0x1EF39200), blurRadius: 20, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [const Color(0xFFFFF4E3), Colors.white.withOpacity(0)], begin: Alignment.centerLeft, end: Alignment.centerRight),
              border: const Border(bottom: BorderSide(color: Color(0x1AF39200))),
            ),
            child: Row(
              children: [
                const Text('🍽️', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(child: Text(data.title ?? 'Opciones encontradas', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF7A6650)))),
              ],
            ),
          ),
          
          if (data.correction != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFFFF4E3), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0x38F39200))),
                child: Text('💬 ${data.correction}', style: const TextStyle(fontSize: 12, color: Color(0xFFF39200), fontWeight: FontWeight.w500)),
              ),
            ),

          // Negocios
          if (data.businesses != null)
            ...data.businesses!.map((biz) => _buildBizBlock(biz)),
            
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1E0),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(20)),
            ),
            child: const Text('Pregúntame por más comida o negocios.', style: TextStyle(fontSize: 11, color: Colors.grey)),
          )
        ],
      ),
    );
  }

  Widget _buildBizBlock(ChatBusinessModel biz) {
    // Verificamos si es un restaurante real revisando si tiene un ID válido.
    // Si la IA manda un bloque falso como "Top Dobleu", el ID suele venir vacío o 0.
    int restId = biz.items.isNotEmpty ? biz.items.first.restaurantId : 0;
    bool isRealRestaurant = restId != 0 && biz.name.toLowerCase() != 'top dobleu';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Biz Header
        InkWell(
          onTap: isRealRestaurant ? () {
            // Navegamos pasando el ID del restaurante
            Get.to(() => MockDetailPage(
              title: biz.name, 
              type: 'Restaurante', 
              id: restId
            ), transition: Transition.rightToLeft);
          } : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1E0),
              border: Border(bottom: BorderSide(color: Color(0x1AF39200))),
            ),
            child: Row(
              children: [
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFF39200), Color(0xFFFF7A00)]),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: const [BoxShadow(color: Color(0x40F39200), blurRadius: 6, offset: Offset(0, 2))],
                  ),
                  child: const Center(child: Text('🏪', style: TextStyle(fontSize: 13))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(biz.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                if (biz.abierto != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: biz.abierto! ? const Color(0xFFE9F9F0) : const Color(0xFFFFF4E3),
                      border: Border.all(color: biz.abierto! ? const Color(0x3822A05A) : const Color(0x38F39200)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(biz.abierto! ? '🟢 Abierto' : '🔴 Cerrado', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: biz.abierto! ? const Color(0xFF1A8049) : const Color(0xFFF39200))),
                  ),
              ],
            ),
          ),
        ),
        // Items
        ...biz.items.map((item) => _buildProductRow(item, biz.name)),
        const Divider(height: 1, color: Color(0x1AF39200)),
      ],
    );
  }

  Widget _buildProductRow(ChatItemModel item, String parentBizName) {
    return InkWell(
      onTap: () {
        // Navegamos pasando el ID del producto
        Get.to(() => MockDetailPage(
          title: item.name, 
          type: 'Producto', 
          id: item.id
        ), transition: Transition.rightToLeft);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 6, height: 6,
              decoration: const BoxDecoration(color: Color(0x80F39200), shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                  if (item.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(item.description, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  // Mostrar el restaurante de donde viene si el nombre es diferente al del bloque padre
                  if (item.restaurantName.isNotEmpty && item.restaurantName.toLowerCase() != parentBizName.toLowerCase())
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('📍 De: ${item.restaurantName}', style: const TextStyle(fontSize: 10, color: Color(0xFFF39200), fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F9F0),
                border: Border.all(color: const Color(0x3822A05A)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A8049))),
            )
          ],
        ),
      ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String rawText;
  const ScheduleCard({super.key, required this.rawText});

  @override
  Widget build(BuildContext context) {
    // Ejemplo de texto:
    // Horario de Taquería Jessy - Cerrado ahora
    // 
    // Lunes: 18:00 - 22:30
    // Martes: 18:00 - 22:30

    List<String> lines = rawText.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    if (lines.isEmpty) return const SizedBox.shrink();

    // Extraer título y estado
    String titleLine = lines.first; // "Horario de Taquería Jessy - Cerrado ahora"
    String restaurantName = "Horario";
    String status = "";
    bool isOpen = false;

    if (titleLine.contains('-')) {
      var parts = titleLine.split('-');
      restaurantName = parts[0].replaceAll('Horario de', '').trim();
      status = parts[1].trim();
      isOpen = status.toLowerCase().contains('abierto');
    } else {
      restaurantName = titleLine.replaceAll('Horario de', '').trim();
    }

    // Extraer los días
    List<String> scheduleLines = lines.skip(1).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x2EF39200)),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(20)),
        boxShadow: const [BoxShadow(color: Color(0x1EF39200), blurRadius: 20, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1E0),
              border: Border(bottom: BorderSide(color: Color(0x1AF39200))),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Text('⏰', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(child: Text(restaurantName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black))),
                if (status.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOpen ? const Color(0xFFE9F9F0) : Colors.white,
                      border: Border.all(color: isOpen ? const Color(0x3822A05A) : const Color(0x38F39200)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isOpen ? const Color(0xFF1A8049) : const Color(0xFFF39200))),
                  ),
              ],
            ),
          ),
          
          // Body con los días
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: scheduleLines.map((line) {
                if (!line.contains(':')) return const SizedBox.shrink();
                
                int colonIndex = line.indexOf(':');
                String day = line.substring(0, colonIndex).trim();
                String time = line.substring(colonIndex + 1).trim();

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0x0AF39200))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(day, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                      Text(time, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A8049))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
