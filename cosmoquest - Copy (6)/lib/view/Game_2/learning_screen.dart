import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/view/Game_2/Screens/GameScreen.dart';
import 'package:cosmoquest/view/Game_2/document_screen.dart';
import 'package:cosmoquest/view/Video/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LearningScreen extends StatelessWidget {
  final LevelModel level;

  const LearningScreen({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, // Transparent status bar
    //   statusBarIconBrightness:
    //       Brightness.light, // Light icons on the status bar
    // ));

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: Text("Level ${level.levelNumber}"),
      // ),
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
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    // margin: EdgeInsets.only(top: statusBarHeight + kToolbarHeight),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/Background/Learning page background.jpg'),
                        // Replace with your image
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: const Color(0xff2e3b75).withOpacity(0.7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                level.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,), textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                        ]),
                  ),

                  Positioned(
                      top: 40,
                      left: 30,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back_outlined, color: Colors.white,size: 24,)),
                          const SizedBox(width: 10,),
                          Text("Level ${level.levelNumber}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                        ],
                      )),

                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.3,
                    left: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.17,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xcd60b9df),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/Astronaut Holding Laptop.png",
                                width: 90,
                                fit: BoxFit
                                    .contain, // Ensures image fits well in the available space
                              ),
                            ),
                            // const SizedBox(width: 5.0), // Spacing between image and text
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
                                    textAlign: TextAlign.center,
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
              // SizedBox(
              //   height: 40,
              // ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 70.0,
                ),
                child: Text(
                  "Course Content",
                  style: TextStyle(
                      color: Color(0xff01103b),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: level.learningParts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    // crossAxisSpacing: 10.0, // Spacing between columns
                    // mainAxisSpacing: 10.0, // Spacing between rows
                    // childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final part = level.learningParts[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Material(
                        elevation: 8.0,
                        color: const Color(0xff01103b),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            // Navigate to respective screen based on type
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
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                part.type == "video"
                                    ? Icons.play_arrow
                                    : Icons.document_scanner,
                                size: 50.0,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                part.type == "video" ? "Video" : "Document",
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
          // Positioned(
          //   top: MediaQuery.of(context).size.height * 0.3,
          //   left: MediaQuery.of(context).size.width * 0.1, // Center the container horizontally
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.8, // Use width relative to screen width
          //     height: MediaQuery.of(context).size.height * 0.17,
          //     decoration: const BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //       color: Color(0xfffd8e51),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: Row(
          //         children: [
          //           Flexible(
          //             flex: 1,
          //             child: Image.asset(
          //               "assets/images/Astronaut Holding Laptop.png",
          //               width: 90,
          //               fit: BoxFit.contain, // Ensures image fits well in the available space
          //             ),
          //           ),
          //           // const SizedBox(width: 5.0), // Spacing between image and text
          //           Expanded(
          //             flex: 2,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   level.subtitle,
          //                   style: const TextStyle(
          //                     color: Color(0xff021740),
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                   textAlign: TextAlign.center,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      // Stack(
      //   children: [
      //     Container(
      //         height: MediaQuery.of(context).size.height * 0.4,
      //         width: double.infinity,
      //         decoration: const BoxDecoration(
      //             color: Colors.white30,
      //             borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(20),
      //                 bottomRight: Radius.circular(20))),
      //         child: Stack(
      //           children: [
      //             Container(
      //               // height: MediaQuery.of(context).size.height / 2,
      //               decoration: const BoxDecoration(
      //                 borderRadius: BorderRadius.only(
      //                   bottomLeft: Radius.circular(20),
      //                   bottomRight: Radius.circular(20),
      //                 ),
      //                 image: DecorationImage(
      //                   image: AssetImage(
      //                       'assets/Background/Learning page background.jpg'),
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.all(20.0),
      //               child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   children: [
      //                     Center(
      //                       child: Container(
      //                         color: Colors.blue,
      //                         child: Text(
      //                           level.title,
      //                           style: const TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 28,
      //                               fontWeight: FontWeight.bold),
      //                         ),
      //                       ),
      //                     ),
      //                     // const SizedBox(height: 10,),
      //                     // Container(
      //                     //     color: Colors.white30,
      //                     //     child: Text(level.subtitle, style: const TextStyle(color: Colors.white,) ,))
      //                   ]),
      //             ),
      //           ],
      //         )),
      //     Positioned(
      //         bottom: -10,
      //         child: Container(
      //           height: 100,
      //           width: 100,
      //           color: Colors.blueGrey,
      //         )),
      //     // Expanded(
      //     //   child: ListView.builder(
      //     //     itemCount: level.learningParts.length,
      //     //     itemBuilder: (context, index) {
      //     //       final part = level.learningParts[index];
      //     //       return Padding(
      //     //         padding: const EdgeInsets.all(8.0),
      //     //         child: ListTile(
      //     //           tileColor: Colors.blue,
      //     //           // Color for the first item
      //     //           shape: RoundedRectangleBorder(
      //     //             borderRadius:
      //     //             BorderRadius.circular(16), // Rounded corners
      //     //           ),
      //     //           leading: Icon(part.type == "video"
      //     //               ? Icons.movie
      //     //               : Icons.document_scanner),
      //     //           // Icon for the first item
      //     //           title: Text(part.type == "video"
      //     //               ? "${index + 1} Video"
      //     //               : "${index + 1} Document"),
      //     //           subtitle: Text(part.content),
      //     //           trailing: const Icon(Icons.arrow_forward),
      //     //           // Trailing icon for all items
      //     //           onTap: () {
      //     //             // Navigate to respective screen based on type
      //     //             if (part.type == "video") {
      //     //               Navigator.push(
      //     //                 context,
      //     //                 MaterialPageRoute(
      //     //                   builder: (context) => VideoPlayerScreen(
      //     //                     level: level,
      //     //                     videoPath: part.content,
      //     //                   ),
      //     //                 ),
      //     //               );
      //     //             } else if (part.type == "document") {
      //     //               Navigator.push(
      //     //                 context,
      //     //                 MaterialPageRoute(
      //     //                   builder: (context) => DocumentScreen(
      //     //                     level: level,
      //     //                     link: part.content,
      //     //                   ),
      //     //                 ),
      //     //               );
      //     //             }
      //     //           },
      //     //         ),
      //     //       );
      //     //     },
      //     //   ),
      //     // ),
      //     // const Spacer(),
      //   ],
      // ),

      // Next button to navigate to games
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // Add some padding
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
                  // Center the Row content
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
