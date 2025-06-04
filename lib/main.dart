import 'package:flutter/material.dart';
import 'screens/auth/start_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nghê Thuật Ở Museo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const StartScreen(), // Bắt đầu từ StartScreen
      debugShowCheckedModeBanner: false, // Ẩn banner debug
    );
  }
}
