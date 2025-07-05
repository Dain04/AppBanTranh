import 'package:flutter/material.dart';

class PaymentProgressCurve extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String leftLabel;
  final String rightLabel;

  const PaymentProgressCurve({
    Key? key,
    this.progress = 0.5,
    this.leftLabel = "Thông tin giao hàng",
    this.rightLabel = "Phương thức thanh toán",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                rightLabel,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Curved progress line
          CustomPaint(
            size: const Size(double.infinity, 60),
            painter: CurvedProgressPainter(progress: progress),
          ),
        ],
      ),
    );
  }
}

class CurvedProgressPainter extends CustomPainter {
  final double progress;

  CurvedProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Tạo đường cong bằng Quadratic Bezier
    final path = Path();
    final startPoint = Offset(0, size.height * 0.3);
    final endPoint = Offset(size.width, size.height * 0.3);
    final controlPoint = Offset(size.width / 2, size.height * 1.1);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    // Vẽ đường nền (màu xám)
    paint.color = Colors.grey[300]!;
    canvas.drawPath(path, paint);

    // Vẽ đường progress (màu xanh)
    if (progress > 0) {
      final progressPath = _createProgressPath(path, progress);
      paint.color = const Color.fromARGB(255, 88, 165, 193);
      paint.strokeWidth = 4.0; //độ dày
      canvas.drawPath(progressPath, paint);
    }

    // Vẽ điểm bắt đầu
    final startCirclePaint = Paint()
      ..color = progress > 0
          ? const Color.fromARGB(255, 93, 173, 238)
          : Colors.grey[400]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(startPoint, 8, startCirclePaint);

    // Vẽ viền điểm bắt đầu
    final startBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(startPoint, 5, startBorderPaint);

    // Vẽ điểm kết thúc
    final endCirclePaint = Paint()
      ..color = progress >= 1.0 ? Colors.blue : Colors.grey[400]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(endPoint, 8, endCirclePaint);

    // Vẽ viền điểm kết thúc
    final endBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(endPoint, 5, endBorderPaint);

    // Vẽ điểm progress hiện tại - giữ lại cả khi progress = 1.0
    if (progress > 0) {
      final currentPoint = _getPointOnPath(path, progress);
      final currentCirclePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 10, currentCirclePaint);

      final currentBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 6, currentBorderPaint);
    }
  }

  Path _createProgressPath(Path originalPath, double progress) {
    final pathMetrics = originalPath.computeMetrics();
    final pathMetric = pathMetrics.first;
    final length = pathMetric.length;
    return pathMetric.extractPath(0, length * progress);
  }

  Offset _getPointOnPath(Path path, double progress) {
    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.first;
    final length = pathMetric.length;
    final tangent = pathMetric.getTangentForOffset(length * progress);
    return tangent?.position ?? Offset.zero;
  }

  @override
  bool shouldRepaint(CurvedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
