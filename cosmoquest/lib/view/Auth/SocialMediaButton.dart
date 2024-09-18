import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SocialMediaButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
        elevation: 5,
      ),
      child: Container(
        height: 50,
        // width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(25), // add a rounded corner
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 10), // add some space between the icon and the text
              const Text(
                "Google",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // change the text color to blue
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}