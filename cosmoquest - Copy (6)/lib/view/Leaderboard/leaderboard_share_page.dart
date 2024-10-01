import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class LeaderboardSharePage extends StatefulWidget {
  final Map<String, dynamic> userData; // Assuming you pass user data here

  const LeaderboardSharePage({Key? key, required this.userData})
      : super(key: key);

  @override
  State<LeaderboardSharePage> createState() => _LeaderboardSharePageState();
}

class _LeaderboardSharePageState extends State<LeaderboardSharePage> {
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> _shareImage(ScreenshotController screenshotController) async {
    // Capture the widget as image
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        // Save the image to the temporary directory
        final directory = await getTemporaryDirectory();
        String fileName = 'user_celebration.png';
        String filePath = '${directory.path}/$fileName';

        // Write image data to the file
        final File imgFile = File(filePath);
        await imgFile.writeAsBytes(image);

        // Share the image via social media
        await Share.shareXFiles(
          [XFile(filePath)], // Share the image file as XFile
          text: 'Celebrate with me!',
        );
      }
    }).catchError((error) {
      print('Error capturing image: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Celebrate with Me!'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              _shareImage(screenshotController);
            }, // Share the image on button press
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: _buildCelebrationWidget(), // The widget you want to capture
      ),
    );
  }

  // Widget for user's celebration page
  Widget _buildCelebrationWidget() {
    final user = widget.userData['user'];
    final score = widget.userData['score'];
    final level = widget.userData['level'];

    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF202236),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user['photoUrl'] ?? ''),
            ),
            SizedBox(height: 10),
            Text(
              user['name'] ?? 'Unknown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Level: $level',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Score: $score',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialMediaIcon(Icons.facebook, Colors.blue, 'Facebook'),
                SizedBox(width: 10),
                _buildSocialMediaIcon(Icons.share, Colors.green, 'WhatsApp'),
                SizedBox(width: 10),
                _buildSocialMediaIcon(Icons.mail, Colors.red, 'Email'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcon(IconData icon, Color color, String platform) {
    return InkWell(
      onTap: () {
        // Handle specific social media sharing if required
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 25,
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
