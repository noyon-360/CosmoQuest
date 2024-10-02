import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final List<Offset> positions;

  DottedLinePainter(this.positions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    const double dashWidth = 2.0;
    const double dashSpace = 3.0;

    for (int i = 0; i < positions.length - 1; i++) {
      Offset start = positions[i];
      Offset end = positions[i + 1];

      // Calculate the total distance between the two points
      double distance = (end - start).distance;
      // Calculate direction between two points
      Offset direction = (end - start) / distance;

      double currentDistance = 0;
      while (currentDistance < distance) {
        // Draw dash
        final dashStart = start + direction * currentDistance;
        final dashEnd = start + direction * (currentDistance + dashWidth);
        canvas.drawLine(dashStart, dashEnd, paint);

        // Update the distance to account for the dash and space
        currentDistance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
