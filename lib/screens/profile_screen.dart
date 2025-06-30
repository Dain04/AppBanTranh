import 'package:app_ban_tranh/models/prodcut.dart';
import 'package:app_ban_tranh/screens/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Danh sách ID tác phẩm yêu thích
  List<String> _favoriteIds = [];

  // Danh sách tác phẩm trong bộ sưu tập (copy từ dữ liệu gốc)
  List<ArtworkItem> _collectionItems = List.from(GioHang_TP);

  // Hàm kiểm tra tác phẩm có được yêu thích không
  bool _isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  // Hàm toggle trạng thái yêu thích
  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
  }

  // Hàm xóa item khỏi bộ sưu tập
  void _removeFromCollection(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text(
              'Bạn có chắc chắn muốn xóa tác phẩm này khỏi bộ sưu tập?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _collectionItems.removeWhere((item) => item.id == id);
                  // Cũng xóa khỏi danh sách yêu thích nếu có
                  _favoriteIds.remove(id);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa tác phẩm khỏi bộ sưu tập'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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
                      const Text(
                        'Lê Thành Nghĩa',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Đã tham gia từ 2025',
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
                        builder: (context) => const UserInfoScreen(),
                      ),
                    );
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
                Tab(text: 'Bộ sưu tập của tôi'),
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
                // Tab 1: Bộ sưu tập của tôi
                _buildCollectionTab(),
                // Tab 2: Mục yêu thích của tôi
                _buildFavoritesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget cho tab "Bộ sưu tập của tôi"
  Widget _buildCollectionTab() {
    if (_collectionItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.collections,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Bộ sưu tập trống',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy thêm tác phẩm vào bộ sưu tập!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //2 cột
        crossAxisSpacing: 16, //khoảng cách giữa các cột
        mainAxisSpacing: 16, //khoảng cách giữa các hàng
        childAspectRatio: 0.7, //tỉ lệ chiều cao ,dài của mỗi item
      ),
      itemCount: _collectionItems.length,
      itemBuilder: (context, index) {
        return _buildArtworkCard(
          _collectionItems[index],
          context,
          _isFavorite,
          _toggleFavorite,
          _removeFromCollection,
          showDeleteButton: true, // Hiển thị nút xóa cho tab bộ sưu tập
        );
      },
    );
  }

  // Widget cho tab "Mục yêu thích của tôi"
  Widget _buildFavoritesTab() {
    // Lọc ra những tác phẩm được yêu thích từ bộ sưu tập hiện tại
    List<ArtworkItem> favoriteArtworks = _collectionItems
        .where((artwork) => _favoriteIds.contains(artwork.id))
        .toList();

    if (favoriteArtworks.isEmpty) {
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

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: favoriteArtworks.length,
      itemBuilder: (context, index) {
        return _buildArtworkCard(
          favoriteArtworks[index],
          context,
          _isFavorite,
          _toggleFavorite,
          _removeFromCollection,
          showDeleteButton: false, // Không hiển thị nút xóa cho tab yêu thích
        );
      },
    );
  }
}

// Widget để hiển thị card tác phẩm nghệ thuật
Widget _buildArtworkCard(
    ArtworkItem artwork,
    BuildContext context,
    bool Function(String) isFavorite,
    void Function(String) toggleFavorite,
    void Function(String) removeFromCollection,
    {bool showDeleteButton = false}) {
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
                    // Hàng cuối: Giá và nút xóa (nếu có)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${artwork.price} VNĐ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Nút xóa khỏi bộ sưu tập (chỉ hiển thị trong tab bộ sưu tập)
                        if (showDeleteButton)
                          GestureDetector(
                            onTap: () => removeFromCollection(artwork.id),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
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
