class Galleries {
  final String idgallery;
  final String namegallery;
  final String location;
  final String date_start;
  final String date_end;
  final String imagePath;
  final String description;

  Galleries({
    required this.idgallery,
    required this.namegallery,
    required this.location,
    required this.date_start,
    required this.date_end,
    required this.imagePath,
    required this.description,
  });
}

final List<Galleries> homegalleries = [
  Galleries(
    idgallery: '1',
    namegallery: 'Triển lãm Nghệ thuật Đương đại',
    location: 'Hà Nội, Việt Nam',
    date_start: '2025-09-01',
    date_end: '2025-09-30',
    imagePath: 'assets/images/hanoi.jpg',
    description:
        'Triển lãm giới thiệu các tác phẩm nghệ thuật đương đại của những hoạ sĩ trẻ tài năng đến từ miền Bắc Việt Nam.',
  ),
  Galleries(
    idgallery: '2',
    namegallery: 'Không gian Nghệ thuật Sài Gòn',
    location: 'TP. Hồ Chí Minh, Việt Nam',
    date_start: '2025-10-05',
    date_end: '2025-11-05',
    imagePath: 'assets/images/miennam.jpg',
    description:
        'Trưng bày những tác phẩm nghệ thuật hiện đại kết hợp giữa truyền thống và công nghệ, phản ánh cuộc sống đô thị.',
  ),
  Galleries(
    idgallery: '3',
    namegallery: 'Góc Nhìn Miền Trung',
    location: 'Đà Nẵng, Việt Nam',
    date_start: '2025-08-15',
    date_end: '2025-09-15',
    imagePath: 'assets/images/danang.jpg',
    description:
        'Triển lãm quy tụ các tác phẩm hội hoạ và điêu khắc mang hơi thở của biển, núi và văn hóa miền Trung.',
  ),
];
