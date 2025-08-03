import 'package:flutter/material.dart';
import 'screens/auth/start_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_ban_tranh/database/database_helper.dart';
import 'package:app_ban_tranh/models/prodcut.dart';

void main() async {
  // Đảm bảo Flutter đã khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
    // Xóa database cũ nếu cần
  final dbHelper = DatabaseHelper();
  await dbHelper.resetDatabase();
  // Khởi tạo database và thêm dữ liệu mẫu
  // Tiếp tục khởi tạo ứng dụng
  await _initializeDatabase();
  runApp(const MainApp());
}

// Hàm khởi tạo database và thêm dữ liệu mẫu
Future<void> _initializeDatabase() async {
  final DatabaseHelper dbHelper = DatabaseHelper();
  
  // Kiểm tra xem database đã có sản phẩm chưa
  bool hasProducts = await dbHelper.hasProducts();
  
  if (!hasProducts) {
    print('Đang thêm dữ liệu mẫu vào database...');
    
    // Thêm dữ liệu mẫu từ product.dart vào database
    await dbHelper.insertAllProducts([
      // ...homenewArtworks,
      ...newArtworks,
      // ...DauGiaTP,
      // ...GioHang_TP
    ]);
    
    print('Đã thêm dữ liệu mẫu vào database');
  } else {
    print('Database đã có dữ liệu sản phẩm');
  }
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
