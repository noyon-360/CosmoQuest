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
        // height: 50,
        // width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), // add a rounded corner
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Image.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                ),
              ),
            ),
            const SizedBox(width: 10), // Add some space between the icon and the text
            Align(
              alignment: Alignment.center,
              child: const Text(
                "Continue with Google",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Change the text color to blue
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}