// import 'package:flutter/material.dart';
//
// class HomeViewModel extends ChangeNotifier {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   Animation<double> get animation => _animation;
//
//   void initAnimation(TickerProvider vsync) {
//     // Initialize the animation controller and animation
//     _controller = AnimationController(
//       vsync: vsync,
//       duration: const Duration(seconds: 20),
//     );
//
//     _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );
//
//     // Avoid calling notifyListeners immediately to prevent setState errors
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _controller.repeat(reverse: true);
//       notifyListeners();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.stop();
//     _controller.dispose();
//     super.dispose();
//   }
// }
