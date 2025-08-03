import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipping,
  delivered,
  cancelled,
  returned,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.preparing:
        return 'Đang chuẩn bị';
      case OrderStatus.shipping:
        return 'Đang giao hàng';
      case OrderStatus.delivered:
        return 'Đã giao hàng';
      case OrderStatus.cancelled:
        return 'Đã hủy';
      case OrderStatus.returned:
        return 'Đã trả lại';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.indigo;
      case OrderStatus.shipping:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.grey;
    }
  }
}

class OrderItem {
  final String id;
  final String paintingId; // ID của bức tranh từ OrderArtworkItem
  final String paintingName;
  final String artist; // Tên nghệ sĩ
  final String imagePath; // Ảnh chính của tranh
  final String? material; // Chất liệu (sơn dầu, acrylic...)
  final String? yearCreated; // Năm sáng tác
  final String size; // Kích thước tranh
  final String frame; // Loại khung
  final int quantity;
  final double price;
  final double originalPrice; // Giá gốc (trước khi giảm giá nếu có)
  final double? discountPercent; // Phần trăm giảm giá
  final String? customNote; // Ghi chú đặc biệt cho sản phẩm này

  OrderItem({
    required this.id,
    required this.paintingId,
    required this.paintingName,
    required this.artist,
    required this.imagePath,
    this.material,
    this.yearCreated,
    required this.size,
    required this.frame,
    required this.quantity,
    required this.price,
    required this.originalPrice,
    this.discountPercent,
    this.customNote,
  });

  // Tính tổng giá trị của item này
  double get totalPrice => price * quantity;

  // Kiểm tra có giảm giá không
  bool get hasDiscount => discountPercent != null && discountPercent! > 0;

  // Tính số tiền tiết kiệm được
  double get savedAmount =>
      hasDiscount ? (originalPrice - price) * quantity : 0;
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final DateTime orderDate;
  final OrderStatus status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String? customerEmail; // Email khách hàng
  final String paymentMethod;
  final bool isPaid;
  final DateTime? deliveryDate;
  final DateTime? expectedDeliveryDate; // Ngày giao hàng dự kiến
  final String? notes;
  final String? cancelReason; // Lý do hủy đơn (nếu có)
  final DateTime? cancelDate; // Ngày hủy đơn

  // Thông tin vận chuyển
  final double shippingFee; // Phí vận chuyển
  final String? shippingMethod; // Phương thức vận chuyển
  final String? trackingNumber; // Mã theo dõi đơn hàng

  // Thông tin thanh toán
  final double subtotal; // Tổng tiền hàng (chưa bao gồm phí vận chuyển)
  final double? discountAmount; // Số tiền giảm giá
  final String? couponCode; // Mã giảm giá được sử dụng
  final double totalAmount; // Tổng cộng (bao gồm tất cả)

  // Thông tin đánh giá
  final int? rating; // Đánh giá từ 1-5 sao
  final String? reviewComment; // Bình luận đánh giá
  final DateTime? reviewDate; // Ngày đánh giá
  final List<String>? reviewImages; // Ảnh đánh giá từ khách hàng

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.orderDate,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    this.customerEmail,
    required this.paymentMethod,
    required this.isPaid,
    this.deliveryDate,
    this.expectedDeliveryDate,
    this.notes,
    this.cancelReason,
    this.cancelDate,
    this.shippingFee = 0,
    this.shippingMethod,
    this.trackingNumber,
    required this.subtotal,
    this.discountAmount,
    this.couponCode,
    required this.totalAmount,
    this.rating,
    this.reviewComment,
    this.reviewDate,
    this.reviewImages,
  });

  // Các getter hữu ích
  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;
  bool get canReview => status == OrderStatus.delivered && rating == null;
  bool get isCompleted => status == OrderStatus.delivered;
  bool get isCancelled =>
      status == OrderStatus.cancelled || status == OrderStatus.returned;

  // Tính tổng số lượng sản phẩm
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  // Tính tổng số tiền tiết kiệm được
  double get totalSavedAmount =>
      items.fold(0, (sum, item) => sum + item.savedAmount);
}

// Sample data class
class OrderData {
  static List<Order> sampleOrders = [
    Order(
      id: 'ORD001',
      userId: 'user123',
      orderDate: DateTime.now().subtract(Duration(days: 2)),
      status: OrderStatus.delivered,
      customerName: 'Nguyen Van An',
      customerPhone: '0123456789',
      customerAddress: '123/ABC, TPHCM',
      customerEmail: 'nguyenvanan@email.com',
      paymentMethod: 'Thẻ tín dụng',
      isPaid: true,
      deliveryDate: DateTime.now().subtract(Duration(days: 2)),
      expectedDeliveryDate: DateTime.now().subtract(Duration(days: 2)),
      shippingFee: 50000,
      shippingMethod: 'Giao hàng nhanh',
      trackingNumber: 'TN123456789',
      subtotal: 100000000,
      totalAmount: 100050000,
      rating: 5,
      reviewComment: 'Tranh rất đẹp, đóng gói cẩn thận!',
      reviewDate: DateTime.now().subtract(Duration(hours: 12)),
      items: [
        OrderItem(
          id: 'item1',
          paintingId: '1',
          paintingName: 'Flower in Oddy',
          artist: 'LT Nghiax',
          imagePath: 'assets/images/flowerstyle.jpg',
          material: 'Acrylic',
          yearCreated: '1980',
          size: '50x70cm',
          frame: 'Khung gỗ cao cấp',
          quantity: 1,
          price: 100000000,
          originalPrice: 100000000,
        ),
      ],
    ),
    Order(
      id: 'ORD002',
      userId: 'user123',
      orderDate: DateTime.now().subtract(Duration(days: 5)),
      status: OrderStatus.shipping,
      customerName: 'Nguyễn Văn An',
      customerPhone: '0123456789',
      customerAddress: '123 Đường ABC, Quận 1, TP.HCM',
      customerEmail: 'nguyenvanan@email.com',
      paymentMethod: 'COD',
      isPaid: false,
      expectedDeliveryDate: DateTime.now().add(Duration(days: 1)),
      shippingFee: 30000,
      shippingMethod: 'Giao hàng tiêu chuẩn',
      trackingNumber: 'TN987654321',
      subtotal: 23000000,
      discountAmount: 500000,
      couponCode: 'NEWCUSTOMER10',
      totalAmount: 22530000,
      items: [
        OrderItem(
          id: 'item2',
          paintingId: '2',
          paintingName: 'Think',
          artist: 'Doonstrij2',
          imagePath: 'assets/images/flowerstyle.jpg',
          material: 'Sơn dầu',
          yearCreated: '2023',
          size: '60x80cm',
          frame: 'Khung nhôm hiện đại',
          quantity: 2,
          price: 11000000,
          originalPrice: 11500000,
          discountPercent: 4.3,
        ),
      ],
    ),
  ];
}
