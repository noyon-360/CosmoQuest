import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        ClipPath(
          clipper: CustomClip(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            width: double.maxFinite,
            height: 200,
            child: const Center(
              child: Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
        Positioned(
          top: 160,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                'Whoops!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red
                ),
              ),
              SizedBox(height: 10),
              Lottie.asset(
                'assets/Animations/loading astronaut.json',
                repeat: true,
                reverse: false,
                animate: true,
                width: 150,
                height: 150,
              ),
              // Text(
              //   'No Internet Connection found.',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              SizedBox(height: 10),
              Text(
                'Check your connection & try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2); // Left side height
    path.lineTo(size.width, size.height); // Right side height
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}