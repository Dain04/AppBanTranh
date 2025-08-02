import 'package:flutter/material.dart';
import 'screens/auth/start_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nghê Thuật Ở Museo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      
      // Định nghĩa route ban đầu
      initialRoute: '/',
      
      // Sử dụng onGenerateRoute thay vì routes để xử lý tham số
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const StartScreen(),
            );
          case '/login':
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            );
          case '/profile':
            // Lấy user từ arguments
            final user = settings.arguments;
            if (user != null) {
              return MaterialPageRoute(
                builder: (context) => ProfileScreen(user: user as dynamic),
              );
            }
            // Nếu không có user, redirect về login
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          default:
            // Route không tồn tại
            return MaterialPageRoute(
              builder: (context) => const StartScreen(),
            );
        }
      },
      
      debugShowCheckedModeBanner: false,
    );
  }
}
