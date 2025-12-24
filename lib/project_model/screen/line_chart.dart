

import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final String title;

  const LineChartWidget({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    // Ensure maxValue is at least 1 to avoid division by zero
    maxValue = maxValue < 1 ? 100 : maxValue;

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

          // Chart with y-axis
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Y-axis labels
                SizedBox(
                  width: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      double label = (maxValue / 4) * (4 - index);
                      return Text(
                        label.toInt().toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 8),

                // Line chart
                Expanded(
                  child: Stack(
                    children: [
                      // Grid lines
                      _buildGridLines(maxValue),
                      // Line chart
                      CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: LineChartPainter(data: data, maxValue: maxValue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // X-axis labels
          Container(
            height: 20,
            margin: const EdgeInsets.only(left: 38), // Match y-axis width
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 80) / data.length,
                  child: Text(
                    data[index].label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridLines(double maxValue) {
    return Positioned.fill(
      child: CustomPaint(
        painter: GridLinePainter(maxValue: maxValue),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double maxValue;

  LineChartPainter({required this.data, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    if (data.isEmpty) return;

    double xStep = size.width / (data.length - 1);
    double yScale = size.height / maxValue;

    // Start fill path from bottom left
    fillPath.moveTo(0, size.height);

    for (int i = 0; i < data.length; i++) {
      double x = i * xStep;
      double y = size.height - (data[i].value * yScale);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw dots
      canvas.drawCircle(Offset(x, y), 5, dotPaint);

      // Draw value labels
      _drawValueLabel(canvas, Offset(x, y - 15), data[i].value.toInt().toString());
    }

    // Complete fill path to bottom right
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw filled area
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, paint);
  }

  void _drawValueLabel(Canvas canvas, Offset position, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GridLinePainter extends CustomPainter {
  final double maxValue;

  GridLinePainter({required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    for (int i = 0; i < 5; i++) {
      double y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

final List<ChartData> monthlyData = [
  ChartData(label: 'Jan', value: 60, color: Colors.blue),
  ChartData(label: 'Feb', value: 40, color: Colors.blue),
  ChartData(label: 'Mar', value: 20, color: Colors.blue),
  ChartData(label: 'Apr', value: 0, color: Colors.blue),
  ChartData(label: 'May', value: 45, color: Colors.blue),
  ChartData(label: 'Jun', value: 65, color: Colors.blue),
  ChartData(label: 'Jul', value: 80, color: Colors.blue),
  ChartData(label: 'Aug', value: 75, color: Colors.blue),
  ChartData(label: 'Sep', value: 90, color: Colors.blue),
  ChartData(label: 'Oct', value: 85, color: Colors.blue),
  ChartData(label: 'Nov', value: 70, color: Colors.blue),
  ChartData(label: 'Dec', value: 95, color: Colors.blue),
];

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
