import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dobleu IA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SearchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
