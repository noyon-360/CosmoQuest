import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatefulWidget {
  final VoidCallback onComplete;

  const LoadingWidget({Key? key, required this.onComplete}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.forward().then((_) {
      // Call onComplete after the animation completes
      widget.onComplete();
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      bottom: _controller.isAnimating ? 0 : -200, // Adjust this value based on your animation height
      left: 0,
      right: 0,
      child: Container(
        color: Colors.transparent,
        child: Lottie.asset(
          'assets/Animations/loading.json', // Path to your Lottie file
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
          },
        ),
      ),
    );
  }
}
