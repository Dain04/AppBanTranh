import 'package:flutter/material.dart';

class GalleriesPageScreen extends StatelessWidget {
  const GalleriesPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galleries Page'),
      ),
      body: const Center(
        child: Text('This is the Galleries Page'),
      ),
    );
  }
}
