class ArtworkItem {
  final String id; // Thêm thuộc tính id
  final String title;
  final String artist;
  final String price;
  final String description; // Mô tả
  final String imagePath; //ảnh chính
  final List<String> additionalImages; //danh sách ảnh phụ

  ArtworkItem({
    required this.id, // Thêm id vào constructor
    required this.title,
    required this.artist,
    required this.price,
    required this.description, // Mô tả
    required this.imagePath,
    this.additionalImages = const [],
  });
  //getter lấy tất cả ảnh chính và phụ
  List<String> get allImages => [imagePath, ...additionalImages];
}

// Dữ liệu mẫu cho các tác phẩm nghệ thuật ở trang chủ
final List<ArtworkItem> homenewArtworks = [
  ArtworkItem(
    id: '1', // Thêm id cho mỗi item
    title: 'Flower in Oddy',
    artist: 'LT Nghiax',
    price: 'Price on request',
    imagePath: 'assets/images/flowerstyle.jpg',
    description: '', // Mô tả mặc định là rỗng
  ),
  ArtworkItem(
    id: '2',
    title: 'Think',
    artist: 'Doonstrij2',
    price: 'Price on request',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '3',
    title: 'Old War',
    artist: 'Rune Quizzter',
    price: 'Price on request',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '4',
    title: 'Blood Falls',
    artist: 'Doonstrij2',
    price: 'Price on request',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
];

// Dữ liệu mẫu cho các tác phẩm nghệ thuật
final List<ArtworkItem> newArtworks = [
  ArtworkItem(
      id: '5',
      title: 'Flower in Oddy',
      artist: 'LT Nghiax',
      price: '\$100.000.000 VNĐ',
      description: 'A powerful piece depicting the struggles of war.',
      imagePath: 'assets/images/flowerstyle.jpg',
      additionalImages: [
        'assets/images/bh1.jpg',
        'assets/images/bh2.jpg',
      ]),
  ArtworkItem(
    id: '6',
    title: 'Think',
    artist: 'Doonstrij2',
    price: '\$1,300',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '7',
    title: 'Old War',
    artist: 'Rune Quizzter',
    price: '\$1,800',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '8',
    title: 'Blood Falls',
    artist: 'Doonstrij2',
    price: '\$1,300',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
];
