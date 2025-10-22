import 'package:flutter/material.dart';
import '../models/wheel_item.dart';
import 'dart:math';

class DecoratedWheel extends StatefulWidget {
  final List<WheelItem> items;
  final void Function(WheelItem) onResult;

  const DecoratedWheel({
    super.key,
    required this.items,
    required this.onResult,
  });

  @override
  State<DecoratedWheel> createState() => _DecoratedWheelState();
}

class _DecoratedWheelState extends State<DecoratedWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _animation; // ✅ make it nullable
  final random = Random();

  double totalRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  void spin() {
    final spins = random.nextInt(5) + 5; // random number of full spins
    final end = totalRotation + spins * 360 + random.nextInt(360);

    _animation = Tween<double>(
      begin: totalRotation,
      end: end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.reset();
    _controller.forward().whenComplete(() {
      totalRotation = end % 360;

      final anglePerItem = 360 / widget.items.length;

      // ✅ Shift by 90° because the pointer is at the top
      final adjustedRotation = (totalRotation + 90) % 360;

      // ✅ Find which segment the pointer lands on
      final index =
          ((adjustedRotation / anglePerItem).floor()) % widget.items.length;

      final item = widget.items[widget.items.length - 1 - index];
      widget.onResult(item);
    });

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ✅ Use default rotation when _animation is null
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final rotation = (_animation?.value ?? totalRotation) * pi / 180;
            return Transform.rotate(
              angle: rotation,
              child: CustomPaint(
                size: const Size(320, 350),
                painter: WheelPainter(widget.items),
              ),
            );
          },
        ),

        // 🎯 Center SPIN button
        ElevatedButton(
          onPressed: spin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amberAccent,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(28),
            shadowColor: Colors.yellowAccent,
            elevation: 10,
          ),
          child: const Text(
            "🌀",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.5,
            ),
          ),
        ),

        // 🧭 Pointer (fixed)
        Positioned(
          top: 20,
          child: CustomPaint(
            size: const Size(110, 30),
            painter: PointerPainter(),
          ),
        ),
      ],
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<WheelItem> items;

  WheelPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweep = 2 * pi / items.length;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < items.length; i++) {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.primaries[i % Colors.primaries.length].withOpacity(
          0.75,
        );

      final startAngle = i * sweep;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        true,
        paint,
      );

      // ✨ Border
      final borderPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        true,
        borderPaint,
      );

      // 🧿 Symbol text
      final midAngle = startAngle + sweep / 2;
      final textOffset = Offset(
        center.dx + (radius * 0.65) * cos(midAngle),
        center.dy + (radius * 0.65) * sin(midAngle),
      );

      textPainter.text = TextSpan(
        text: items[i].symbol,
        style: const TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 3),
            Shadow(color: Colors.amberAccent, blurRadius: 6),
          ],
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          textOffset.dx - textPainter.width / 2,
          textOffset.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amberAccent
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.2, -size.height);
    path.lineTo(size.width * 0.8, -size.height);
    path.close();

    canvas.drawShadow(path, Colors.black, 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
