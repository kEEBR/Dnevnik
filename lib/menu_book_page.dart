import 'package:flutter/material.dart';

class MenuBookPage extends StatelessWidget {
  const MenuBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange, // Оранжевый цвет фона
      child: const Center(
        child: Text(
          'Страница мини-играми',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
