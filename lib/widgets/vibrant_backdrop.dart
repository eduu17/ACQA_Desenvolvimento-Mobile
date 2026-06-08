import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class VibrantBackdrop extends StatelessWidget {
  const VibrantBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VibrantBackdropPainter(
        palette: context.palette,
        isDark: Theme.of(context).brightness == Brightness.dark,
      ),
    );
  }
}

class _VibrantBackdropPainter extends CustomPainter {
  const _VibrantBackdropPainter({
    required this.palette,
    required this.isDark,
  });

  final AppPalette palette;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [palette.background, palette.backgroundEnd],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, base);

    _drawRibbon(
      canvas,
      size,
      color: AppColors.sky.withAlpha(isDark ? 42 : 84),
      top: size.height * 0.04,
      amplitude: size.height * 0.12,
      thickness: size.height * 0.18,
      phase: 0,
    );
    _drawRibbon(
      canvas,
      size,
      color: AppColors.violet.withAlpha(isDark ? 48 : 66),
      top: size.height * 0.28,
      amplitude: size.height * 0.10,
      thickness: size.height * 0.14,
      phase: 0.7,
    );
    _drawRibbon(
      canvas,
      size,
      color: AppColors.coral.withAlpha(isDark ? 44 : 72),
      top: size.height * 0.56,
      amplitude: size.height * 0.08,
      thickness: size.height * 0.16,
      phase: 1.1,
    );

    final stripePaint = Paint()
      ..color = AppColors.citrus.withAlpha(isDark ? 72 : 122)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < 6; index++) {
      final y = size.height * 0.84 + index * 15;
      canvas.drawLine(
        Offset(size.width * 0.08, y),
        Offset(size.width * 0.34, y - size.height * 0.04),
        stripePaint,
      );
    }

    final glintPaint = Paint()
      ..color = Colors.white.withAlpha(isDark ? 28 : 90)
      ..strokeWidth = 1.2;

    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.16),
      Offset(size.width * 0.92, size.height * 0.07),
      glintPaint,
    );
  }

  void _drawRibbon(
    Canvas canvas,
    Size size, {
    required Color color,
    required double top,
    required double amplitude,
    required double thickness,
    required double phase,
  }) {
    final path = Path()..moveTo(0, top + amplitude * phase);

    path.cubicTo(
      size.width * 0.22,
      top - amplitude,
      size.width * 0.42,
      top + amplitude * 1.8,
      size.width * 0.68,
      top + amplitude * 0.3,
    );
    path.cubicTo(
      size.width * 0.82,
      top - amplitude * 0.4,
      size.width,
      top + amplitude * 0.8,
      size.width,
      top + amplitude * 0.1,
    );
    path.lineTo(size.width, top + thickness);
    path.cubicTo(
      size.width * 0.78,
      top + thickness + amplitude,
      size.width * 0.52,
      top + thickness - amplitude,
      size.width * 0.24,
      top + thickness + amplitude * 0.5,
    );
    path.cubicTo(
      size.width * 0.12,
      top + thickness + amplitude,
      0,
      top + thickness * 0.82,
      0,
      top + thickness,
    );
    path.close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _VibrantBackdropPainter oldDelegate) {
    return oldDelegate.palette != palette || oldDelegate.isDark != isDark;
  }
}
