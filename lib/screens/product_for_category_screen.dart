//
import 'package:flutter/material.dart';

class ProductForCategoryScreen extends StatelessWidget {
  final String categoryName;
  const ProductForCategoryScreen({required this.categoryName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductForCategoryScreen'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'ProductForCategoryScreen',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
