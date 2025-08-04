// lib/screens/productpage_screen.dart
import 'package:app_ban_tranh/models/genre.dart';
import 'package:app_ban_tranh/screens/productdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh/models/prodcut.dart';
import 'package:app_ban_tranh/database/database_helper.dart';
import 'package:app_ban_tranh/screens/cart_screen.dart';
import 'package:app_ban_tranh/screens/home_screen.dart';
import 'package:app_ban_tranh/screens/order_screen.dart';
import 'package:app_ban_tranh/screens/profile_screen.dart';
import 'package:app_ban_tranh/repositories/user_repository.dart';

class ProductPageScreen extends StatefulWidget {
  const ProductPageScreen({
    super.key,
  });

  @override
  State<ProductPageScreen> createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends State<ProductPageScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ArtworkItem> _products = [];
  bool _isLoading = true;
  int _selectedIndex = 0; // Thêm biến để theo dõi tab đang chọn
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Phương thức để tải sản phẩm từ database
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    // Kiểm tra xem database đã có sản phẩm chưa
    bool hasProducts = await _databaseHelper.hasProducts();

    if (!hasProducts) {
      // Nếu chưa có sản phẩm, thêm dữ liệu mẫu từ product.dart
      await _databaseHelper.insertAllProducts([
        // ...homenewArtworks,
        ...newArtworks,
        // ...DauGiaTP,
        // ...GioHang_TP
      ]);
    }

    // Lấy tất cả sản phẩm từ database
    _products = await _databaseHelper.getAllProducts();

    setState(() {
      _isLoading = false;
    });
  }

  // Phương thức xử lý khi chọn tab
  void _onItemTapped(int index) async {
    if (index != _selectedIndex) {
      // Nếu chọn tab khác với tab hiện tại
      final currentUser = await _userRepository.getCurrentUser();

      if (index == 0) {
        // Trang chủ
        if (currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(user: currentUser)),
          );
        }
      } else if (index == 1) {
        // Giỏ hàng
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      } else if (index == 2) {
        // Đơn hàng
        if (currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserOrderScreen(userId: currentUser.id)),
          );
        }
      } else if (index == 3) {
        // Cá nhân
        if (currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                user: currentUser,
                onUserUpdated: () {}, // Callback trống
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Trở lại trang chủ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Box
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 52, 51, 51),
                              width: 1.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (value) {
                        print('Tìm kiếm: $value');
                      },
                    ),
                    const SizedBox(height: 20),

                    // Artwork Categories Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Text(
                            'Thể loại nghệ thuật',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: homeGalleries.map((genre) {
                                return _buildCategoryItem(
                                    genre.name, genre.imagePath);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    //___________________________________new artwork section_________________________
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tác phẩm mới',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // dòng kẻ màu xanh
                                Container(
                                  height: 3,
                                  width: 120,
                                  color: Colors.blue,
                                ),
                              ]),
                          const SizedBox(height: 20),

                          /// Danh sách các tác phẩm nghệ thuật từ database
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 0.55,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              return _buildArtworkCard(
                                  context, _products[index]);
                            },
                          )
                        ])
                  ],
                ),
              ),
            ),
      // Thêm BottomNavigationBar giống như trong main_screen.dart
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

  Widget _buildArtworkCard(BuildContext context, ArtworkItem artwork) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Thêm viền và bóng đổ
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1.5,
        ),
        // Bóng đổ nhẹ
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4), // Vị trí bóng đổ
            spreadRadius: 2, // Độ lan tỏa của bóng đổ
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị hình ảnh tác phẩm nghệ thuật
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                // Navigation đến ProductDetailScreen với productId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      productId: artwork.id,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: AssetImage(artwork.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          //nội dung bên dưới hình ảnh
          Expanded(
            flex: 2, // Giữ nguyên tỷ lệ cho phần thông tin
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //tiêu đề & thông tin tác phẩm nghệ thuật
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artwork.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Artist: ${artwork.artist}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Đoạn code đã được sửa - Hiển thị giá tiền
                      Text(
                        'Price: ${_formatPrice(artwork.price)} VNĐ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  //Nút xem chi tiết và nút thêm vào giỏ hàng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 146, // Đặt chiều rộng cố định cho nút
                        height: 32,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  productId: artwork.id,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Xem chi tiết',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                size: 12,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget cho danh sách thể loại nghệ thuật
Widget _buildCategoryItem(String title, String imagePath) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

// Thêm hàm định dạng giá tiền - giống hàm trong productdetail_screen.dart
String _formatPrice(String price) {
  // Xử lý trường hợp giá có định dạng số thập phân
  if (price.contains('.')) {
    double? priceValue = double.tryParse(price);
    if (priceValue != null) {
      return priceValue.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          );
    }
  }

  // Xử lý trường hợp giá đã có định dạng VNĐ
  if (price.contains('VNĐ')) {
    String priceStr = price.replaceAll('VNĐ', '').trim();
    return priceStr;
  }

  // Xử lý các trường hợp khác
  if (price != 'Price on request') {
    String priceStr = price.replaceAll('.', '').replaceAll(',', '');
    int? numPrice = int.tryParse(priceStr);
    if (numPrice != null) {
      return numPrice.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          );
    }
  }

  // Trả về giá gốc nếu không xử lý được
  return price;
}
