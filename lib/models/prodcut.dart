class ArtworkItem {
  final String id; // Thêm thuộc tính id
  final String title;
  final String artist;
  final String price;
  final String imagePath;

  ArtworkItem({
    required this.id, // Thêm id vào constructor
    required this.title,
    required this.artist,
    required this.price,
    required this.imagePath,
  });
}

// Dữ liệu mẫu cho các tác phẩm nghệ thuật ở trang chủ
final List<ArtworkItem> homenewArtworks = [
  ArtworkItem(
    id: '1', // Thêm id cho mỗi item
    title: 'Flower in Oddy',
    artist: 'LT Nghiax',
    price: 'Price on request',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '2',
    title: 'Think',
    artist: 'Doonstrij2',
    price: 'Price on request',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '3',
    title: 'Old War',
    artist: 'Rune Quizzter',
    price: 'Price on request',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '4',
    title: 'Blood Falls',
    artist: 'Doonstrij2',
    price: 'Price on request',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
];

// Dữ liệu mẫu cho các tác phẩm nghệ thuật
final List<ArtworkItem> newArtworks = [
  ArtworkItem(
    id: '5',
    title: 'Flower in Oddy',
    artist: 'LT Nghiax',
    price: '\$1,500',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '6',
    title: 'Think',
    artist: 'Doonstrij2',
    price: '\$1,300',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '7',
    title: 'Old War',
    artist: 'Rune Quizzter',
    price: '\$1,800',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '8',
    title: 'Blood Falls',
    artist: 'Doonstrij2',
    price: '\$1,300',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
];
