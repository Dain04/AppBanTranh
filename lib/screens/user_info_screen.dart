// lib/screens/user_info_screen.dart
import 'package:app_ban_tranh/models/user.dart';
import 'package:app_ban_tranh/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserInfoScreen extends StatefulWidget {
  final User user;
  final Function(User)? onUserUpdated;

  const UserInfoScreen({
    Key? key, 
    required this.user,
    this.onUserUpdated,
  }) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User currentUser;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfileDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade400,
                      Colors.purple.shade400,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Avatar với chức năng thay đổi
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: currentUser.profilePictureUrl != null
                                ? NetworkImage(currentUser.profilePictureUrl!)
                                : null,
                            child: currentUser.profilePictureUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.black54,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showChangeAvatarDialog,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ✨ Hiển thị tên đầy đủ thay vì username
                    Text(
                      currentUser.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email
                    Text(
                      currentUser.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Personal Information Section
            _buildSectionTitle('Thông tin cá nhân'),
            const SizedBox(height: 12),
            _buildInfoCard([
              _buildInfoRow(
                  Icons.person_outline, 'Tên người dùng', currentUser.username),
              // ✨ THÊM MỚI - Hiển thị họ và tên
              if (currentUser.firstName != null || currentUser.lastName != null)
                _buildInfoRow(
                    Icons.badge_outlined, 'Họ và tên', currentUser.fullName),
              if (currentUser.firstName != null)
                _buildInfoRow(
                    Icons.person, 'Họ', currentUser.firstName!),
              if (currentUser.lastName != null)
                _buildInfoRow(
                    Icons.badge, 'Tên', currentUser.lastName!),
              _buildInfoRow(Icons.email_outlined, 'Email', currentUser.email),
              if (currentUser.phoneNumber != null)
                _buildInfoRow(
                    Icons.phone_outlined, 'Số điện thoại', currentUser.phoneNumber!),
            ]),

            const SizedBox(height: 24),

            // Address Information Section
            if (_hasAddressInfo(currentUser)) ...[
              _buildSectionTitle('Địa chỉ'),
              const SizedBox(height: 12),
              _buildInfoCard([
                if (currentUser.address1 != null)
                  _buildInfoRow(
                      Icons.home_outlined, 'Địa chỉ 1', currentUser.address1!),
                if (currentUser.address2 != null)
                  _buildInfoRow(
                      Icons.home_work_outlined, 'Địa chỉ 2', currentUser.address2!),
                if (currentUser.city != null)
                  _buildInfoRow(
                      Icons.location_city_outlined, 'Thành phố', currentUser.city!),
                if (currentUser.state != null)
                  _buildInfoRow(Icons.map_outlined, 'Tiểu bang', currentUser.state!),
                if (currentUser.country != null)
                  _buildInfoRow(
                      Icons.public_outlined, 'Quốc gia', currentUser.country!),
                if (currentUser.postalCode != null)
                  _buildInfoRow(Icons.markunread_mailbox_outlined,
                      'Mã bưu điện', currentUser.postalCode!),
              ]),
            ],

            const SizedBox(height: 24),

            // Account Information Section
            _buildSectionTitle('Thông tin tài khoản'),
            const SizedBox(height: 12),
            _buildInfoCard([
              _buildInfoRow(
                  Icons.fingerprint_outlined, 'ID người dùng', currentUser.id),
              if (currentUser.googleId != null)
                _buildInfoRow(
                    Icons.account_circle, 'Google ID', currentUser.googleId!),
            ]),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditProfileDialog(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Chỉnh sửa thông tin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Đăng xuất'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Additional Options
            _buildSectionTitle('Tùy chọn khác'),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildOptionTile(
                    icon: Icons.security,
                    title: 'Đổi mật khẩu',
                    subtitle: 'Thay đổi mật khẩu tài khoản',
                    onTap: _showChangePasswordDialog,
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    icon: Icons.notifications,
                    title: 'Cài đặt thông báo',
                    subtitle: 'Quản lý thông báo ứng dụng',
                    onTap: () => _showComingSoonDialog('Cài đặt thông báo'),
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    icon: Icons.privacy_tip,
                    title: 'Chính sách bảo mật',
                    subtitle: 'Xem chính sách bảo mật',
                    onTap: () => _showComingSoonDialog('Chính sách bảo mật'),
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    icon: Icons.help,
                    title: 'Trợ giúp & Hỗ trợ',
                    subtitle: 'Liên hệ hỗ trợ khách hàng',
                    onTap: () => _showComingSoonDialog('Trợ giúp & Hỗ trợ'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Colors.grey.shade600,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  bool _hasAddressInfo(User user) {
    return user.address1 != null ||
        user.address2 != null ||
        user.city != null ||
        user.state != null ||
        user.country != null ||
        user.postalCode != null;
  }

  // ✨ Hiển thị dialog chỉnh sửa thông tin với Họ và Tên
  void _showEditProfileDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController(text: currentUser.username);
    final emailController = TextEditingController(text: currentUser.email);
    final firstNameController = TextEditingController(text: currentUser.firstName ?? '');  // ✨ THÊM MỚI
    final lastNameController = TextEditingController(text: currentUser.lastName ?? '');    // ✨ THÊM MỚI
    final phoneController = TextEditingController(text: currentUser.phoneNumber ?? '');
    final address1Controller = TextEditingController(text: currentUser.address1 ?? '');
    final address2Controller = TextEditingController(text: currentUser.address2 ?? '');
    final cityController = TextEditingController(text: currentUser.city ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Chỉnh sửa thông tin',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên người dùng',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập tên người dùng';
                      }
                      if (value.trim().length < 2) {
                        return 'Tên người dùng phải có ít nhất 2 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // ✨ THÊM MỚI - Trường Họ
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Họ',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        if (value.trim().length < 1) {
                          return 'Họ phải có ít nhất 1 ký tự';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // ✨ THÊM MỚI - Trường Tên
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        if (value.trim().length < 1) {
                          return 'Tên phải có ít nhất 1 ký tự';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(value.trim())) {
                          return 'Số điện thoại không hợp lệ';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: address1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Địa chỉ 1',
                      prefixIcon: Icon(Icons.home_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: address2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Địa chỉ 2 (tùy chọn)',
                      prefixIcon: Icon(Icons.home_work_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Thành phố',
                      prefixIcon: Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  _updateUserInfo(
                    username: usernameController.text,
                    email: emailController.text,
                    firstName: firstNameController.text,    // ✨ THÊM MỚI
                    lastName: lastNameController.text,      // ✨ THÊM MỚI
                    phone: phoneController.text,
                    address1: address1Controller.text,
                    address2: address2Controller.text,
                    city: cityController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Lưu thay đổi'),
            ),
          ],
        );
      },
    );
  }

  // ✨ Cập nhật thông tin user với Họ và Tên
  void _updateUserInfo({
    required String username,
    required String email,
    required String firstName,    // ✨ THÊM MỚI
    required String lastName,     // ✨ THÊM MỚI
    required String phone,
    required String address1,
    required String address2,
    required String city,
  }) async {
    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Tạo user mới với thông tin đã cập nhật
      final updatedUser = currentUser.copyWith(
        username: username.trim(),
        email: email.trim(),
        firstName: firstName.trim().isEmpty ? null : firstName.trim(),      // ✨ THÊM MỚI
        lastName: lastName.trim().isEmpty ? null : lastName.trim(),         // ✨ THÊM MỚI
        phoneNumber: phone.trim().isEmpty ? null : phone.trim(),
        address1: address1.trim().isEmpty ? null : address1.trim(),
        address2: address2.trim().isEmpty ? null : address2.trim(),
        city: city.trim().isEmpty ? null : city.trim(),
      );

      // Gọi UserRepository để cập nhật
      final result = await _userRepository.updateProfile(updatedUser);
      
      // Đóng loading dialog
      Navigator.of(context).pop();

      if (result['success'] == true) {
        // Cập nhật state với user đã được cập nhật từ repository
        setState(() {
          currentUser = result['user'] as User;
        });

        // Gọi callback nếu có
        if (widget.onUserUpdated != null) {
          widget.onUserUpdated!(currentUser);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Thông tin đã được cập nhật thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Có lỗi xảy ra khi cập nhật thông tin!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Đóng loading dialog nếu còn mở
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hiển thị dialog thay đổi avatar
  void _showChangeAvatarDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thay đổi ảnh đại diện',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAvatarOption(
                    icon: Icons.camera_alt,
                    label: 'Chụp ảnh',
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoonDialog('Chụp ảnh');
                    },
                  ),
                  _buildAvatarOption(
                    icon: Icons.photo_library,
                    label: 'Thư viện',
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoonDialog('Chọn từ thư viện');
                    },
                  ),
                  _buildAvatarOption(
                    icon: Icons.delete,
                    label: 'Xóa ảnh',
                    onTap: () {
                      Navigator.pop(context);
                      _showComingSoonDialog('Xóa ảnh đại diện');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Hiển thị dialog đổi mật khẩu sử dụng UserRepository
  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Đổi mật khẩu',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () => _changePassword(
                currentPassword: currentPasswordController.text,
                newPassword: newPasswordController.text,
                confirmPassword: confirmPasswordController.text,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đổi mật khẩu'),
            ),
          ],
        );
      },
    );
  }

  // Đổi mật khẩu sử dụng UserRepository
  void _changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validation
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu mới phải có ít nhất 6 ký tự!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Đóng dialog
    Navigator.of(context).pop();

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Gọi UserRepository để đổi mật khẩu
      final result = await _userRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      // Đóng loading dialog
      Navigator.of(context).pop();

      // Hiển thị kết quả
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Có lỗi xảy ra!'),
          backgroundColor: result['success'] == true ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      // Đóng loading dialog nếu còn mở
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hiển thị dialog đăng xuất
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red.shade600),
              const SizedBox(width: 8),
              const Text(
                'Đăng xuất',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }
  // Thực hiện đăng xuất sử dụng UserRepository
  void _performLogout() async {
    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Gọi UserRepository để đăng xuất
      await _userRepository.logout();
      
      // Đóng loading dialog
      Navigator.of(context).pop();
      
      // Navigate to login screen và xóa tất cả routes
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login', // Hoặc route name của login screen
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã đăng xuất thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Đóng loading dialog nếu còn mở
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi đăng xuất: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Refresh user data từ database
  void _refreshUserData() async {
    try {
      final user = await _userRepository.getCurrentUser();
      if (user != null) {
        setState(() {
          currentUser = user;
        });
      }
    } catch (e) {
      print('Lỗi refresh user data: ${e.toString()}');
    }
  }

  // Hiển thị dialog "Sắp ra mắt"
  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.construction, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              const Text(
                'Sắp ra mắt',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Chức năng "$feature" đang được phát triển và sẽ có mặt trong phiên bản tiếp theo.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đã hiểu'),
            ),
          ],
        );
      },
    );
  }
}


