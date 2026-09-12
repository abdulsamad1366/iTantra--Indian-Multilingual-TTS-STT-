import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaveformVisualizer extends StatelessWidget {
  final List<double> amplitudes;
  final bool isActive;

  const WaveformVisualizer({
    super.key,
    required this.amplitudes,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomPaint(
        painter: WaveformPainter(amplitudes, isActive),
        child: Container(),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final bool isActive;

  WaveformPainter(this.amplitudes, this.isActive);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isActive ? AppTheme.activeGreen : AppTheme.textSecondary.withOpacity(0.3)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final barSpacing = size.width / (amplitudes.length - 1);
    final centerY = size.height / 2;

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * barSpacing;
      final height = (amplitudes[i] * size.height).clamp(4.0, size.height);
      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) => true;
}
