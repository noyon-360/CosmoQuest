import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/ViewModel/UserProfileViewModel.dart';
import 'package:cosmoquest/view/Auth/BottomNavigationBar.dart';
import 'package:cosmoquest/view/Game/levels_map.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CongratulatoryPage extends StatefulWidget {
  final String photoUrl;
  final String userName;

  const CongratulatoryPage(
      {super.key, required this.photoUrl, required this.userName});

  @override
  _CongratulatoryPageState createState() => _CongratulatoryPageState();
}

class _CongratulatoryPageState extends State<CongratulatoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  String? photo;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 60), // Adjust the duration of the zoom effect
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    photo = widget.photoUrl;

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
                      image: AssetImage(
                          'assets/Background/create account congrats.jpg'),
                      // Replace with your background path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            color: Colors.black
                .withOpacity(0.4), // Dark overlay for better contrast
          ),
          SizedBox(
            height: 150,
            child: Lottie.asset(
              'assets/Animations/congratulations.json',
              // Replace with your animation
              repeat: false, // Ensure the animation plays only once
            ),
          ),

          SizedBox(
            height: 250,
            child: Lottie.asset(
              'assets/Animations/congratulations 2.json',
              // Replace with your animation
              repeat: false, // Ensure the animation plays only once
            ),
          ),
          Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 70),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: photo != null && photo!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: photo!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.person,
                                        size: 50,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50,
                                    ),
                            ),
                            const SizedBox(height: 10,),
                            Text("Hi, ${widget.userName}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(
                      //   height: 100,
                      // ),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 250,
                            child: Lottie.asset(
                              'assets/Animations/congratulations 2.json',
                              // Replace with your animation
                              repeat: false, // Ensure the animation plays only once
                            ),
                          ),
                          const Column(
                            children: [
                              Text(
                                "Congratulations!",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // SizedBox(height: ),

                              // Success message
                              Text(
                                "Account Created\nSuccessfully",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF545088), Color(0xFF2E23A6)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const BottomNavigationBarHome()));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 45),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Dive In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Congratulatory Text

                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
