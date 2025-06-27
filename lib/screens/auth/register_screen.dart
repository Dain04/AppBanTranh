import 'package:flutter/material.dart';
import 'package:app_ban_tranh/screens/auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// Màn hình đăng ký - Sử dụng StatefulWidget để quản lý trạng thái
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Khóa biểu mẫu để kiểm tra tính hợp lệ
  final _formKey = GlobalKey<FormState>();

  // Các controller để lấy dữ liệu từ TextFormField
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Biến để điều khiển hiển thị mật khẩu
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không còn sử dụng
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Màu nền của toàn màn hình
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/startbackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // Cuộn khi bàn phím xuất hiện
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints:
                  const BoxConstraints(maxWidth: 400), // Giới hạn chiều rộng
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ------------------- Logo và tiêu đề -------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Transform.translate(
                          offset: const Offset(0, -10),
                          child: Text(
                            'Museo',
                            textAlign: TextAlign.center,
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

                    const SizedBox(height: 5),

                    const Text(
                      'Chào mừng đến Museo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ------------------- Trường nhập Username -------------------
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                          return 'Vui lòng điền username';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ------------------- Trường nhập Email -------------------
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                          return 'Vui lòng điền email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ------------------- Trường nhập Password -------------------
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, // Ẩn/hiện mật khẩu
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                          return 'Vui lòng điền password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ------------------- Nút Đăng ký -------------------
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _handleRegister(); // Xử lý đăng ký
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
                          'Đăng ký',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ------------------- Divider OR -------------------
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Hoặc',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ------------------- Đăng nhập với Google -------------------
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          _handleGoogleLogin(); // Gọi hàm xử lý Google Login
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/logoGoogle.png',
                                  width: 35,
                                  height: 35,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text('Lỗi ảnh',
                                        style: TextStyle(color: Colors.red));
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Đăng nhập bằng Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ------------------- Link đến màn hình đăng nhập -------------------
                    RichText(
                      text: TextSpan(
                        text: "Bạn đã có tài khoản? ",
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
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Đăng nhập ở đây',
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

  // Hàm xử lý đăng nhập bằng Google (chưa triển khai)
  void _handleGoogleLogin() {
    print('Google login pressed');
    // TODO: Thêm logic xử lý đăng nhập Google tại đây
  }

  // Hàm xử lý đăng ký người dùng (chưa triển khai)
  void _handleRegister() {
    // TODO: Gửi dữ liệu lên server, xử lý backend
    print("Register button clicked");
  }
}
