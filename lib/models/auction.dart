class AuctionItem {
  final String id;
  final String title;
  final String artist;
  final String startingPrice; // Giá khởi điểm
  final String currentPrice; // Giá hiện tại
  final String description;
  final String imagePath;
  final String? material;
  final String? yearcreated;
  final String? genre;
  final List<String> additionalImages;
  final DateTime startTime; // Thời gian bắt đầu đấu giá
  final DateTime endTime; // Thời gian kết thúc đấu giá
  final int totalBids; // Tổng số lượt đấu giá
  final String? highestBidder; // Người đấu giá cao nhất hiện tại
  final bool isActive; // Trạng thái đấu giá (đang diễn ra hay đã kết thúc)
  final String stepPrice; // Bước giá tối thiểu

  AuctionItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.startingPrice,
    required this.currentPrice,
    required this.description,
    required this.imagePath,
    required this.startTime,
    required this.endTime,
    required this.stepPrice,
    this.material,
    this.genre,
    this.yearcreated,
    this.additionalImages = const [],
    this.totalBids = 0,
    this.highestBidder,
    this.isActive = true,
  });

  // Getter để lấy tất cả ảnh
  List<String> get allImages => [imagePath, ...additionalImages];

  // Getter để kiểm tra thời gian còn lại
  Duration get timeRemaining {
    if (!isActive || DateTime.now().isAfter(endTime)) {
      return Duration.zero;
    }
    return endTime.difference(DateTime.now());
  }

  // Getter để kiểm tra đấu giá đã kết thúc chưa
  bool get isExpired => DateTime.now().isAfter(endTime);

  // Getter để kiểm tra đấu giá chưa bắt đầu
  bool get notStarted => DateTime.now().isBefore(startTime);
}

// Dữ liệu mẫu cho các tác phẩm đấu giá
final List<AuctionItem> auctionArtworks = [
  AuctionItem(
    id: 'auction_1',
    title: 'Vạm Thiên',
    artist: 'NghiaLT',
    startingPrice: '100,000,000',
    currentPrice: '129,000,000',
    stepPrice: '5,000,000',
    description:
        'Tác phẩm nghệ thuật đương đại thể hiện vẻ đẹp hùng vĩ của thiên nhiên qua góc nhìn độc đáo của họa sĩ.',
    imagePath: 'assets/images/vam_thien.png',
    material: 'Sơn dầu trên canvas',
    genre: 'Phong cảnh',
    yearcreated: '2004',
    startTime: DateTime.now().subtract(Duration(hours: 2)),
    endTime: DateTime.now().add(Duration(days: 3, hours: 5)),
    totalBids: 15,
    highestBidder: 'NguyenVanA',
    isActive: true,
    additionalImages: [
      'assets/images/vam_thien_detail1.jpg',
      'assets/images/vam_thien_detail2.jpg',
    ],
  ),
  AuctionItem(
    id: 'auction_2',
    title: 'Hoàng Hôn Mê Hoặc',
    artist: 'TranABC',
    startingPrice: '70,000,000',
    currentPrice: '85,000,000',
    stepPrice: '3,000,000',
    description:
        'Bức tranh phong cảnh tuyệt đẹp mô tả khoảnh khắc hoàng hôn buông xuống với những sắc màu rực rỡ.',
    imagePath: 'assets/images/hh.jpg',
    material: 'Acrylic trên canvas',
    genre: 'Phong cảnh',
    yearcreated: '2010',
    startTime: DateTime.now().subtract(Duration(days: 1)),
    endTime: DateTime.now().add(Duration(days: 2, hours: 10)),
    totalBids: 8,
    highestBidder: 'LeThiB',
    isActive: true,
  ),
  AuctionItem(
    id: 'auction_3',
    title: 'Đóa Sen Tịnh Tâm',
    artist: 'PhamMinh',
    startingPrice: '50,000,000',
    currentPrice: '67,500,000',
    stepPrice: '2,500,000',
    description:
        'Tác phẩm thể hiện vẻ đẹp thanh khiết của hoa sen, biểu tượng của sự tinh khiết và giác ngộ.',
    imagePath: 'assets/images/doasen.png',
    material: 'Màu nước trên giấy',
    genre: 'Hoa',
    yearcreated: '2018',
    startTime: DateTime.now().subtract(Duration(hours: 5)),
    endTime: DateTime.now().add(Duration(days: 1, hours: 15)),
    totalBids: 12,
    highestBidder: 'VoVanC',
    isActive: true,
    additionalImages: [
      'assets/images/hoa_sen_detail1.jpg',
    ],
  ),
  AuctionItem(
    id: 'auction_4',
    title: 'Thành Phố Về Đêm',
    artist: 'NgoDuc',
    startingPrice: '120,000,000',
    currentPrice: '145,000,000',
    stepPrice: '8,000,000',
    description:
        'Bức tranh hiện đại mô tả vẻ đẹp lung linh của thành phố trong đêm với những ánh đèn rực rỡ.',
    imagePath: 'assets/images/tpd.jpg',
    material: 'Sơn dầu và acrylic',
    genre: 'Hiện đại',
    yearcreated: '2022',
    startTime: DateTime.now().add(Duration(hours: 2)),
    endTime: DateTime.now().add(Duration(days: 5)),
    totalBids: 0,
    isActive: false, // Chưa bắt đầu
  ),
  AuctionItem(
    id: 'auction_5',
    title: 'Chân Dung Người Phụ Nữ',
    artist: 'HoangLan',
    startingPrice: '90,000,000',
    currentPrice: '115,000,000',
    stepPrice: '5,000,000',
    description:
        'Chân dung tinh tế thể hiện vẻ đẹp và sự mạnh mẽ của người phụ nữ hiện đại.',
    imagePath: 'assets/images/chandung.jpg',
    material: 'Sơn dầu trên canvas',
    genre: 'Chân dung',
    yearcreated: '2020',
    startTime: DateTime.now().subtract(Duration(days: 2)),
    endTime: DateTime.now().add(Duration(hours: 8)),
    totalBids: 22,
    highestBidder: 'TranThiD',
    isActive: true,
  ),
];

// Dữ liệu mẫu cho các cuộc đấu giá đã kết thúc
final List<AuctionItem> completedAuctions = [
  AuctionItem(
    id: 'completed_1',
    title: 'Biển Cả Sóng Gió',
    artist: 'DinhHai',
    startingPrice: '80,000,000',
    currentPrice: '125,000,000',
    stepPrice: '5,000,000',
    description:
        'Tác phẩm mô tả sức mạnh và vẻ đẹp hùng vĩ của biển cả trong cơn bão.',
    imagePath: 'assets/images/sea1.jpg',
    material: 'Sơn dầu',
    genre: 'Phong cảnh',
    yearcreated: '2017',
    startTime: DateTime.now().subtract(Duration(days: 10)),
    endTime: DateTime.now().subtract(Duration(days: 3)),
    totalBids: 18,
    highestBidder: 'VuVanF',
    isActive: false,
  ),
];

// Enum cho trạng thái đấu giá
enum AuctionStatus {
  upcoming, // Sắp diễn ra
  active, // Đang diễn ra
  completed // Đã kết thúc
}

// Hàm helper để lấy trạng thái đấu giá
AuctionStatus getAuctionStatus(AuctionItem item) {
  final now = DateTime.now();
  if (now.isBefore(item.startTime)) {
    return AuctionStatus.upcoming;
  } else if (now.isAfter(item.endTime)) {
    return AuctionStatus.completed;
  } else {
    return AuctionStatus.active;
  }
}
