// lib/repositories/user_repository.dart
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  User? _currentUser; // Cache current user

  // ==================== AUTHENTICATION ====================
  
  /// Đăng ký người dùng mới
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      // Kiểm tra email đã tồn tại chưa
      final existingUsers = await db.query(
        'users',
        where: 'email = ? OR username = ?',
        whereArgs: [email, username],
      );
      
      if (existingUsers.isNotEmpty) {
        return {
          'success': false,
          'message': 'Email hoặc username đã tồn tại',
        };
      }
      
      // Tạo user mới
      final userId = _generateUserId();
      final hashedPassword = _databaseHelper.hashPassword(password);
      
      final user = User(
        id: userId,
        username: username,
        email: email,
        password: hashedPassword,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Lưu vào database
      await db.insert('users', user.toMap(includePassword: true));
      
      // Lưu session
      await _saveUserSession(userId);
      
      // Cache user
      _currentUser = user;
      
      return {
        'success': true,
        'message': 'Đăng ký thành công',
        'user': user,
      };
      
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi đăng ký: ${e.toString()}',
      };
    }
  }
  
  /// Đăng nhập với email/username và password
  Future<Map<String, dynamic>> login({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      // Tìm user theo email hoặc username
      final users = await db.query(
        'users',
        where: 'email = ? OR username = ?',
        whereArgs: [emailOrUsername, emailOrUsername],
      );
      
      if (users.isEmpty) {
        return {
          'success': false,
          'message': 'Tài khoản không tồn tại',
        };
      }
      
      final userData = users.first;
      final hashedPassword = _databaseHelper.hashPassword(password);
      
      // Kiểm tra password
      if (userData['password_hash'] != hashedPassword) {
        return {
          'success': false,
          'message': 'Mật khẩu không chính xác',
        };
      }
      
      // Tạo user object
      final user = User.fromMap(userData);
      
      // Lưu session
      await _saveUserSession(user.id);
      
      // Cache user
      _currentUser = user;
      
      return {
        'success': true,
        'message': 'Đăng nhập thành công',
        'user': user,
      };
      
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi đăng nhập: ${e.toString()}',
      };
    }
  }
  
  /// Đăng nhập với Google
  Future<Map<String, dynamic>> loginWithGoogle({
    required String googleId,
    required String email,
    required String username,
    String? profilePictureUrl,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      // Kiểm tra user đã tồn tại chưa
      final existingUsers = await db.query(
        'users',
        where: 'google_id = ? OR email = ?',
        whereArgs: [googleId, email],
      );
      
      User user;
      
      if (existingUsers.isNotEmpty) {
        // User đã tồn tại, update thông tin
        final userData = existingUsers.first;
        user = User.fromMap(userData);
        
        // Update Google info nếu cần
        if (user.googleId != googleId) {
          await db.update(
            'users',
            {
              'google_id': googleId,
              'profile_picture_url': profilePictureUrl,
              'updated_at': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [user.id],
          );
          
          user = user.copyWith(
            googleId: googleId,
            profilePictureUrl: profilePictureUrl,
            updatedAt: DateTime.now(),
          );
        }
      } else {
        // Tạo user mới
        final userId = _generateUserId();
        user = User(
          id: userId,
          username: username,
          email: email,
          googleId: googleId,
          profilePictureUrl: profilePictureUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await db.insert('users', user.toMap());
      }
      
      // Lưu session
      await _saveUserSession(user.id);
      
      // Cache user
      _currentUser = user;
      
      return {
        'success': true,
        'message': 'Đăng nhập Google thành công',
        'user': user,
      };
      
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi đăng nhập Google: ${e.toString()}',
      };
    }
  }
  
  /// Đăng xuất
  Future<void> logout() async {
    try {
      final db = await _databaseHelper.database;
      
      if (_currentUser != null) {
        // Xóa session
        await db.delete(
          'user_sessions',
          where: 'user_id = ?',
          whereArgs: [_currentUser!.id],
        );
      }
      
      // Clear cache
      _currentUser = null;
      
    } catch (e) {
      print('Lỗi đăng xuất: ${e.toString()}');
    }
  }
  
  // ==================== USER MANAGEMENT ====================
  
  /// Lấy thông tin user hiện tại
  Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    
    try {
      final db = await _databaseHelper.database;
      
      // Lấy session hiện tại
      final sessions = await db.query(
        'user_sessions',
        where: 'expires_at > ?',
        whereArgs: [DateTime.now().toIso8601String()],
        orderBy: 'created_at DESC',
        limit: 1,
      );
      
      if (sessions.isEmpty) {
        return null;
      }
      
      final userId = sessions.first['user_id'] as String;
      
      // Lấy thông tin user
      final users = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      
      if (users.isEmpty) {
        return null;
      }
      
      _currentUser = User.fromMap(users.first);
      return _currentUser;
      
    } catch (e) {
      print('Lỗi lấy user hiện tại: ${e.toString()}');
      return null;
    }
  }
  
  /// Kiểm tra đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
  
  /// Cập nhật thông tin profile
  Future<Map<String, dynamic>> updateProfile(User updatedUser) async {
    try {
      final db = await _databaseHelper.database;
      
      final updateData = updatedUser.copyWith(
        updatedAt: DateTime.now(),
      ).toMap();
      
      final rowsAffected = await db.update(
        'users',
        updateData,
        where: 'id = ?',
        whereArgs: [updatedUser.id],
      );
      
      if (rowsAffected > 0) {
        _currentUser = updatedUser.copyWith(updatedAt: DateTime.now());
        
        return {
          'success': true,
          'message': 'Cập nhật thành công',
          'user': _currentUser,
        };
      } else {
        return {
          'success': false,
          'message': 'Không tìm thấy user để cập nhật',
        };
      }
      
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi cập nhật: ${e.toString()}',
      };
    }
  }
  
  /// Đổi mật khẩu
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (_currentUser == null) {
        return {
          'success': false,
          'message': 'Chưa đăng nhập',
        };
      }
      
      final db = await _databaseHelper.database;
      
      // Kiểm tra mật khẩu hiện tại
      final hashedCurrentPassword = _databaseHelper.hashPassword(currentPassword);
      final users = await db.query(
        'users',
        where: 'id = ? AND password_hash = ?',
        whereArgs: [_currentUser!.id, hashedCurrentPassword],
      );
      
      if (users.isEmpty) {
        return {
          'success': false,
          'message': 'Mật khẩu hiện tại không chính xác',
        };
      }
      
      // Cập nhật mật khẩu mới
      final hashedNewPassword = _databaseHelper.hashPassword(newPassword);
      await db.update(
        'users',
        {
          'password_hash': hashedNewPassword,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [_currentUser!.id],
      );
      
      return {
        'success': true,
        'message': 'Đổi mật khẩu thành công',
      };
      
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi đổi mật khẩu: ${e.toString()}',
      };
    }
  }
  
  // ==================== HELPER METHODS ====================
  
  /// Tạo ID ngẫu nhiên cho user
  String _generateUserId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(999999);
    return 'user_${timestamp}_$randomNum';
  }
  
  /// Lưu session cho user
  Future<void> _saveUserSession(String userId) async {
    try {
      final db = await _databaseHelper.database;
      
      // Xóa session cũ
      await db.delete(
        'user_sessions',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      
      // Tạo session mới
      final sessionToken = _generateSessionToken();
      final expiresAt = DateTime.now().add(const Duration(days: 30));
      
      await db.insert('user_sessions', {
        'user_id': userId,
        'session_token': sessionToken,
        'expires_at': expiresAt.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
      
    } catch (e) {
      print('Lỗi lưu session: ${e.toString()}');
    }
  }
  
  /// Tạo session token
  String _generateSessionToken() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomString = List.generate(32, (index) => 
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[random.nextInt(62)]
    ).join();
    return '${timestamp}_$randomString';
  }
}
