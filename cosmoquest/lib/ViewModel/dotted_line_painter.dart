// import 'package:flutter/material.dart';
//
// class LinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2.0;
//
//     Offset start = Offset(100 + 25, 100 + 25); // center of element 1
//     Offset end = Offset(200 + 25, 200 + 25); // center of element 2
//
//     canvas.drawLine(start, end, paint);
//   }
//
//   @override
//   bool shouldRepaint(LinePainter oldDelegate) => false;
// }
//
// class MyWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: LinePainter(),
//       child: Container(
//         width: 300,
//         height: 300,
//         color: Colors.white,
//         child: Stack(
//           children: <Widget>[
//             Container(
//               width: 50,
//               height: 50,
//               color: Colors.red,
//               margin: EdgeInsets.only(left: 100, top: 100), // element 1
//             ),
//             Container(
//               width: 50,
//               height: 50,
//               color: Colors.blue,
//               margin: EdgeInsets.only(left: 200, top: 200), // element 2
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }