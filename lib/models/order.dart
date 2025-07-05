class OrderArtworkItem {
  final String id; // Thêm thuộc tính id
  final String title;
  final String artist;
  final String price;
  final String imagePath; //ảnh chính
  final String? material;
  final String? yearcreated; // Năm sáng tác (có thể để null nếu không có)

  OrderArtworkItem({
    required this.id, // Thêm id vào constructor
    required this.title,
    required this.artist,
    required this.price,
    required this.imagePath,
    required this.material,
    required this.yearcreated, // Năm sáng tác
  });
}

final List<OrderArtworkItem> orderArtworkItems = [
  OrderArtworkItem(
    id: '1', // Thêm id cho mỗi item
    title: 'Flower in Oddy',
    artist: 'LT Nghiax',
    price: '11500000',
    material: 'Sơn dầu',
    yearcreated: '2023', // Năm sáng tác
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  OrderArtworkItem(
    id: '2',
    title: 'Think',
    artist: 'Doonstrij2',
    price: '11500000',
    material: 'Sơn dầu',
    yearcreated: '2023',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
];
