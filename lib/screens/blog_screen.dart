import 'package:app_ban_tranh/models/blog.dart';
import 'package:flutter/material.dart';

class BlogScreen extends StatelessWidget {
  final String blogId;

  const BlogScreen({
    Key? key,
    required this.blogId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tìm blog theo ID
    final blog = homeblog.firstWhere(
      (blog) => blog.idblog == blogId,
      orElse: () => homeblog[0],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF1A1A1A),
            elevation: 0,
            pinned: true,
            expandedHeight: 100,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                ' Chi tiết bài viết',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header với avatar và title
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildImage(blog.imagePath),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog.nameblog,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              blog.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Content text
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      blog.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Artwork Section
                  if (blog.additionalImages != null &&
                      blog.additionalImages!.isNotEmpty) ...[
                    const Text(
                      'Những Tác Phẩm Nổi Tiếng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Artwork cards
                    ...List.generate(
                      blog.additionalImages!.length,
                      (index) => _buildArtworkCard(
                        blog.additionalImages![index],
                        blog.imageDescriptions![index],
                        index,
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method để xử lý việc tải ảnh
  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // Nếu là URL thì dùng Image.network
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: const Color(0xFF3A3A3A),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.white,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF3A3A3A),
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 50,
              ),
            ),
          );
        },
      );
    } else {
      // Nếu là local asset thì dùng Image.asset
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF3A3A3A),
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 50,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildArtworkCard(String imagePath, String description, int index) {
    // Tách title và description
    final lines = description.split('\n\n');
    final title = lines[0].replaceAll('"', '').replaceAll('"', '');
    final desc = lines.length > 1 ? lines[1] : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildImage(imagePath), // Sử dụng helper method
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Description
          if (desc.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                desc,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

extension BlogNavigation on BuildContext {
  void navigateToBlogDetail(String blogId) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => BlogScreen(blogId: blogId),
      ),
    );
  }
}
