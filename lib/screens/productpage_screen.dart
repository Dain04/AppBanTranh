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
  final String? initialGenre; // Thêm tham số để có thể truyền thể loại ban đầu
  
  const ProductPageScreen({
    super.key,
    this.initialGenre,
  });

  @override
  State<ProductPageScreen> createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends State<ProductPageScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ArtworkItem> _allProducts = []; // Lưu tất cả sản phẩm
  List<ArtworkItem> _filteredProducts = []; // Lưu sản phẩm đã lọc
  bool _isLoading = true;
  int _selectedIndex = 0;
  final UserRepository _userRepository = UserRepository();
  String? _selectedGenre; // Thêm biến để lưu thể loại đang được chọn
  String _searchQuery = ''; // Thêm biến để lưu từ khóa tìm kiếm
  TextEditingController _searchController = TextEditingController(); // Controller cho ô tìm kiếm

  @override
  void initState() {
    super.initState();
    _selectedGenre = widget.initialGenre; // Khởi tạo thể loại từ tham số
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        ...newArtworks,
      ]);
    }

    // Lấy tất cả sản phẩm từ database
    _allProducts = await _databaseHelper.getAllProducts();
    
    // Lọc sản phẩm theo thể loại và từ khóa tìm kiếm
    _filterProducts();

    setState(() {
      _isLoading = false;
    });
  }

  // Phương thức lọc sản phẩm theo thể loại và từ khóa tìm kiếm
void _filterProducts() {
  if (_selectedGenre == null && _searchQuery.isEmpty) {
    // Nếu không có thể loại nào được chọn và không có từ khóa tìm kiếm
    _filteredProducts = List.from(_allProducts);
  } else {
    // Lọc sản phẩm theo thể loại và từ khóa tìm kiếm
    _filteredProducts = _allProducts.where((product) {
      // Kiểm tra xem thể loại có khớp không (không phân biệt hoa thường)
      bool matchesGenre = _selectedGenre == null || 
          product.genre?.toLowerCase() == _selectedGenre?.toLowerCase();
      
      // In ra thông tin để debug
      print('Product: ${product.title}, Genre: ${product.genre}, Selected: $_selectedGenre, Matches: $matchesGenre');
      
      // Kiểm tra xem từ khóa tìm kiếm có khớp không
      bool matchesSearch = _searchQuery.isEmpty || 
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.artist.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesGenre && matchesSearch;
    }).toList();
  }
  
  // In ra số lượng sản phẩm đã lọc để debug
  print('Filtered products count: ${_filteredProducts.length}');
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
        title: Text(
          _selectedGenre != null ? 'Thể loại: $_selectedGenre' : 'Tất cả tác phẩm',
          style: const TextStyle(
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
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                    _filterProducts();
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 52, 51, 51),
                              width: 1.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _filterProducts();
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Hiển thị thể loại đã chọn (nếu có)
                    if (_selectedGenre != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            const Text(
                              'Thể loại đã chọn: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Chip(
                              label: Text(_selectedGenre!),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  _selectedGenre = null;
                                  _filterProducts();
                                });
                              },
                              backgroundColor: Colors.blue.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),

                    // Artwork Categories Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Text(
                            'Thể loại nghệ thuật',
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
                                  genre.name, 
                                  genre.imagePath,
                                  isSelected: _selectedGenre == genre.name,
                                  onTap: () {
                                    setState(() {
                                      // Nếu đã chọn thể loại này, bỏ chọn
                                      if (_selectedGenre == genre.name) {
                                        _selectedGenre = null;
                                      } else {
                                        _selectedGenre = genre.name;
                                      }
                                      _filterProducts();
                                    });
                                  },
                                );
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
                                Row(
                                  mainAxisAlignment: 
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedGenre != null 
                                          ? 'Tác phẩm thể loại $_selectedGenre' 
                                          : 'Tất cả tác phẩm',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${_filteredProducts.length} tác phẩm',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
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

                          // Hiển thị thông báo khi không có sản phẩm
                          if (_filteredProducts.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Không tìm thấy sản phẩm',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _selectedGenre != null
                                          ? 'Không có sản phẩm nào thuộc thể loại $_selectedGenre'
                                          : 'Không tìm thấy sản phẩm phù hợp với từ khóa tìm kiếm',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Danh sách các tác phẩm nghệ thuật đã lọc
                          if (_filteredProducts.isNotEmpty)
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
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                return _buildArtworkCard(
                                    context, _filteredProducts[index]);
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
              child: Stack(
                children: [
                  Container(
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
                  // Hiển thị badge thể loại
                  if (artwork.genre != null && artwork.genre!.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          artwork.genre!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
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

  // Cập nhật Widget cho danh sách thể loại nghệ thuật
  Widget _buildCategoryItem(String title, String imagePath, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
                    isSelected
                        ? Colors.black.withOpacity(0.2)
                        : Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
                // Thêm viền khi được chọn
                border: isSelected
                    ? Border.all(color: Colors.blue, width: 3)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: Colors.white,
                    fontSize: isSelected ? 16 : 14,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Đã chọn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
