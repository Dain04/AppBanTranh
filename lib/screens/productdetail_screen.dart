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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back to Product List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  // Hình ảnh sản phẩm
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(currentArtwork!.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Thông tin sản phẩm
                  Text(
                    currentArtwork!.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Artist: ${currentArtwork!.artist}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Price: ${currentArtwork!.price}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Product ID: ${currentArtwork!.id}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
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
