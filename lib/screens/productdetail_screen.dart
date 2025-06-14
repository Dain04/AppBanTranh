import 'package:flutter/material.dart';
import 'package:app_ban_tranh/models/prodcut.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId; // Thêm productId parameter

  const ProductDetailScreen({
    Key? key,
    required this.productId, // Required parameter
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ArtworkItem? currentArtwork;
  int selectedImageIndex = 0; // Biến để lưu chỉ số hình ảnh được chọn
  PageController pageController = PageController(); // Controller cho PageView
  ScrollController thumbnailScrollController = ScrollController(); //

  @override
  void initState() {
    super.initState();
    // Tìm artwork theo ID từ dữ liệu mẫu
    _findArtworkById();
  }

  void _findArtworkById() {
    // Tìm trong danh sách newArtworks trước
    try {
      currentArtwork = newArtworks.firstWhere(
        (artwork) => artwork.id == widget.productId,
      );
    } catch (e) {
      // Nếu không tìm thấy trong newArtworks, tìm trong homenewArtworks
      try {
        currentArtwork = homenewArtworks.firstWhere(
          (artwork) => artwork.id == widget.productId,
        );
      } catch (e) {
        // Không tìm thấy artwork nào
        currentArtwork = null;
      }
    }
  }

  // Hàm xử lý khi người dùng nhấn vào hình thu nhỏ
  void _onThumbnailTap(int index) {
    setState(() {
      selectedImageIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Scroll thumbnail để ảnh được chọn nằm giữa
    if (thumbnailScrollController.hasClients) {
      final screenWidth = MediaQuery.of(context).size.width;

      // Kích thước của mỗi thumbnail item (bao gồm padding)
      const itemWidth = 80.0; // Kích thước cố định cho mỗi item
      const itemSpacing = 16.0; // Khoảng cách giữa các item

      // Tính toán vị trí cần scroll để item được chọn nằm giữa
      final targetOffset = (index * (itemWidth + itemSpacing)) -
          (screenWidth / 2) +
          (itemWidth / 2);

      // Đảm bảo không scroll quá giới hạn
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
          icon: const Icon(Icons.arrow_back, size: 30), // Tăng kích thước icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0), //tăng lên là qua trái
            child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, size: 30),
                //đi vào giỏ hàng khi bấm
                onPressed: () {
                  Navigator.pushNamed(context, '/cart'); // Chuyển đến
                }),
          ),
        ],
        toolbarHeight: 60, // Tăng chiều cao AppBar để cân đối
        leadingWidth: 70, // Đẩy icon leading qua bên trái một chút
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
                  //tên sản phẩm
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
                    child: Container(
                      width: 250,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
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
                  ),
                  const SizedBox(height: 20),

                  //Slider ảnh nhỏ - Layout căn giữa
                  if (currentArtwork!.allImages.length > 1)
                    Center(
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        child: currentArtwork!.allImages.length <= 4
                            ? // Nếu ít hơn hoặc bằng 4 ảnh, hiển thị tất cả căn giữa
                            Row(
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
                            : // Nếu nhiều hơn 4 ảnh, sử dụng ListView có thể scroll
                            ListView.builder(
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
                      'Tác giả: ${currentArtwork!.artist}',
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
                            text: 'Giá: ',
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

                  // Nút thêm vào giỏ hàng
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý thêm vào giỏ hàng
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Added ${currentArtwork!.title} to cart'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
