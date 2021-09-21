import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter(
      {this.animation,
      this.neumorphicEffect = true,
      this.backgroundColor,
      this.fillColor,
      this.fillGradient,
      this.neonColor,
      this.neonGradient,
      this.strokeWidth,
      this.strokeCap,
      this.outerStrokeColor,
      this.outerStrokeGradient})
      : assert((neumorphicEffect && backgroundColor != null)),
        super(repaint: animation);

  final Animation<double>? animation;
  final bool neumorphicEffect;
  final Color? fillColor, neonColor, outerStrokeColor, backgroundColor;
  final double? strokeWidth;
  final StrokeCap? strokeCap;
  final Gradient? fillGradient, neonGradient, outerStrokeGradient;

  @override
  void paint(Canvas canvas, Size size) {
    Paint blurPaint = Paint()
      ..color = neonColor!
      ..strokeWidth = strokeWidth!
      ..strokeCap = strokeCap!
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5)
      ..style = PaintingStyle.stroke;
    Paint strokePaint = Paint()
      ..color = neonColor!.withOpacity(0.8)
      ..strokeWidth = strokeWidth!
      ..strokeCap = strokeCap!
      ..style = PaintingStyle.stroke;

    Paint neumorphicPaint = Paint();
    Paint innerPaint = Paint();
    Paint backgroundPaint = Paint();
    if (neumorphicEffect) {
      neumorphicPaint
        ..color = outerStrokeColor!
        ..strokeWidth = strokeWidth! + 4
        ..strokeCap = strokeCap!
        ..style = PaintingStyle.stroke;
      innerPaint
        ..color = fillColor!
        ..strokeWidth = strokeWidth!
        ..strokeCap = strokeCap!
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.inner, 4);
      backgroundPaint
        ..color = backgroundColor!
        ..style = PaintingStyle.fill;
    }

    if (neonGradient != null) {
      final rect = Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2);
      blurPaint..shader = neonGradient!.createShader(rect);
    } else {
      blurPaint..shader = null;
    }

    double progress = (animation!.value) * 2 * math.pi;

    if (fillGradient != null) {
      final rect = Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2);
      strokePaint..shader = fillGradient!.createShader(rect);
    } else {
      strokePaint..shader = null;
      strokePaint.color = fillColor!;
    }
    Path path = Path();

    path.addArc(Offset.zero & size, math.pi * 1.5, progress);

    Path path_1 = Path()..addArc(Offset.zero & size, 0, math.pi * 2);
    if (neumorphicEffect) {
      canvas.drawShadow(path_1, Colors.black54, 2, true);
      canvas.drawPath(path_1, neumorphicPaint);
      canvas.drawPath(path_1, innerPaint);
      canvas.drawCircle(Offset(size.width / 2, size.height / 2),
          size.width / 2 - strokeWidth! + 2, backgroundPaint);
    }

    canvas.drawPath(path, strokePaint);
    canvas.drawPath(path, blurPaint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation!.value != old.animation!.value ||
        neonColor != old.neonColor ||
        fillColor != old.fillColor;
  }
}
