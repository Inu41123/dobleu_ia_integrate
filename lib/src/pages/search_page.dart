import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Buscador', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        // Al tocar fuera de la barra, quitamos el foco
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView( // Añadido para evitar errores cuando se abre el teclado
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de búsqueda normal
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    decoration: const InputDecoration(
                      hintText: '¿Qué se te antoja hoy?',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Sugerencia de "Búsqueda con IA" animada
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _isSearchFocused
                      ? InkWell(
                          onTap: () {
                            // Quitamos el foco al navegar para que cuando regrese ya no esté desplegado
                            FocusScope.of(context).unfocus();
                            Get.to(() => ChatPage(), transition: Transition.cupertino);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange.shade400, Colors.orange.shade700],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Búsqueda Inteligente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text('Pídelo como si estuvieras platicando', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                
                // --- ELEMENTOS DE RELLENO (DUMMY) PARA MOSTRAR EL DESPLAZAMIENTO ---
                const Text('Búsquedas Recientes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildDummyChip('Hamburguesa'),
                    _buildDummyChip('Sushi'),
                    _buildDummyChip('Tacos al pastor'),
                    _buildDummyChip('Pizza de pepperoni'),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Categorías Populares', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDummyCategory(Icons.local_pizza, 'Pizza', Colors.orange),
                    _buildDummyCategory(Icons.fastfood, 'Burger', Colors.red),
                    _buildDummyCategory(Icons.ramen_dining, 'Asiática', Colors.green),
                    _buildDummyCategory(Icons.icecream, 'Postres', Colors.pink),
                  ],
                ),
                const SizedBox(height: 200), // Espacio extra para asegurar scroll
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDummyChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
    );
  }

  Widget _buildDummyCategory(IconData icon, String title, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }
}
