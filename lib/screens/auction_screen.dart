import 'package:app_ban_tranh/models/auction.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({Key? key}) : super(key: key);

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Timer? _timer;
  String selectedFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Cập nhật thời gian mỗi giây
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Đấu Giá Tác Phẩm',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue[600],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue[600],
          tabs: const [
            Tab(text: 'Đang Diễn Ra'),
            Tab(text: 'Sắp Diễn Ra'),
            Tab(text: 'Đã Kết Thúc'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveAuctions(),
          _buildUpcomingAuctions(),
          _buildCompletedAuctions(),
        ],
      ),
    );
  }

  // Tab đấu giá đang diễn ra
  Widget _buildActiveAuctions() {
    final activeAuctions = auctionArtworks
        .where((auction) => getAuctionStatus(auction) == AuctionStatus.active)
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activeAuctions.length,
        itemBuilder: (context, index) {
          final auction = activeAuctions[index];
          return _buildAuctionCard(auction, isActive: true);
        },
      ),
    );
  }

  // Tab đấu giá sắp diễn ra
  Widget _buildUpcomingAuctions() {
    final upcomingAuctions = auctionArtworks
        .where((auction) => getAuctionStatus(auction) == AuctionStatus.upcoming)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingAuctions.length,
      itemBuilder: (context, index) {
        final auction = upcomingAuctions[index];
        return _buildAuctionCard(auction, isUpcoming: true);
      },
    );
  }

  // Tab đấu giá đã kết thúc
  Widget _buildCompletedAuctions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedAuctions.length,
      itemBuilder: (context, index) {
        final auction = completedAuctions[index];
        return _buildAuctionCard(auction, isCompleted: true);
      },
    );
  }

  // Card tác phẩm đấu giá
  Widget _buildAuctionCard(AuctionItem auction,
      {bool isActive = false,
      bool isUpcoming = false,
      bool isCompleted = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hình ảnh tác phẩm
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(auction.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Badge trạng thái
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(isActive, isUpcoming, isCompleted),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(isActive, isUpcoming, isCompleted),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Nút yêu thích
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.red[400],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            // Thông tin tác phẩm
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề và tác giả
                  Text(
                    auction.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tác giả: ${auction.artist}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Thông tin giá
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Giá hiện tại',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${auction.currentPrice} VNĐ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isActive) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.people,
                                  size: 16, color: Colors.orange[700]),
                              const SizedBox(width: 4),
                              Text(
                                '${auction.totalBids} lượt',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Thời gian và nút hành động
                  if (isActive) ...[
                    _buildCountdownTimer(auction),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showBidDialog(context, auction),
                            icon: const Icon(Icons.gavel, size: 18),
                            label: const Text('Đặt Giá'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () =>
                              _showAuctionDetails(context, auction),
                          child: const Text('Chi tiết'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (isUpcoming) ...[
                    _buildUpcomingTimer(auction),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _setReminder(context, auction),
                        icon: const Icon(Icons.notifications, size: 18),
                        label: const Text('Đặt Nhắc Nhở'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ] else if (isCompleted) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_events,
                              color: Colors.green[600], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Người thắng: ${auction.highestBidder ?? "N/A"}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[700],
                                  ),
                                ),
                                Text(
                                  'Giá cuối: ${auction.currentPrice} VNĐ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Đếm ngược thời gian cho đấu giá đang diễn ra
  Widget _buildCountdownTimer(AuctionItem auction) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.red[600], size: 20),
          const SizedBox(width: 8),
          Text(
            'Còn lại: ${_formatTimeRemaining(auction)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  // Thời gian bắt đầu cho đấu giá sắp tới
  Widget _buildUpcomingTimer(AuctionItem auction) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Text(
            'Bắt đầu: ${_formatStartTime(auction)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog đặt giá
  void _showBidDialog(BuildContext context, AuctionItem auction) {
    final TextEditingController bidController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt giá cho "${auction.title}"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Giá hiện tại: ${auction.currentPrice} VNĐ'),
            Text('Bước giá tối thiểu: ${auction.stepPrice} VNĐ'),
            const SizedBox(height: 16),
            TextField(
              controller: bidController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá đặt của bạn',
                hintText: 'Nhập số tiền',
                border: OutlineInputBorder(),
                suffixText: 'VNĐ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              // Xử lý đặt giá
              Navigator.pop(context);
              _showBidSuccess(context);
            },
            child: const Text('Đặt Giá'),
          ),
        ],
      ),
    );
  }

  // Dialog tìm kiếm
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tìm kiếm tác phẩm'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Nhập tên tác phẩm hoặc tác giả...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tìm kiếm'),
          ),
        ],
      ),
    );
  }

  // Dialog lọc
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lọc tác phẩm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Tất cả'),
            _buildFilterOption('Phong cảnh'),
            _buildFilterOption('Chân dung'),
            _buildFilterOption('Hoa'),
            _buildFilterOption('Hiện đại'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    return RadioListTile<String>(
      title: Text(filter),
      value: filter,
      groupValue: selectedFilter,
      onChanged: (value) {
        setState(() {
          selectedFilter = value!;
        });
        Navigator.pop(context);
      },
    );
  }

  // Các hàm helper
  Color _getStatusColor(bool isActive, bool isUpcoming, bool isCompleted) {
    if (isActive) return Colors.green;
    if (isUpcoming) return Colors.blue;
    return Colors.grey;
  }

  String _getStatusText(bool isActive, bool isUpcoming, bool isCompleted) {
    if (isActive) return 'ĐANG DIỄN RA';
    if (isUpcoming) return 'SẮP DIỄN RA';
    return 'ĐÃ KẾT THÚC';
  }

  void _showBidSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đặt giá thành công!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _setReminder(BuildContext context, AuctionItem auction) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đặt nhắc nhở thành công!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showAuctionDetails(BuildContext context, AuctionItem auction) {
    // Navigate to detail screen
  }

  String _formatTimeRemaining(AuctionItem auction) {
    final remaining = auction.timeRemaining;
    if (remaining == Duration.zero) return 'Đã kết thúc';

    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;

    if (days > 0) {
      return '$days ngày $hours giờ $minutes phút';
    } else if (hours > 0) {
      return '$hours giờ $minutes phút';
    } else {
      return '$minutes phút';
    }
  }

  String _formatStartTime(AuctionItem auction) {
    final startTime = auction.startTime;
    return '${startTime.day.toString().padLeft(2, '0')}/${startTime.month.toString().padLeft(2, '0')}/${startTime.year} - ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }
}
