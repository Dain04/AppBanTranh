// lib/screens/main_screen.dart
import 'package:app_ban_tranh/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh/screens/cart_screen.dart';
import 'package:app_ban_tranh/repositories/user_repository.dart';
import 'package:app_ban_tranh/models/user.dart';
import 'home_screen.dart';
import 'Live_screen.dart';
import 'order_screen.dart';
import 'profile_screen.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  User? _currentUser;
  bool _isLoading = true;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  /// Tải thông tin user hiện tại
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _userRepository.getCurrentUser();
      
      if (user == null) {
        // Nếu không có user đăng nhập, chuyển về login
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
        return;
      }
      
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Hiển thị lỗi và chuyển về login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải thông tin user: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  /// Refresh user data
  Future<void> _refreshUserData() async {
    await _loadCurrentUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị loading khi đang tải user
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Đang tải thông tin tài khoản...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Nếu không có user, hiển thị màn hình trống (sẽ redirect về login)
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Không tìm thấy thông tin tài khoản'),
        ),
      );
    }

    // Tạo danh sách screens với user thật
    final List<Widget> screens = [
      HomeScreen(user: _currentUser!),
      const CartScreen(),
      UserOrderScreen(userId: _currentUser!.id),
      ProfileScreen(
        user: _currentUser!,
        onUserUpdated: _refreshUserData, // ← Callback để refresh data
      ),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Đơn Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá Nhân',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
