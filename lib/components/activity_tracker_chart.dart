import 'package:flutter/material.dart';

class ActivityTrackerChart extends StatelessWidget {
  final List<double> weeklyData;
  final int highlightedIndex;
  final String tooltipText;

  const ActivityTrackerChart({
    super.key,
    required this.weeklyData,
    this.highlightedIndex = 4, // Defaults to Thursday matching mockup
    this.tooltipText = '13,000 / 2120Kcal',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activity Tracker',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            Text(
              'Month >',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _BarChartPainter(
              data: weeklyData,
              highlightedIndex: highlightedIndex,
              tooltipText: tooltipText,
            ),
          ),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final int highlightedIndex;
  final String tooltipText;

  const _BarChartPainter({
    required this.data,
    required this.highlightedIndex,
    required this.tooltipText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    // Draw background grid lines (horizontal ticks)
    for (int i = 0; i < 4; i++) {
      final y = size.height * 0.25 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final barWidth = size.width / (data.length * 2);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat'];

    for (int i = 0; i < data.length; i++) {
      final isHighlighted = i == highlightedIndex;
      final x = (i * 2 + 0.5) * barWidth * 2;
      final barHeight = size.height * 0.7 * data[i];

      // Draw background bar container column
      final bgPaint = Paint()
        ..color = const Color(0xFFEFF6FF)
        ..style = PaintingStyle.fill;
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 10, barWidth, size.height * 0.7),
        const Radius.circular(8),
      );
      canvas.drawRRect(bgRect, bgPaint);

      // Draw dynamic active value bar inside column
      final valuePaint = Paint()
        ..color = isHighlighted ? const Color(0xFF2563EB) : const Color(0xFF3B82F6).withOpacity(0.8)
        ..style = PaintingStyle.fill;

      final valRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height * 0.7 - barHeight + 10, barWidth, barHeight),
        const Radius.circular(8),
      );
      canvas.drawRRect(valRect, valuePaint);

      // Draw highlighted tooltip indicator bubble on top of Thursday
      if (isHighlighted) {
        // Draw little pulse circle
        final pulsePaint = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(x + barWidth / 2, size.height * 0.7 - barHeight + 10), 4, pulsePaint);

        // Draw floating tool-tip text bubble
        final bubblePaint = Paint()..color = const Color(0xFF1E293B);
        final bubblePath = Path()
          ..moveTo(x - 40, size.height * 0.7 - barHeight - 15)
          ..lineTo(x + barWidth + 40, size.height * 0.7 - barHeight - 15)
          ..lineTo(x + barWidth + 40, size.height * 0.7 - barHeight - 35)
          ..lineTo(x - 40, size.height * 0.7 - barHeight - 35)
          ..close();

        canvas.drawPath(bubblePath, bubblePaint);

        textPainter.text = TextSpan(
          text: tooltipText,
          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - 30, size.height * 0.7 - barHeight - 29),
        );
      }

      // Draw label under column
      textPainter.text = TextSpan(
        text: weekdays[i],
        style: TextStyle(
          color: isHighlighted ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
          fontSize: 10,
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + (barWidth - textPainter.width) / 2, size.height * 0.7 + 16));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
