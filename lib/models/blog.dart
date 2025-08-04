class Blog {
  final String idblog;
  final String nameblog;
  final String description;
  final String content;
  final String timeupload;
  final String imagePath;
  final List<String>? additionalImages;
  final List<String>? imageDescriptions;

  Blog({
    required this.idblog,
    required this.nameblog,
    required this.content,
    required this.description,
    required this.timeupload,
    required this.imagePath,
    this.additionalImages,
    this.imageDescriptions,
  });
}

final List<Blog> homeblog = [
  Blog(
    idblog: '1',
    nameblog: 'Vincent van Gogh',
    timeupload: '2025-5-01',
    imagePath: 'assets/images/blog5.jpg',
    description: 'Kẻ mộng du trong thế giới sắc màu',
    content:
        'Sinh năm 1853 tại Hà Lan, cuộc đời Van Gogh là hành trình đầy đau thương, cô độc và những cuộc khủng hoảng nội tâm sâu sắc. Nhưng chính từ những đổ vỡ ấy, ông lại thăng hoa trong nghệ thuật. Van Gogh bắt đầu vẽ muộn – gần 30 tuổi – và sáng tác khoảng 2.100 tác phẩm chỉ trong hơn 10 năm. Điều đặc biệt là trong suốt cuộc đời, ông chỉ bán được duy nhất một bức tranh. Với Van Gogh, hội họa không chỉ là nghề mà là cách ông sống – và tồn tại.',
    additionalImages: [
      'assets/images/blog2.jpg',
      'assets/images/blog3.jpg',
      'assets/images/blog4.jpg',
    ],
    imageDescriptions: [
      '"Starry Night" (Đêm đầy sao)\n\nĐó là ánh nhìn duy nhất của Van Gogh khi đang điều trị trong bệnh viện tâm thần.',
      '"Sunflowers" (Những bông hoa hướng dương)\n\nVan Gogh từng xem hoa hướng dương như biểu tượng của tình bạn và lòng biết ơn.',
      '"The Bedroom" (Phòng ngủ ở Arles)\n\nNơi trú ẩn đầm ấm hiếm hoi và mang nhiều kỷ niệm trong cuộc đời bình yên của Van Gogh.',
    ],
  ),
  Blog(
    idblog: '2',
    nameblog: 'Lê Thị Lựu',
    timeupload: '2025-5-15',
    imagePath:
        'https://lh4.googleusercontent.com/proxy/OBpvkmgIqLOnNiVblLF8u-cYNhNMTZHh6kfyhUuFo4J4FJiklR790CJqZppdn5T5YVf-DnWLRY33kp7XJETANTzi98ev07psm-0g2kyGMKeHxWw',
    description: 'Người phụ nữ dịu dàng vẽ nên vẻ đẹp Việt',
    content:
        'Lê Thị Lựu (1911–1988) là nữ họa sĩ đầu tiên tốt nghiệp Trường Mỹ thuật Đông Dương – một biểu tượng tiên phong trong mỹ thuật hiện đại Việt Nam. Bà nổi bật với những tác phẩm mang vẻ đẹp dịu dàng, sâu lắng của người phụ nữ và cuộc sống nông thôn Việt Nam. Tranh của bà thường sử dụng màu sắc nhẹ nhàng, đằm thắm, với kỹ thuật lụa tinh tế. Không chỉ là một nghệ sĩ tài năng, bà còn là hình mẫu cho nghị lực và sự bền bỉ trong sáng tạo nghệ thuật giữa bối cảnh xã hội nhiều thay đổi.',
    additionalImages: [
      'https://i.pinimg.com/736x/b6/fe/49/b6fe49a3adc5ac58a7e703d4fb03126e.jpg',
      'https://nld.mediacdn.vn/291774122806476800/2022/4/25/8-tranh-le-thi-luu-16508917797061823084814.jpg',
      'https://tapchimythuat.vn/wp-content/uploads/2019/04/t4.19.viet-1.jpg',
    ],
    imageDescriptions: [
      '"Thiếu nữ bên hoa huệ"\n\nMột tác phẩm đặc trưng với đường nét mềm mại và sắc trắng tinh khiết biểu trưng cho vẻ đẹp thuần khiết của người con gái Việt.',
      '"Mẹ và con"\n\nKhắc họa tình mẫu tử thiêng liêng – chủ đề bà đặc biệt yêu thích.',
      '"Sơn nữ"\n\nMột thiếu nữ vùng cao với nét đẹp mạnh mẽ nhưng dịu dàng, phản ánh sự giao hòa giữa con người và thiên nhiên.',
    ],
  ),
];
final List<Blog> detailblog = [];
