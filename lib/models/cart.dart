class CartArtworkItem {
  final String id; // Thêm thuộc tính id
  final String title;
  final String artist;
  final String price;
  final String imagePath; //ảnh chính
  final String? material;
  final String? yearcreated; // Năm sáng tác (có thể để null nếu không có)

  CartArtworkItem({
    required this.id, // Thêm id vào constructor
    required this.title,
    required this.artist,
    required this.price,
    required this.imagePath,
    required this.material,
    required this.yearcreated, // Năm sáng tác
  });
}

final List<CartArtworkItem> cartArtworkItems = [
  CartArtworkItem(
    id: '1', // Thêm id cho mỗi item
    title: 'Flower in Oddy',
    artist: 'LT Nghiax',
    price: '100,000,000',
    material: 'Acrylic',
    yearcreated: '1980', // Năm sáng tác
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  CartArtworkItem(
    id: '2',
    title: 'Think',
    artist: 'Doonstrij2',
    price: '112,500,000',
    material: 'Sơn dầu',
    yearcreated: '2023',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
];
