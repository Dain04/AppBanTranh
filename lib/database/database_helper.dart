// lib/helpers/database_helper.dart
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart'; // ← Thêm import này
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app_ban_tranh.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tạo bảng users
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT,
        profile_picture_url TEXT,
        phone_number TEXT,
        address1 TEXT,
        address2 TEXT,
        city TEXT,
        country TEXT,
        postal_code TEXT,
        state TEXT,
        google_id TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tạo bảng user_sessions
    await db.execute('''
      CREATE TABLE user_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        session_token TEXT NOT NULL UNIQUE,
        expires_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tạo bảng categories
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        image_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tạo bảng products
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category_id INTEGER,
        image_url TEXT,
        stock_quantity INTEGER DEFAULT 0,
        is_featured INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // Tạo bảng cart_items
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
        UNIQUE(user_id, product_id)
      )
    ''');

    // Tạo bảng orders
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        total_amount REAL NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        shipping_address TEXT,
        payment_method TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Tạo bảng order_items
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    // Tạo indexes để tối ưu performance
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_users_username ON users(username)');
    await db.execute('CREATE INDEX idx_sessions_user_id ON user_sessions(user_id)');
    await db.execute('CREATE INDEX idx_sessions_token ON user_sessions(session_token)');
    await db.execute('CREATE INDEX idx_products_category ON products(category_id)');
    await db.execute('CREATE INDEX idx_cart_user ON cart_items(user_id)');
    await db.execute('CREATE INDEX idx_orders_user ON orders(user_id)');
  }

  // ==================== PASSWORD HASHING ====================
  
  /// Hash password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password + 'museo_salt_2024'); // Thêm salt
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Verify password
  bool verifyPassword(String password, String hashedPassword) {
    return hashPassword(password) == hashedPassword;
  }

  // ==================== DATABASE UTILITIES ====================
  
  /// Đóng database
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  /// Xóa toàn bộ database (dùng cho testing)
  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app_ban_tranh.db');
    
    if (await File(path).exists()) {
      await File(path).delete();
    }
    
    _database = null;
  }

  /// Reset database (xóa và tạo lại)
  Future<void> resetDatabase() async {
    await deleteDatabase();
    _database = await _initDatabase();
  }
}
