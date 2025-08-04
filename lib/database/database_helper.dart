// lib/database/database_helper.dart
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_ban_tranh/models/prodcut.dart';

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

    // Xóa database cũ nếu tồn tại để đảm bảo schema mới nhất
    if (await File(path).exists()) {
      await File(path).delete();
      print('Đã xóa database cũ');
    }

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
        artist TEXT,
        material TEXT,
        year_created TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // Tạo bảng product_images để lưu ảnh phụ
    await db.execute('''
      CREATE TABLE product_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        image_url TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
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
    await db
        .execute('CREATE INDEX idx_sessions_user_id ON user_sessions(user_id)');
    await db.execute(
        'CREATE INDEX idx_sessions_token ON user_sessions(session_token)');
    await db
        .execute('CREATE INDEX idx_products_category ON products(category_id)');
    await db.execute('CREATE INDEX idx_cart_user ON cart_items(user_id)');
    await db.execute('CREATE INDEX idx_orders_user ON orders(user_id)');
  }

  // ==================== PASSWORD HASHING ====================

  /// Hash password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode('${password}museo_salt_2024'); // Thêm salt
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify password
  bool verifyPassword(String password, String hashedPassword) {
    return hashPassword(password) == hashedPassword;
  }

  // ==================== PRODUCT METHODS ====================

  /// Kiểm tra và đảm bảo cấu trúc bảng products
  Future<void> _ensureProductTableStructure() async {
    try {
      final db = await database;

      // Kiểm tra xem bảng products có tồn tại không
      var tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='products'");
      if (tables.isEmpty) {
        print('Bảng products không tồn tại, đang tạo lại...');
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
            artist TEXT,
            material TEXT,
            year_created TEXT,
            FOREIGN KEY (category_id) REFERENCES categories (id)
          )
        ''');
        return;
      }

      // Kiểm tra cấu trúc của bảng products
      var columns = await db.rawQuery("PRAGMA table_info(products)");

      // Kiểm tra từng cột
      bool hasArtistColumn =
          columns.any((column) => column['name'] == 'artist');
      bool hasMaterialColumn =
          columns.any((column) => column['name'] == 'material');
      bool hasYearCreatedColumn =
          columns.any((column) => column['name'] == 'year_created');

      // Thêm các cột nếu chưa tồn tại
      if (!hasArtistColumn) {
        print('Thêm cột artist vào bảng products');
        await db.execute('ALTER TABLE products ADD COLUMN artist TEXT');
      }

      if (!hasMaterialColumn) {
        print('Thêm cột material vào bảng products');
        await db.execute('ALTER TABLE products ADD COLUMN material TEXT');
      }

      if (!hasYearCreatedColumn) {
        print('Thêm cột year_created vào bảng products');
        await db.execute('ALTER TABLE products ADD COLUMN year_created TEXT');
      }
    } catch (e) {
      print('Lỗi khi kiểm tra cấu trúc bảng: $e');
      // Nếu có lỗi, xóa và tạo lại database
      await resetDatabase();
    }
  }

  /// Thêm một sản phẩm vào database
  Future<int> insertProduct(ArtworkItem artwork) async {
    // Đảm bảo cấu trúc bảng đúng trước khi thêm dữ liệu
    await _ensureProductTableStructure();

    final db = await database;

    // Chuẩn bị dữ liệu để insert
    Map<String, dynamic> productData = {
      'name': artwork.title,
      'description': artwork.description,
      'price':
          double.tryParse(artwork.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
              0.0,
      'image_url': artwork.imagePath,
      'artist': artwork.artist,
      'material': artwork.material ?? '',
      'year_created': artwork.yearcreated ?? '',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'category_id': null, // Sẽ cập nhật sau khi có category
      'stock_quantity': 1,
      'is_featured': 0,
    };

    try {
      // Thêm sản phẩm vào database
      int productId = await db.insert('products', productData);

      // Thêm các ảnh phụ (nếu có)
      if (artwork.additionalImages.isNotEmpty) {
        for (String imageUrl in artwork.additionalImages) {
          await db.insert('product_images', {
            'product_id': productId,
            'image_url': imageUrl,
          });
        }
      }

      return productId;
    } catch (e) {
      print('Lỗi khi thêm sản phẩm: $e');
      throw e; // Re-throw để caller có thể xử lý
    }
  }

  /// Thêm danh sách sản phẩm vào database
  Future<void> insertAllProducts(List<ArtworkItem> artworks) async {
    // Đảm bảo cấu trúc bảng đúng trước khi thêm dữ liệu
    await _ensureProductTableStructure();

    final db = await database;

    try {
      // Bắt đầu transaction để tối ưu hiệu suất
      await db.transaction((txn) async {
        for (var artwork in artworks) {
          // Chuẩn bị dữ liệu để insert
          Map<String, dynamic> productData = {
            'name': artwork.title,
            'description': artwork.description,
            'price': double.tryParse(
                    artwork.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
                0.0,
            'image_url': artwork.imagePath,
            'artist': artwork.artist,
            'material': artwork.material ?? '',
            'year_created': artwork.yearcreated ?? '',
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
            'category_id': null, // Sẽ cập nhật sau khi có category
            'stock_quantity': 1,
            'is_featured': 0,
          };

          // Thêm sản phẩm vào database
          int productId = await txn.insert('products', productData);

          // Thêm các ảnh phụ (nếu có)
          if (artwork.additionalImages.isNotEmpty) {
            for (String imageUrl in artwork.additionalImages) {
              await txn.insert('product_images', {
                'product_id': productId,
                'image_url': imageUrl,
              });
            }
          }
        }
      });
      print('Đã thêm ${artworks.length} sản phẩm vào database');
    } catch (e) {
      print('Lỗi khi thêm danh sách sản phẩm: $e');
      // Nếu có lỗi, thử xóa và tạo lại database
      print('Đang thử xóa và tạo lại database...');
      await resetDatabase();

      // Thử lại một lần nữa
      try {
        final db = await database;
        await db.transaction((txn) async {
          for (var artwork in artworks) {
            Map<String, dynamic> productData = {
              'name': artwork.title,
              'description': artwork.description,
              'price': double.tryParse(
                      artwork.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
                  0.0,
              'image_url': artwork.imagePath,
              'artist': artwork.artist,
              'material': artwork.material ?? '',
              'year_created': artwork.yearcreated ?? '',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
              'category_id': null,
              'stock_quantity': 1,
              'is_featured': 0,
            };

            int productId = await txn.insert('products', productData);

            if (artwork.additionalImages.isNotEmpty) {
              for (String imageUrl in artwork.additionalImages) {
                await txn.insert('product_images', {
                  'product_id': productId,
                  'image_url': imageUrl,
                });
              }
            }
          }
        });
        print(
            'Đã thêm ${artworks.length} sản phẩm vào database sau khi tạo lại');
      } catch (e2) {
        print('Vẫn xảy ra lỗi sau khi tạo lại database: $e2');
        throw e2;
      }
    }
  }

  /// Lấy tất cả sản phẩm từ database
  Future<List<ArtworkItem>> getAllProducts() async {
    try {
      final db = await database;

      // Lấy tất cả sản phẩm
      final List<Map<String, dynamic>> productMaps = await db.query('products');

      if (productMaps.isEmpty) {
        return [];
      }

      // Chuyển đổi từ Map sang ArtworkItem
      return Future.wait(productMaps.map((productMap) async {
        // Lấy các ảnh phụ của sản phẩm
        final List<Map<String, dynamic>> imageMaps = await db.query(
          'product_images',
          where: 'product_id = ?',
          whereArgs: [productMap['id']],
        );

        List<String> additionalImages = imageMaps
            .map((imageMap) => imageMap['image_url'] as String)
            .toList();

        // Tạo đối tượng ArtworkItem
        return ArtworkItem(
          id: productMap['id'].toString(),
          title: productMap['name'] ?? '',
          artist: productMap['artist'] ?? '',
          price: productMap['price']?.toString() ?? '0',
          description: productMap['description'] ?? '',
          imagePath: productMap['image_url'] ?? '',
          material: productMap['material'],
          yearcreated: productMap['year_created'],
          genre: '', // Sẽ cập nhật sau khi có category
          additionalImages: additionalImages,
        );
      }).toList());
    } catch (e) {
      print('Lỗi khi lấy tất cả sản phẩm: $e');
      return [];
    }
  }

  /// Lấy sản phẩm theo ID
  Future<ArtworkItem?> getProductById(String id) async {
    try {
      final db = await database;

      // Lấy sản phẩm theo ID
      final List<Map<String, dynamic>> productMaps = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (productMaps.isEmpty) {
        return null;
      }

      // Lấy các ảnh phụ của sản phẩm
      final List<Map<String, dynamic>> imageMaps = await db.query(
        'product_images',
        where: 'product_id = ?',
        whereArgs: [id],
      );

      List<String> additionalImages =
          imageMaps.map((imageMap) => imageMap['image_url'] as String).toList();

      // Tạo đối tượng ArtworkItem
      return ArtworkItem(
        id: productMaps.first['id'].toString(),
        title: productMaps.first['name'] ?? '',
        artist: productMaps.first['artist'] ?? '',
        price: productMaps.first['price']?.toString() ?? '0',
        description: productMaps.first['description'] ?? '',
        imagePath: productMaps.first['image_url'] ?? '',
        material: productMaps.first['material'],
        yearcreated: productMaps.first['year_created'],
        genre: '', // Sẽ cập nhật sau khi có category
        additionalImages: additionalImages,
      );
    } catch (e) {
      print('Lỗi khi lấy sản phẩm theo ID: $e');
      return null;
    }
  }

  /// Kiểm tra xem database đã có sản phẩm chưa
  Future<bool> hasProducts() async {
    try {
      final db = await database;
      final result =
          await db.rawQuery('SELECT COUNT(*) as count FROM products');
      int count = Sqflite.firstIntValue(result) ?? 0;
      return count > 0;
    } catch (e) {
      print('Lỗi khi kiểm tra sản phẩm: $e');
      return false;
    }
  }

  // ==================== DATABASE UTILITIES ====================

  /// Đóng database
  Future<void> close() async {
    if (_database != null) {
      final db = await database;
      await db.close();
      _database = null;
    }
  }

  /// Xóa toàn bộ database (dùng cho testing)
  Future<void> deleteDatabase() async {
    try {
      // Đóng database nếu đang mở
      await close();

      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'app_ban_tranh.db');

      if (await File(path).exists()) {
        await File(path).delete();
        print('Đã xóa database');
      }

      _database = null;
    } catch (e) {
      print('Lỗi khi xóa database: $e');
    }
  }

  /// Reset database (xóa và tạo lại)
  Future<void> resetDatabase() async {
    await deleteDatabase();
    _database = await _initDatabase();
    print('Đã reset database');
  }
}
