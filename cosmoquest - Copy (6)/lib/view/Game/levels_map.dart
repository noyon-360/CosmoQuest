import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Model/user_progress.dart';
import 'package:cosmoquest/Utils/Game_2/levels_data.dart';
import 'package:cosmoquest/Utils/SnackbarUtil.dart';
import 'package:cosmoquest/view/ExoplanetDiscover/exoplanet_discover.dart';
import 'package:cosmoquest/view/ExoplanetDiscover/habitable_zone_view.dart';
import 'package:cosmoquest/view/Game/container_dot_line.dart';
import 'package:cosmoquest/view/Game/game_level_map.dart';
import 'package:cosmoquest/view/Game_2/learning_screen.dart';
import 'package:cosmoquest/view/Map%20Containers/container_list.dart';
import 'package:flutter/material.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  _LevelMapScreenState createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  List<bool> levelLocks =
      List.generate(20, (index) => true); // All levels start locked
  List<int> ratings = List.generate(20, (index) => 0);

  late TransformationController _controller;



  double _scale = 5.0; // Set your initial scale here

  // _controller = TransformationController();

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
    _controller = TransformationController();

    // Use Future.delayed to ensure the build is complete before applying the initial transform
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerImage();
    });
    // Use Future.delayed to ensure the build is complete before applying the initial transform
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _centerUserLevel();
    // });
    _controller.value = Matrix4.identity()..scale(_scale);
  }

  Future<void> _loadUserProgress() async {
    final userProgress = UserProgressLocalStore();
    int currentLevel = await userProgress.getLevel() ?? 0;
    List<int> savedRating = await userProgress.getRating();

    setState(() {
      levelLocks = List.generate(20, (index) => index > currentLevel);
      ratings = savedRating;
    });
  }

  // Center the view on the current user's level
  void _centerUserLevel() {
    int currentLevelIndex = levelLocks.indexWhere((unlocked) => !unlocked);
    if (currentLevelIndex == -1) currentLevelIndex = 0; // Fallback to first level

    // Get the positions of the levels
    final positions = [
      const Offset(0.24, 0.57), // level 1
      const Offset(0.44, 0.56), // level 2
      const Offset(0.34, 0.50), // level 3
      const Offset(0.34, 0.43), // level 4
      const Offset(0.21, 0.44), // level 5
      const Offset(0.29, 0.40), // level 6
      const Offset(0.48, 0.384), // level 7
      const Offset(0.49, 0.46), // level 8
      const Offset(0.54, 0.53), // level 9
      const Offset(0.65, 0.47), // level 10
      const Offset(0.65, 0.60), // level 11
      const Offset(0.74, 0.41), // level 12
      const Offset(0.78, 0.35), // level 13
      const Offset(0.62, 0.33), // level 14
      const Offset(0.78, 0.29), // level 15
      const Offset(0.66, 0.26), // level 16
      const Offset(0.49, 0.26), // level 17
      const Offset(0.42, 0.33), // level 18
      const Offset(0.24, 0.25), // level 19
      const Offset(0.20, 0.33), // level 20
    ];

    // Get the position of the current level
    Offset currentLevelPosition = positions[currentLevelIndex];

    // Get the size of the screen to calculate translation
    Size screenSize = MediaQuery.of(context).size;

    // Translate the image to center the user's current level
    Offset initialOffset = Offset(
      -(currentLevelPosition.dx * screenSize.width - screenSize.width / 2),
      -(currentLevelPosition.dy * screenSize.height - screenSize.height / 2),
    );

    // Apply the scale and translation to the transformation controller
    _controller.value = Matrix4.identity()
      ..scale(_scale)
      ..translate(initialOffset.dx, initialOffset.dy);
  }

  Future<void> _resetLevels() async {
    final userProgressLocalStore = UserProgressLocalStore();
    final userProgressFireStore = UserProgressFireStore();

    await userProgressLocalStore.resetProgress();
    await userProgressFireStore.resetProgress();

    setState(() {
      levelLocks = List.generate(
          20, (index) => index != 0); // Unlock the first level (index 0) only
    });

    SnackBarUtil.showSnackbar(
        context, 'Levels have been reset. Only the first level is unlocked.');
  }


  // void _centerImage() {
  //   // Get the screen size
  //   Size screenSize = MediaQuery.of(context).size;
  //
  //   // Desired focus point on the image (Offset(0.24, 0.57)) relative to the image size
  //   Offset focusPoint = const Offset(-0.50, 0.57);
  //
  //   // Calculate the scaled position of the focus point
  //   double scaledFocusX = focusPoint.dx * screenSize.width * _scale;
  //   double scaledFocusY = focusPoint.dy * screenSize.height * _scale;
  //
  //   // Calculate the translation needed to center the focus point on the screen
  //   double translateX = screenSize.width / 2 - scaledFocusX;
  //   double translateY = screenSize.height / 2 - scaledFocusY;
  //
  //   // Apply the scale and translation to the transformation controller
  //   _controller.value = Matrix4.identity()
  //     ..scale(_scale)
  //     ..translate(translateX, translateY);
  // }


  void _centerImage() {
    // Get the size of the image and the device screen
    double initialScale = 2.5; // Define your initial scale here
    Size screenSize = MediaQuery.of(context).size;

    // Translate the image to center it on the screen
    // Set the initial offset to center the image in the viewport
    Offset initialOffset =
        Offset(-screenSize.width / 4, -screenSize.height / 4);

    // Apply the scale and translation to the transformation controller
    _controller.value = Matrix4.identity()
      ..scale(initialScale)
      ..translate(initialOffset.dx, initialOffset.dy);
  }

  void _onLevelTap(int index) {
    if (!levelLocks[index]) {
      List<LevelModel> levels = getLevelsData();
      LevelModel currentLevel = levels[index];


      // Check if the level has learning parts
      if (currentLevel.learningParts.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LearningScreen(
              level: currentLevel,
            ),
          ),
        );
      } else {
        SnackBarUtil.showSnackbar(context, 'No learning content available for this level.');
      }
    } else {
      SnackBarUtil.showSnackbar(context, 'Level ${index + 1} is locked.');
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double imageWidth = constraints.maxWidth;
            double imageHeight = constraints.maxHeight;

            // Define the positions of the level buttons
            //- x +, - y +
            final positions = [
              const Offset(0.24, 0.57), //level 1
              const Offset(0.44, 0.56), // level 2
              const Offset(0.34, 0.50), // level 3
              const Offset(0.34, 0.43), // level 4
              const Offset(0.21, 0.44), // level 5
              const Offset(0.29, 0.40), // level 6
              const Offset(0.48, 0.384), // level 7
              const Offset(0.49, 0.46), // level 8
              const Offset(0.54, 0.53), // level 9
              const Offset(0.65, 0.47), // level 10
              const Offset(0.65, 0.60), // level 11
              const Offset(0.74, 0.41), // level 12
              const Offset(0.78, 0.35), // level 13
              const Offset(0.62, 0.33), // level 14
              const Offset(0.78, 0.29), // level 15
              const Offset(0.66, 0.26), // level 16
              const Offset(0.49, 0.26), // level 17
              const Offset(0.42, 0.33), // level 18
              const Offset(0.24, 0.25), // level 19
              const Offset(0.20, 0.33), // level 20
            ];

            // Scale positions based on the image size
            final scaledPositions = positions
                .map((position) =>
                    Offset(position.dx * imageWidth, position.dy * imageHeight))
                .toList();

            return InteractiveViewer(
              panEnabled: true,
              minScale: 2.0,
              maxScale: 7.0,
              transformationController: _controller,
              child: SizedBox(
                width: imageWidth, // Use calculated image width
                height: imageHeight, // Use calculated image height
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/Background/Level Map BG.jpg',
                      width: imageWidth, // Set the width of the image
                      height: imageHeight, // Set the height of the image
                      fit: BoxFit.cover, // Ensure the image covers the container
                    ),
                    // Level buttons positioned manually based on image coordinates

                    Positioned(
                      left: 0.159 * imageWidth - (60 / 2),
                      top: 0.58 * imageHeight - (60 / 2),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.asset('assets/Containers/1.1.png'),
                        ),
                      ),
                    ),

                    // Positioned(
                    //   left: 0.20 * imageWidth ,
                    //   top: 0.33 * imageHeight ,
                    //   child: SizedBox(
                    //     width: 40,
                    //     height: 40,
                    //     child: FittedBox(
                    //       fit: BoxFit.fill,
                    //       child: Image.asset('assets/containers/19.png'),
                    //     ),
                    //   ),
                    // ),
                    // Add CustomPaint to draw dotted lines between positions
                    CustomPaint(
                      size: Size(imageWidth, imageHeight),
                      painter: DottedLinePainter(scaledPositions),
                    ),

                    for (int i = 0; i < positions.length; i++)
                      Positioned(
                        left: positions[i].dx * imageWidth - (60 / 2),
                        // Center horizontally
                        top: positions[i].dy * imageHeight - (60 / 2),
                        // Center vertically
                        child: Column(
                          children: [
                            _buildRatingStars(i),
                            _buildLevelButton(i),
                          ],
                        )
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOtherBG(int index) {
    return Stack(
      children: [otherContainers[index]],
    );
  }

  Widget _buildRatingStars(int index) {
    int levelRating = ratings[index];
    // final iconSize =
    //     imageWidth * 0.05; // Adjust star size relative to image width

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (starIndex) {
        return Icon(
          Icons.star,
          color: starIndex < levelRating ? Colors.yellow : Colors.grey,
          size: starIndex == 1 ? 12 : 9,
        );
      }),
    );
  }

  Widget _buildLevelButton(int index) {
    // final circleRadius =
    //     imageWidth * 0.04; // Circle radius as a percentage of image width
    // final iconSize =
    //     imageWidth * 0.04; // Icon size as a percentage of image width

    return GestureDetector(
      onTap: () => _onLevelTap(index),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              width: 60,
              child: containers[index]),
          Icon(levelLocks[index] ? Icons.lock : null,
              color: Colors.white, size: 15),
        ],
      ),
      // CircleAvatar(
      //   radius: 15,
      //   backgroundColor: Colors.transparent,
      //   child: Stack(
      //     alignment: Alignment.center,
      //     children: [
      //       containers[index],
      //       Icon(levelLocks[index] ? Icons.lock : null, color: Colors.white, size: 15),
      //
      //     ],
      //   ),
      // ),
    );
  }
}
