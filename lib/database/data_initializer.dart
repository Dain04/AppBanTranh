// lib/helpers/data_initializer.dart
import 'package:app_ban_tranh/database/database_helper.dart';
import 'package:app_ban_tranh/models/prodcut.dart';

class DataInitializer {
  static final DataInitializer _instance = DataInitializer._internal();
  factory DataInitializer() => _instance;
  DataInitializer._internal();
  
  bool _initialized = false;
  
  Future<void> initializeData() async {
    if (_initialized) return;
    
    final databaseHelper = DatabaseHelper();
    
    // Kiểm tra xem database đã có sản phẩm chưa
    bool hasProducts = await databaseHelper.hasProducts();
    
    if (!hasProducts) {
      // Nếu chưa có sản phẩm, thêm dữ liệu mẫu từ product.dart
      await databaseHelper.insertAllProducts([
        ...homenewArtworks,
        ...newArtworks,
        ...DauGiaTP,
      ]);
      
      print('Đã khởi tạo dữ liệu sản phẩm');
    } else {
      print('Dữ liệu sản phẩm đã tồn tại');
    }
    
    _initialized = true;
  }
}
