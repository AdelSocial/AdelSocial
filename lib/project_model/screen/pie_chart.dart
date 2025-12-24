import 'dart:math';

import 'package:flutter/material.dart';


class PieChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final String title;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double total = data.map((e) => e.value).reduce((a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Pie Chart with legend
          Row(
            children: [
              // Pie Chart
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 200,
                  child: CustomPaint(
                    painter: PieChartPainter(data: data, total: total),
                  ),
                ),
              ),

              // Legend
              Expanded(
                flex: 2,
                child: Column(
                  children: data.map((item) => _buildLegendItem(item, total)).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ChartData item, double total) {
    double percentage = (item.value / total) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double total;

  PieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 2 : size.height / 2;
    final radiusWithPadding = radius * 0.9; // Add some padding

    double startAngle = -90 * (3.14159 / 180); // Start from top (-90 degrees)

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var item in data) {
      final sweepAngle = (item.value / total) * 2 * 3.14159;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;

      // Draw arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radiusWithPadding),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      if (sweepAngle > 0.3) {
        double middleAngle = startAngle + sweepAngle / 2;
        double labelRadius = radiusWithPadding * 0.6;

        Offset labelPosition = Offset(
          center.dx + labelRadius * cos(middleAngle),
          center.dy + labelRadius * sin(middleAngle),
        );

        double percentage = (item.value / total) * 100;
        textPainter.text = TextSpan(
          text: '${percentage.toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          labelPosition - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}

final List<ChartData> serviceData = [
  ChartData(label: 'Video', value: 65, color: Colors.blue),
  ChartData(label: 'Audio', value: 45, color: Colors.green),
  ChartData(label: 'Chat', value: 80, color: Colors.orange),
];

