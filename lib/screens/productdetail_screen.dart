// lib/screens/productdetail_screen.dart
import 'package:app_ban_tranh/screens/product_for_category_screen.dart';
import 'package:app_ban_tranh/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh/models/prodcut.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ArtworkItem? currentArtwork;
  int selectedImageIndex = 0;
  PageController pageController = PageController();
  ScrollController thumbnailScrollController = ScrollController();

  // Danh sách ID tác phẩm yêu thích
  List<String> _favoriteIds = [];

  // Hàm lấy danh sách tác phẩm tương tự (cùng category)
  List<ArtworkItem> _getSimilarArtworks() {
    if (currentArtwork == null) return [];

    // Kết hợp cả hai danh sách artwork
    List<ArtworkItem> allArtworks = [...newArtworks, ...homenewArtworks];

    // Lọc các tác phẩm có cùng category và loại bỏ tác phẩm hiện tại
    List<ArtworkItem> similarArtworks = allArtworks.where((artwork) {
      return artwork.category == currentArtwork!.category &&
          artwork.id != currentArtwork!.id;
    }).toList();

    // Trộn ngẫu nhiên và lấy tối đa 10 sản phẩm
    similarArtworks.shuffle();
    return similarArtworks.take(10).toList();
  }

  // Danh sách giỏ hàng (có thể chuyển thành state management sau này)
  List<String> _cartItems = [];
  
  final List<String> images = [
    'assets/images/bh2.jpg',
    'assets/images/bh2.jpg',
    'assets/images/flowerstyle.jpg',
    'assets/images/bh1.jpg',
    'assets/images/flowerstyle.jpg',
    'assets/images/bh1.jpg',
    'assets/images/bh2.jpg',
    'assets/images/flowerstyle.jpg',
    'assets/images/bh2.jpg',
    'assets/images/bh2.jpg',
    'assets/images/flowerstyle.jpg',
    'assets/images/bh1.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _findArtworkById();
  }

  void _findArtworkById() {
    try {
      currentArtwork = newArtworks.firstWhere(
        (artwork) => artwork.id == widget.productId,
      );
    } catch (e) {
      try {
        currentArtwork = homenewArtworks.firstWhere(
          (artwork) => artwork.id == widget.productId,
        );
      } catch (e) {
        currentArtwork = null;
      }
    }
  }

  // Hàm kiểm tra tác phẩm có được yêu thích không
  bool _isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  // Hàm toggle trạng thái yêu thích
  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa khỏi danh sách yêu thích'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        _favoriteIds.add(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã thêm vào danh sách yêu thích'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  // Hàm thêm vào giỏ hàng
  void _addToCart(String id) {
    setState(() {
      if (!_cartItems.contains(id)) {
        _cartItems.add(id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã thêm "${currentArtwork!.title}" vào giỏ hàng'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sản phẩm đã có trong giỏ hàng'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  void _onThumbnailTap(int index) {
    setState(() {
      selectedImageIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    if (thumbnailScrollController.hasClients) {
      final screenWidth = MediaQuery.of(context).size.width;
      const itemWidth = 80.0;
      const itemSpacing = 16.0;

      final targetOffset = (index * (itemWidth + itemSpacing)) -
          (screenWidth / 2) +
          (itemWidth / 2);

      final maxScrollExtent =
          thumbnailScrollController.position.maxScrollExtent;
      final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

      thumbnailScrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Icon favorite
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                _isFavorite(currentArtwork?.id ?? '')
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _isFavorite(currentArtwork?.id ?? '')
                    ? Colors.red
                    : Colors.black,
                size: 28,
              ),
              onPressed: () {
                if (currentArtwork != null) {
                  _toggleFavorite(currentArtwork!.id);
                }
              },
            ),
          ),
          // Icon cart - ĐÃ SỬA: Chuyển đến CartScreen
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                ),
                // Badge hiển thị số lượng items trong cart
                if (_cartItems.isNotEmpty)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${_cartItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        toolbarHeight: 60,
        leadingWidth: 70,
      ),
      body: currentArtwork == null
          ? const Center(
              child: Text(
                'Product not found',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    currentArtwork!.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Hình ảnh sản phẩm
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ảnh nền - nằm dưới cùng
                        Container(
                          width: 330,
                          height: 430,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/khunggo.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Container chứa PageView - nằm trên ảnh nền
                        Container(
                          width: 260,
                          height: 360,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: PageView.builder(
                            controller: pageController,
                            onPageChanged: (index) {
                              setState(() {
                                selectedImageIndex = index;
                              });
                            },
                            itemCount: currentArtwork!.allImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        currentArtwork!.allImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Slider ảnh nhỏ
                  if (currentArtwork!.allImages.length > 1)
                    Center(
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: currentArtwork!.allImages.length <= 4
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  currentArtwork!.allImages.length,
                                  (index) {
                                    final isSelected =
                                        index == selectedImageIndex;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      width: 64,
                                      height: isSelected ? 80 : 64,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () => _onThumbnailTap(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.grey.shade300,
                                              width: isSelected ? 2 : 1,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(currentArtwork!
                                                  .allImages[index]),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 6,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : ListView.builder(
                                controller: thumbnailScrollController,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: currentArtwork!.allImages.length,
                                itemBuilder: (context, index) {
                                  final isSelected =
                                      index == selectedImageIndex;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    width: 64,
                                    height: isSelected ? 80 : 64,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () => _onThumbnailTap(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.black
                                                : Colors.grey.shade300,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(currentArtwork!
                                                .allImages[index]),
                                            fit: BoxFit.cover,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Chỉ số ảnh hiện tại
                  if (currentArtwork!.allImages.length > 1)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          currentArtwork!.allImages.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == selectedImageIndex
                                  ? Colors.black
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Thông tin sản phẩm
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Tác giả: ${currentArtwork!.artist}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 13, 13, 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Giá: ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '${currentArtwork!.price}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Row chứa nút favorite và add to cart
                  Row(
                    children: [
                      // Nút favorite
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              _toggleFavorite(currentArtwork!.id);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: _isFavorite(currentArtwork!.id)
                                    ? Colors.red
                                    : Colors.grey,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Icon(
                              _isFavorite(currentArtwork!.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorite(currentArtwork!.id)
                                  ? Colors.red
                                  : Colors.grey[600],
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Nút thêm vào giỏ hàng
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _addToCart(currentArtwork!.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              'Thêm vào giỏ hàng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Dòng kẻ
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 1.5,
                      width: 250,
                      color: const Color.fromARGB(255, 89, 90, 90),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    '"${currentArtwork!.description}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 13, 13, 13),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dòng kẻ
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 1.5,
                      width: 200,
                      color: const Color.fromARGB(255, 89, 90, 90),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Chi tiết tác phẩm nghệ thuật',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Sử dụng Stack và Positioned cho Text
                      SizedBox(
                        height: 150,
                        child: Stack(
                          children: [
                            // Text chất liệu
                            Positioned(
                              left: 20,
                              top: 0,
                              child: Text(
                                'Chất liệu: ${currentArtwork!.material}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),

                            // Đường kẻ đầu tiên
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 25,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 1,
                                  width: 350,
                                  color: const Color.fromARGB(255, 89, 90, 90),
                                ),
                              ),
                            ),

                            // Text năm sáng tác
                            Positioned(
                              left: 20,
                              top: 40,
                              child: Text(
                                'Năm sáng tác: ${currentArtwork!.yearcreated}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),

                            // Đường kẻ thứ hai
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 65,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 1,
                                  width: 350,
                                  color: const Color.fromARGB(255, 89, 90, 90),
                                ),
                              ),
                            ),

                            // Text thể loại
                            Positioned(
                              left: 20,
                              top: 80,
                              child: Text(
                                'Thể loại: ${currentArtwork!.category}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),

                            // Đường kẻ thứ ba
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 105,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 1,
                                  width: 350,
                                  color: const Color.fromARGB(255, 89, 90, 90),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Staggered grid view Bộ sưu tập
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bộ sưu tập nổi bật',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Horizontal StaggeredGridView - Same height, different widths
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: (images.length / 4).ceil(),
                      itemBuilder: (context, groupIndex) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              // Hàng trên
                              Row(
                                children: [
                                  // Ảnh ngắn
                                  if (groupIndex * 4 < images.length)
                                    Container(
                                      width: 120,
                                      height: 115,
                                      margin: const EdgeInsets.only(
                                          right: 8, bottom: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          images[groupIndex * 4],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                  // Ảnh dài
                                  if (groupIndex * 4 + 1 < images.length)
                                    Container(
                                      width: 180,
                                      height: 115,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          images[groupIndex * 4 + 1],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              // Hàng dưới
                              Row(
                                children: [
                                  // Ảnh dài
                                  if (groupIndex * 4 + 2 < images.length)
                                    Container(
                                      width: 180,
                                      height: 115,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          images[groupIndex * 4 + 2],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                  // Ảnh ngắn
                                  if (groupIndex * 4 + 3 < images.length)
                                    Container(
                                      width: 120,
                                      height: 115,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          images[groupIndex * 4 + 3],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/collection');
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Xem thêm bộ sưu tập',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 107, 108, 109),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Color.fromARGB(255, 107, 108, 109),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),

                  // Dòng kẻ
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 1.5,
                        width: 170,
                        color: const Color.fromARGB(255, 89, 90, 90),
                      ),
                    ),
                  
                  ),
                  const SizedBox(height: 30),

                  // Sản phẩm tương tự
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sản phẩm tương tự',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grid sản phẩm tương tự
                  _buildSimilarProducts(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // Widget hiển thị sản phẩm tương tự
  Widget _buildSimilarProducts() {
    List<ArtworkItem> similarArtworks = _getSimilarArtworks();

    if (similarArtworks.isEmpty) {
      return const Center(
        child: Text(
          'Không có sản phẩm tương tự',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: similarArtworks.length > 6 ? 6 : similarArtworks.length,
      itemBuilder: (context, index) {
        final artwork = similarArtworks[index];
        return _buildSimilarProduct(artwork);
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    thumbnailScrollController.dispose();
    super.dispose();
  }
}

// Widget cho từng sản phẩm tương tự
Widget _buildSimilarProduct(ArtworkItem artwork) {
  return Builder(
    builder: (context) {
      return GestureDetector(
        onTap: () {
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh sản phẩm
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
              
              // Thông tin sản phẩm
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tên sản phẩm
                      Text(
                        artwork.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Tác giả
                      Text(
                        'Tác giả: ${artwork.artist}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Giá
                      Text(
                        artwork.price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
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
  );
}
