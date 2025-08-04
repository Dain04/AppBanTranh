// lib/screens/profile_screen.dart
import 'package:app_ban_tranh/models/prodcut.dart';
import 'package:app_ban_tranh/models/user.dart';
import 'package:app_ban_tranh/screens/user_info_screen.dart';
import 'package:app_ban_tranh/screens/productdetail_screen.dart';
import 'package:app_ban_tranh/repositories/favorite_repository.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final VoidCallback? onUserUpdated;

  const ProfileScreen({
    Key? key,
    required this.user,
    this.onUserUpdated,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoriteRepository _favoriteRepository = FavoriteRepository();
  
  // Danh sách ID tác phẩm yêu thích
  List<String> _favoriteIds = [];
  
  // Danh sách tác phẩm yêu thích
  List<ArtworkItem> _favoriteArtworks = [];
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadFavorites();
  }

  // Phương thức tải danh sách yêu thích
  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Lấy danh sách ID yêu thích
      _favoriteIds = await _favoriteRepository.getFavoriteIds();
      
      // Lọc ra các tác phẩm yêu thích từ tất cả tác phẩm
      _favoriteArtworks = _allArtworks
          .where((artwork) => _favoriteIds.contains(artwork.id))
          .toList();
    } catch (e) {
      print('Lỗi khi tải danh sách yêu thích: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Danh sách tất cả tác phẩm có thể yêu thích
  List<ArtworkItem> get _allArtworks {
    List<ArtworkItem> allItems = [];
    allItems.addAll(homenewArtworks);
    allItems.addAll(newArtworks);
    return allItems;
  }

  // Hàm kiểm tra tác phẩm có được yêu thích không
  bool _isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  // Hàm toggle trạng thái yêu thích
  Future<void> _toggleFavorite(String id) async {
    final success = await _favoriteRepository.toggleFavorite(id);
    
    if (success) {
      await _loadFavorites(); // Tải lại danh sách sau khi thay đổi
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Profile header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email: ${widget.user.email}',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon cài đặt
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInfoScreen(
                          user: widget.user,
                        ),
                      ),
                    ).then((_) {
                      // Refresh data khi quay lại
                      if (widget.onUserUpdated != null) {
                        widget.onUserUpdated!();
                      }
                    });
                  },
                  icon: const Icon(Icons.settings, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Tab bar
          Container(
            color: Colors.white,
            child: TabBar(
              tabs: const [
                Tab(text: 'Mục yêu thích của tôi'),
              ],
              controller: _tabController,
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // TabBarView để hiển thị nội dung theo tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab: Mục yêu thích của tôi
                _buildFavoritesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget cho tab "Mục yêu thích của tôi"
  Widget _buildFavoritesTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_favoriteArtworks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có tác phẩm yêu thích',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy thêm tác phẩm vào danh sách yêu thích!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: _favoriteArtworks.length,
        itemBuilder: (context, index) {
          final artwork = _favoriteArtworks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    productId: artwork.id,
                  ),
                ),
              ).then((_) {
                // Tải lại danh sách yêu thích khi quay lại
                _loadFavorites();
              });
            },
            child: _buildArtworkCard(
              artwork,
              context,
              _isFavorite,
              _toggleFavorite,
            ),
          );
        },
      ),
    );
  }
}

// Widget để hiển thị card tác phẩm nghệ thuật
Widget _buildArtworkCard(
    ArtworkItem artwork,
    BuildContext context,
    bool Function(String) isFavorite,
    Future<void> Function(String) toggleFavorite,
    ) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.grey.withOpacity(0.3),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 2,
        ),
      ],
    ),
    child: Stack(
      // Sử dụng Stack để đặt icon favorite ở góc
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị hình ảnh tác phẩm nghệ thuật
            Expanded(
              flex: 3,
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
            // Nội dung bên dưới hình ảnh
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tiêu đề & thông tin tác phẩm nghệ thuật
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
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Hiển thị giá - ĐÃ CẬP NHẬT: Sử dụng _formatPrice
                    Text(
                      '${_formatPrice(artwork.price)} VNĐ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Icon favorite được đặt ở góc trên bên phải
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => toggleFavorite(artwork.id),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isFavorite(artwork.id) ? Icons.favorite : Icons.favorite_border,
                color: isFavorite(artwork.id) ? Colors.red : Colors.grey[600],
                size: 20,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Thêm hàm _formatPrice vào cuối file profile_screen.dart
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
  // Trả về giá gốc nếu không xử lý được
  return price;
}
