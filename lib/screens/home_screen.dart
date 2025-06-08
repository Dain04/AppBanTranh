// lib/screens/home_screen.dart
import 'package:app_ban_tranh/models/prodcut.dart';
import 'package:app_ban_tranh/models/galleries.dart';
import 'package:app_ban_tranh/screens/productpage_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh/screens/galleriespage_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Danh sách ID tác phẩm yêu thích
  List<String> _favoriteIds = [];

  // Danh sách hình ảnh cho banner
  final List<String> _bannerImages = [
    'https://i.pinimg.com/736x/31/cd/94/31cd94a04cb4c362c67ee69419e51723.jpg',
    'https://i.pinimg.com/736x/31/cd/94/31cd94a04cb4c362c67ee69419e51723.jpg',
    'https://i.pinimg.com/736x/31/cd/94/31cd94a04cb4c362c67ee69419e51723.jpg',
    'https://i.pinimg.com/736x/31/cd/94/31cd94a04cb4c362c67ee69419e51723.jpg',
  ];

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Museo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner có Welcome
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      'https://i.pinimg.com/736x/bf/15/cb/bf15cb08f7778fecf738659673d003fc.jpg',
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          'Welcome ${widget.username}!',
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Banner with PageView
            Container(
              height: 200,
              child: Stack(
                children: [
                  // PageView for banner images
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: _bannerImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        _bannerImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  // Page indicator
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _bannerImages.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == entry.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Danh mục tác phẩm mới
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tác phẩm mới cho bạn',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductPageScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Xem thêm',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 21, 21, 21),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined,
                                size: 20,
                                color: Color.fromARGB(255, 21, 21, 21)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Danh sách tác phẩm mới
                  Container(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: homenewArtworks.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 270,
                          margin: const EdgeInsets.only(right: 16.0),
                          child: _buildHomeArtworkCard(
                            homenewArtworks[index],
                            context,
                            _isFavorite,
                            _toggleFavorite,
                          ),
                        );
                      },
                    ),
                  ),
                  // Danh sách bảo tàng
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bảo tàng ở gần bạn',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GalleriesPageScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Xem thêm',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 21, 21, 21),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined,
                                size: 20,
                                color: Color.fromARGB(255, 21, 21, 21)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      itemCount: homegalleries.length,
                      itemBuilder: (context, index) {
                        final gallery = homegalleries[index];
                        return Container(
                          width: 350,
                          margin: const EdgeInsets.only(right: 12.0),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                // Hình ảnh bảo tàng - full height
                                Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(gallery.imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      stops: const [0.5, 1.0],
                                    ),
                                  ),
                                ),
                                // Text overlay ở phía dưới
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          gallery.namegallery,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          gallery.location,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white70,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${gallery.date_start} - ${gallery.date_end}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHomeArtworkCard
  Widget _buildHomeArtworkCard(
    ArtworkItem artwork,
    BuildContext context,
    bool Function(String) isFavorite,
    void Function(String) toggleFavorite,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        //theem viền
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1.5,
        ),
        // tạo độ bóng
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị hình ảnh tác phẩm nghệ thuật
          Container(
            height: 180,
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
          // Nội dung bên dưới hình ảnh
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                      const SizedBox(height: 4),
                      // Hàng cuối: Giá và icon trái tim
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ' ${artwork.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          // Icon trái tim
                          GestureDetector(
                            onTap: () {
                              toggleFavorite(artwork.id);
                            },
                            child: Icon(
                              isFavorite(artwork.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite(artwork.id)
                                  ? Colors.red
                                  : Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ],
                      ),
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
