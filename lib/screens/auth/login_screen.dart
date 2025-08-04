import 'package:app_ban_tranh/repositories/user_repository.dart';
import 'package:app_ban_tranh/screens/auth/register_screen.dart';
import 'package:app_ban_tranh/screens/main_screen.dart';
import 'package:app_ban_tranh/screens/reset_passworrd_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Khóa dùng để xác thực form
  final _usernameController =
      TextEditingController(); // Controller cho trường username
  final _passwordController =
      TextEditingController(); // Controller cho trường password
  bool _isPasswordVisible = false; // Trạng thái hiển thị mật khẩu

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Màu nền tối cho toàn bộ màn hình
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/startbackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0), // Padding ngoài
            child: Container(
              constraints: const BoxConstraints(
                  maxWidth: 400), // Giới hạn chiều rộng tối đa
              padding: const EdgeInsets.all(32.0), // Padding trong
              decoration: BoxDecoration(
                color: Colors.white, // Nền trắng cho form
                borderRadius: BorderRadius.circular(12), // Bo góc
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Đổ bóng nhẹ
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey, // Gán form key
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Chiều cao co lại theo nội dung
                  children: [
                    // ---------- Logo và tiêu đề ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        Transform.translate(
                          offset: const Offset(
                              -10, 0), // Dịch vị trí chữ cho cân đối
                          child: Text(
                            'Museo',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily:
                                  GoogleFonts.playfairDisplay().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ---------- Tiêu đề chào mừng ----------
                    const Text(
                      'Chào mừng trở lại Museo',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // ---------- Trường nhập Username ----------
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tài khoản';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ---------- Trường nhập Password ----------
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, // Ẩn/hiện password
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8),

                    // ---------- Quên mật khẩu ----------
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPassworrdScreen()),
                          );
                        },
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ---------- Nút Đăng nhập ----------
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _handleLogin(); // Xử lý đăng nhập
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),


                    // ---------- Liên kết đến trang đăng ký ----------
                    RichText(
                      text: TextSpan(
                        text: "Bạn chưa có tài khoản? ",
                        style: const TextStyle(color: Colors.grey),
                        children: [
                          WidgetSpan(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Đăng ký',
                                  style: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Xử lý đăng nhập thường
void _handleLogin() async {
  // Hiển thị loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    final userRepository = UserRepository();
    final result = await userRepository.login(
      emailOrUsername: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    // Đóng loading
    Navigator.of(context).pop();

    if (result['success']) {
      // Đăng nhập thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Hiển thị lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Đóng loading
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  // Xử lý đăng nhập bằng Google
  void _handleGoogleLogin() {
    print('Google login pressed');

    // TODO: Triển khai đăng nhập Google
    // - Khởi tạo Google Sign-In
    // - Nhận token
    // - Điều hướng sau khi xác thực thành công
  }
}
