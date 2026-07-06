import 'package:flutter/material.dart';

class EcgAnalysisChart extends StatelessWidget {
  final String title;
  final String timeText;

  const EcgAnalysisChart({
    super.key,
    this.title = 'Heart rate analysis',
    this.timeText = 'Compare last month',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeText,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.favorite, color: Color(0xFFEF4444), size: 10),
                    SizedBox(width: 4),
                    Text(
                      '112',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomPaint(
              painter: _EcgWavePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _EcgWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    for (int i = 0; i < 4; i++) {
      final y = size.height * 0.25 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw ECG heartbeat waveform paths (combination of grey, red, and dark bars matching mockup)
    final barPaint = Paint()
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final barPositions = List.generate(24, (index) => (index + 1) * (size.width / 26));
    
    // Simulate ECG vertical beats
    for (int i = 0; i < barPositions.length; i++) {
      final x = barPositions[i];
      double val = 0.3;
      Color barCol = const Color(0xFFCBD5E1);

      if (i % 6 == 0) {
        val = 0.8;
        barCol = const Color(0xFFEF4444);
      } else if (i % 3 == 0) {
        val = 0.6;
        barCol = const Color(0xFF1E293B);
      } else if (i % 2 == 0) {
        val = 0.4;
        barCol = const Color(0xFF64748B);
      }

      barPaint.color = barCol;
      canvas.drawLine(
        Offset(x, size.height * (0.5 - val / 2)),
        Offset(x, size.height * (0.5 + val / 2)),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
