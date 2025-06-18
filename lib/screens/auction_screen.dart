import 'package:flutter/material.dart';

class AuctionScreen extends StatelessWidget {
  const AuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction Page'),
      ),
      body: const Center(
        child: Text('This is the Auction Page'),
      ),
    );
  }
}
