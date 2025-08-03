// lib/repositories/cart_repository.dart
import 'package:app_ban_tranh/database/database_helper.dart';
import 'package:app_ban_tranh/models/cart.dart';
import 'package:app_ban_tranh/models/prodcut.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class CartRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final _cartStreamController = StreamController<List<CartArtworkItem>>.broadcast();
  
  // Getter để lấy stream của giỏ hàng
  Stream<List<CartArtworkItem>> get cartStream => _cartStreamController.stream;
  
  // Constructor
  CartRepository() {
    // Khởi tạo stream với dữ liệu ban đầu
    _initCartStream();
  }
  
  // Khởi tạo stream với dữ liệu từ database
  Future<void> _initCartStream() async {
    final cartItems = await getCartItems();
    _cartStreamController.add(cartItems);
  }
  
Future<List<CartArtworkItem>> getCartItems() async {
  try {
    final db = await _databaseHelper.database;
    
    // Lấy tất cả sản phẩm trong giỏ hàng
    final List<Map<String, dynamic>> cartMaps = await db.query(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: ['current_user'],
    );
    
    if (cartMaps.isEmpty) {
      return []; // Trả về danh sách rỗng nếu giỏ hàng trống
    }
    
    // Chuyển đổi từ Map sang CartArtworkItem
    List<CartArtworkItem> cartItems = [];
    
    for (var cartMap in cartMaps) {
      // Lấy thông tin sản phẩm từ bảng products
      final List<Map<String, dynamic>> productMaps = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [cartMap['product_id']],
      );
      
      if (productMaps.isNotEmpty) {
        final productMap = productMaps.first;
        
        // Xử lý giá tiền từ database
        String priceStr;
        if (productMap['price'] != null) {
          // Lấy giá từ database
          double priceValue = 0.0;
          
          if (productMap['price'] is double) {
            priceValue = productMap['price'];
          } else if (productMap['price'] is int) {
            priceValue = productMap['price'].toDouble();
          } else {
            priceValue = double.tryParse(productMap['price'].toString()) ?? 0.0;
          }
          
          // In ra để debug
          print('Giá từ database: $priceValue');
          
          // Định dạng giá tiền với dấu phân cách hàng nghìn
          priceStr = _formatPrice(priceValue.toInt().toString());
        } else {
          priceStr = '0';
        }
        
        cartItems.add(CartArtworkItem(
          id: cartMap['id'].toString(),
          title: productMap['name'] ?? '',
          artist: productMap['artist'] ?? '',
          price: priceStr,
          imagePath: productMap['image_url'] ?? '',
          material: productMap['material'],
          yearcreated: productMap['year_created'],
        ));
      }
    }
    
    return cartItems;
  } catch (e) {
    print('Lỗi khi lấy giỏ hàng: $e');
    // Nếu có lỗi, trả về danh sách mẫu
    return cartArtworkItems;
  }
}

// Thêm phương thức định dạng giá tiền
String _formatPrice(String price) {
  final numPrice = int.tryParse(price) ?? 0;
  return numPrice.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}

  
Future<bool> addToCart(ArtworkItem artwork) async {
  try {
    final db = await _databaseHelper.database;
    
    // Xử lý giá tiền từ chuỗi sang số
    double priceValue = 0.0;
    
    // Xử lý trường hợp giá là số thập phân (như 140000000.0)
    if (artwork.price.contains('.')) {
      priceValue = double.tryParse(artwork.price) ?? 0.0;
    }
    // Xử lý trường hợp giá có định dạng VNĐ
    else if (artwork.price.contains('VNĐ')) {
      String priceStr = artwork.price.replaceAll('VNĐ', '').trim();
      priceStr = priceStr.replaceAll('.', '').replaceAll(',', '');
      priceValue = double.tryParse(priceStr) ?? 0.0;
    }
    // Xử lý các trường hợp khác
    else if (artwork.price != 'Price on request') {
      String priceStr = artwork.price.replaceAll('.', '').replaceAll(',', '');
      priceValue = double.tryParse(priceStr) ?? 0.0;
    }
    
    // In ra giá trị để debug
    print('Giá gốc: ${artwork.price}');
    print('Giá đã chuyển đổi: $priceValue');
    
    // Kiểm tra xem sản phẩm đã có trong database chưa
    final List<Map<String, dynamic>> productMaps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [artwork.id],
    );
    
    // Nếu sản phẩm chưa có trong database, thêm vào
    if (productMaps.isEmpty) {
      await db.insert('products', {
        'id': artwork.id,
        'name': artwork.title,
        'description': artwork.description,
        'price': priceValue,
        'image_url': artwork.imagePath,
        'artist': artwork.artist,
        'material': artwork.material ?? '',
        'year_created': artwork.yearcreated ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'category_id': artwork.category,
        'stock_quantity': 1,
        'is_featured': 0,
      });
    } else {
      // Nếu sản phẩm đã có, cập nhật giá nếu cần
      await db.update(
        'products',
        {'price': priceValue},
        where: 'id = ?',
        whereArgs: [artwork.id],
      );
    }
    
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final List<Map<String, dynamic>> existingItems = await db.query(
      'cart_items',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: ['current_user', artwork.id],
    );
    
    if (existingItems.isNotEmpty) {
      // Nếu sản phẩm đã tồn tại, cập nhật số lượng
      final existingItem = existingItems.first;
      final int currentQuantity = existingItem['quantity'] ?? 0;
      
      await db.update(
        'cart_items',
        {
          'quantity': currentQuantity + 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [existingItem['id']],
      );
    } else {
      // Nếu sản phẩm chưa có trong giỏ hàng, thêm mới
      await db.insert('cart_items', {
        'user_id': 'current_user', // Thay thế bằng ID người dùng thực tế khi có đăng nhập
        'product_id': artwork.id,
        'quantity': 1,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
    
    // Cập nhật stream
    await _updateCartStream();
    
    return true; // Thêm lệnh return true khi thành công
  } catch (e) {
    print('Lỗi khi thêm vào giỏ hàng: $e');
    return false;
  }
}

  
  // Cập nhật số lượng sản phẩm trong giỏ hàng
  Future<bool> updateCartItemQuantity(String cartItemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        // Nếu số lượng <= 0, xóa sản phẩm khỏi giỏ hàng
        return await removeFromCart(cartItemId);
      }
      
      final db = await _databaseHelper.database;
      
      await db.update(
        'cart_items',
        {
          'quantity': newQuantity,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [cartItemId],
      );
      
      // Cập nhật stream
      _updateCartStream();
      
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật số lượng: $e');
      return false;
    }
  }
  
  // Xóa sản phẩm khỏi giỏ hàng
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.delete(
        'cart_items',
        where: 'id = ?',
        whereArgs: [cartItemId],
      );
      
      // Cập nhật stream
      _updateCartStream();
      
      return true;
    } catch (e) {
      print('Lỗi khi xóa khỏi giỏ hàng: $e');
      return false;
    }
  }
  
  // Xóa tất cả sản phẩm trong giỏ hàng
  Future<bool> clearCart() async {
    try {
      final db = await _databaseHelper.database;
      
      await db.delete(
        'cart_items',
        where: 'user_id = ?',
        whereArgs: ['current_user'], // Thay thế bằng ID người dùng thực tế khi có đăng nhập
      );
      
      // Cập nhật stream
      _updateCartStream();
      
      return true;
    } catch (e) {
      print('Lỗi khi xóa giỏ hàng: $e');
      return false;
    }
  }
  
  // Tính tổng tiền giỏ hàng
  Future<double> getCartTotal() async {
    try {
      final db = await _databaseHelper.database;
      
      // Lấy tất cả sản phẩm trong giỏ hàng với số lượng và giá
      final List<Map<String, dynamic>> cartItems = await db.rawQuery('''
        SELECT ci.quantity, p.price
        FROM cart_items ci
        JOIN products p ON ci.product_id = p.id
        WHERE ci.user_id = ?
      ''', ['current_user']); // Thay thế bằng ID người dùng thực tế khi có đăng nhập
      
      double total = 0;
      for (var item in cartItems) {
        total += (item['quantity'] ?? 0) * (item['price'] ?? 0);
      }
      
      return total;
    } catch (e) {
      print('Lỗi khi tính tổng tiền giỏ hàng: $e');
      return 0;
    }
  }
  
  // Đếm số lượng sản phẩm trong giỏ hàng
  Future<int> getCartItemCount() async {
    try {
      final db = await _databaseHelper.database;
      
      // Đếm tổng số lượng sản phẩm trong giỏ hàng
      final result = await db.rawQuery('''
        SELECT SUM(quantity) as total
        FROM cart_items
        WHERE user_id = ?
      ''', ['current_user']); // Thay thế bằng ID người dùng thực tế khi có đăng nhập
      
      return result.first['total'] as int? ?? 0;
    } catch (e) {
      print('Lỗi khi đếm số lượng sản phẩm trong giỏ hàng: $e');
      return 0;
    }
  }
  
  // Cập nhật stream giỏ hàng
  Future<void> _updateCartStream() async {
    final cartItems = await getCartItems();
    _cartStreamController.add(cartItems);
  }
  
  // Đóng stream khi không cần thiết
  void dispose() {
    _cartStreamController.close();
  }
}
