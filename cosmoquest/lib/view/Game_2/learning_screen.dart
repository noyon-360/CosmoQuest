
import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/view/Game_2/Screens/GameScreen.dart';
import 'package:cosmoquest/view/Game_2/document_screen.dart';
import 'package:cosmoquest/view/Nasa/nasa_document.dart';
import 'package:cosmoquest/view/Video/video_player.dart';
import 'package:flutter/material.dart';

class LearningScreen extends StatelessWidget {
  final LevelModel level;

  const LearningScreen({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: const Color(0xfffbeccb),
          ),
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.35, // Adjusted to use screen height proportion
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Background/Learning page background.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: const Color(0xff2e3b75).withOpacity(0.7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              level.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: statusBarHeight + 20,
                    left: 16,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Level ${level.levelNumber}",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.25, // Adjusted based on screen height
                    left: screenWidth * 0.1,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.15, // Adjusted height
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xcd60b9df),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/Astronaut Holding Laptop.png",
                                width: 90,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level.subtitle,
                                    style: const TextStyle(
                                      color: Color(0xff021740),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  "Course Content",
                  style: TextStyle(
                    color: Color(0xff01103b),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: level.learningParts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0, // Keep squares in the grid
                  ),
                  itemBuilder: (context, index) {
                    final part = level.learningParts[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0), // Adjusted padding
                      child: Material(
                        elevation: 8.0,
                        color: const Color(0xff01103b),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            if (part.type == "video") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(
                                    level: level,
                                    videoPath: part.content,
                                  ),
                                ),
                              );
                            } else if (part.type == "document") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocumentScreen(
                                    level: level,
                                    link: part.content,
                                  ),
                                ),
                              );
                            } else if (part.type == "nasa_document") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NasaDocument(apiUrl: part.content),
                                ),
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                part.type == "video" ? Icons.play_arrow : Icons.view_list,
                                size: 50.0,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                part.type == "video" ? "Video" : "Nasa Document",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamesScreen(level: level),
                    ),
                  );
                },
                backgroundColor: const Color(0xff021740),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Let's Start Test",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Icon(Icons.navigate_next, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
