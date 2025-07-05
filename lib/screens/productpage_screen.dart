import 'package:app_ban_tranh/screens/productdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh/models/prodcut.dart';

class ProductPageScreen extends StatelessWidget {
  const ProductPageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Trở lại trang chủ',
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
      body: SingleChildScrollView(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text(
                      'Artwork in type',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryItem(
                              'Flower', 'assets/images/flowerstyle.jpg'),
                          _buildCategoryItem(
                              'Classic', 'assets/images/classisctyle.jpg'),
                          _buildCategoryItem(
                              'Modern', 'assets/images/modernstyle.jpg'),
                          _buildCategoryItem(
                              'Scene', 'assets/images/scene.jpg'),
                          _buildCategoryItem(
                              'Portrait', 'assets/images/portrait.jpg'),
                          _buildCategoryItem(
                              'Cultural', 'assets/images/Cultural.jpg')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              //___________________________________new artwork section_________________________
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    'New Artwork',
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

                /// Danh sách các tác phẩm nghệ thuật mới
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: newArtworks.length,
                  itemBuilder: (context, index) {
                    return _buildArtworkCard(context, newArtworks[index]);
                  },
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
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
                    Text(
                      'Price: ${artwork.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                //Nút xem chi tiết và nút thêm vào giỏ hàng
                Row(
                  children: [
                    SizedBox(
                      width: 100, // Đặt chiều rộng cố định cho nút
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () {
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
                              'Xem chi tiết',
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
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        onPressed: () {
                          print('Add to cart: ${artwork.title}');
                          // Có thể thêm logic thêm vào giỏ hàng ở đây
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 14,
                        ),
                        padding: EdgeInsets.zero,
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
  );
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
