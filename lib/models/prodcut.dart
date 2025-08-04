class ArtworkItem {
  final String id; // Thêm thuộc tính id
  final String title;
  final String artist;
  final String price;
  final String description; // Mô tả
  final String imagePath; //ảnh chính
  final String? material;
  final String? yearcreated; // Năm sáng tác (có thể để null nếu không có)
  final String? genre;
  final List<String> additionalImages; //danh sách ảnh phụ

  ArtworkItem({
    required this.id, // Thêm id vào constructor
    required this.title,
    required this.artist,
    required this.price,
    required this.description, // Mô tả
    required this.imagePath,
    required this.material,
    required this.genre,
    required this.yearcreated, // Năm sáng tác

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
    price: '100,000,000',
    material: '',
    yearcreated: '2023', // Năm sáng tác
    genre: 'Cổ điển',
    imagePath: 'assets/images/flowerstyle.jpg',
    description: '', // Mô tả mặc định là rỗng
  ),
  ArtworkItem(
    id: '2',
    title: 'Think',
    artist: 'Doonstrij2',
    price: '140,000,000',
    material: '',
    yearcreated: '2023',
    genre: 'Hoa',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '3',
    title: 'Old War',
    artist: 'Rune Quizzter',
    price: '170,670,000',
    material: '',
    yearcreated: '2023',
    genre: 'Hiện đại',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
  ArtworkItem(
    id: '4',
    title: 'Blood Falls',
    artist: 'Doonstrij2',
    price: '10,000,000',
    material: '',
    yearcreated: '2023',
    genre: 'Hoa',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
  ),
    ArtworkItem(
    id: '5',
    title: 'Hoa Rừng',
    artist: 'Dain',
    yearcreated: '2020',
    genre: 'Hoa',
    price: '123,078,000',
    description: 'Vẻ đẹp thời đại của khoản khắt.',
    imagePath: 'assets/images/bh2.jpg',
    material: '',
  ),
];

// Dữ liệu mẫu cho các tác phẩm nghệ thuật
final List<ArtworkItem> newArtworks = [
  ArtworkItem(
      id: '6',
      title: 'Flower in Oddy',
      artist: 'LT Nghiax',
      price: '100,000,000',
      description:
          'Từ sâu thẳm khu rừng, một bản giao hưởng sắc màu hiện lên, là khúc ca rực rỡ của những loài hoa dại được vẽ nên bằng nét chạm tinh tế. Mỗi đóa hoa như một kiệt tác thu nhỏ, bừng nở sức sống, cánh hoa nhẹ nhàng bung nở tựa đôi cánh lụa mỏng.',
      imagePath: 'assets/images/flowerstyle.jpg',
      genre: 'Hoa',
      material: 'Acrylic',
      yearcreated: '1980',
      additionalImages: [
        'assets/images/bh1.jpg',
        'assets/images/bh2.jpg',
      ]),
  ArtworkItem(
    id: '7',
    title: 'Think',
    artist: 'Doonstrij2',
    price: '140,000,000',
    genre: 'Hoa',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
    yearcreated: '2023',
    material: '',
  ),
  ArtworkItem(
    id: '8',
    title: 'Old War',
    artist: 'Rune Quizzter',
    price: '170,670,000',
    genre: 'Văn hoá',
    yearcreated: '2023',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
    material: '',
  ),
  ArtworkItem(
    id: '9',
    title: 'Blood Falls',
    artist: 'Doonstrij2',
    yearcreated: '2023',
    genre: 'Chân dung',
    price: '10,000,000',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
    material: '',
  ),
  ArtworkItem(
    id: '10',
    title: 'Hoa Rừng',
    artist: 'Dain',
    yearcreated: '2020',
    genre: 'Hoa',
    price: '123,078,000',
    description: 'Vẻ đẹp thời đại của khoản khắt.',
    imagePath: 'assets/images/bh2.jpg',
    material: '',
  ),
];
//dữ liệu tác phẩm đấu giá
final List<ArtworkItem> DauGiaTP = [
  ArtworkItem(
      id: '1',
      title: 'Vạm Thiên',
      artist: 'NghiaLT',
      price: '129,000,000',
      description: 'Tác phẩm nghệ thuật đương đại',
      imagePath: 'assets/images/vam_thien.png',
      material: 'Sơn dầu trên canvas',
      genre: 'Phong cảnh',
      yearcreated: '2004'),
  ArtworkItem(
      id: '2',
      title: 'Hoàng Hôn',
      artist: 'TranABC',
      price: '85,000,000',
      description: 'Bức tranh phong cảnh tuyệt đẹp',
      imagePath: 'assets/images/vam_thien.png',
      material: 'Acrylic',
      genre: 'Phong cảnh',
      yearcreated: '2010'),
];
