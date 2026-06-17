import 'package:flutter/material.dart';

class MockDetailPage extends StatelessWidget {
  final String title;
  final String type;
  final int id;

  const MockDetailPage({
    super.key,
    required this.title,
    required this.type,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Simulación de App Principal', style: TextStyle(color: Colors.black, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFE9F9F0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x3822A05A)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Color(0xFF22A05A), size: 60),
              const SizedBox(height: 20),
              const Text(
                '¡Redirección Exitosa!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A8049)),
              ),
              const SizedBox(height: 16),
              const Text(
                'En el proyecto real, el código de navegación aquí abrirá:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 24),
              _buildRow('Tipo:', type),
              const Divider(),
              _buildRow('Nombre:', title),
              const Divider(),
              _buildRow('ID a Consultar:', id.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }
}
