import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/ViewModel/UserProfileViewModel.dart';
import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:cosmoquest/view/Game/levels_map.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CongratulatoryPage extends StatefulWidget {
  const CongratulatoryPage({super.key});

  @override
  _CongratulatoryPageState createState() => _CongratulatoryPageState();
}

class _CongratulatoryPageState extends State<CongratulatoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;




  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // Adjust the duration of the zoom effect
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation when the page loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background with scaling effect
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Background/create account congrats.jpg'), // Replace with your background path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.4), // Dark overlay for better contrast
          ),
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Lottie congratulatory animation (one-time play)
                    SizedBox(
                      height: 150,
                      child: Lottie.asset(
                        'assets/Animations/congratulations.json', // Replace with your animation
                        repeat: false, // Ensure the animation plays only once
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Congratulatory Text
                    const Text(
                      "Congratulations!",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Success message
                    const Text(
                      "Account Created\nSuccessfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Proceed to next screen (like starting the quiz or go to dashboard)
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to quiz or dashboard
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationBarHome()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Start Quiz",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 250,
                      child: Lottie.asset(
                        'assets/Animations/congratulations 2.json', // Replace with your animation
                        repeat: false, // Ensure the animation plays only once
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
