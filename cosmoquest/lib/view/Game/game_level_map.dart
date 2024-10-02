//
//
//
//
//
// import 'package:flutter/material.dart';
//
//
// class ImageButtonGet extends StatefulWidget {
//   const ImageButtonGet({super.key});
//
//   @override
//   State<ImageButtonGet> createState() => _ImageButtonGetState();
// }
//
// class _ImageButtonGetState extends State<ImageButtonGet> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/Background/Level home 1.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           ),
//           Container(
//             width: 143,
//             height: 143,
//             decoration: ShapeDecoration(
//               color: Color(0xFFD9D9D9),
//               shape: OvalBorder(),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
//
// class MovableImageScreen extends StatefulWidget {
//   const MovableImageScreen({super.key});
//
//   @override
//   _MovableImageScreenState createState() => _MovableImageScreenState();
// }
//
// class _MovableImageScreenState extends State<MovableImageScreen> {
//   late TransformationController _transformationController;
//   late Size imageSize;
//
//   // Define the level positions relative to the image
//   final List<Offset> levelPositions = [
//     Offset(0.05, 0.85),  // Level 1
//     Offset(0.10, 0.80),  // Level 2
//     Offset(0.12, 0.75),  // Level 3
//     Offset(0.18, 0.70),  // Level 4
//     Offset(0.22, 0.65),  // Level 5
//     Offset(0.30, 0.60),  // Level 6
//     Offset(0.35, 0.55),  // Level 7
//     Offset(0.40, 0.50),  // Level 8
//     Offset(0.45, 0.45),  // Level 9
//     Offset(0.50, 0.40),  // Level 10
//     Offset(0.55, 0.35),  // Level 11
//     Offset(0.60, 0.30),  // Level 12
//     Offset(0.65, 0.25),  // Level 13
//     Offset(0.70, 0.20),  // Level 14
//     Offset(0.75, 0.15),  // Level 15
//     Offset(0.80, 0.10),  // Level 16
//     Offset(0.85, 0.05),  // Level 17
//     Offset(0.90, 0.10),  // Level 18
//     Offset(0.95, 0.15),  // Level 19
//     Offset(0.99, 0.20),  // Level 20
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize the transformation controller
//     _transformationController = TransformationController();
//
//     // Set the initial focus point to the first level (Level 1)
//     final initialScale = 2.5; // Adjust zoom scale based on how zoomed in you want
//     final firstLevelPosition = Offset(0.05, 0.85); // Estimated position of Level 1
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // After the first layout is complete, set the initial focus
//       _setInitialFocus(firstLevelPosition, initialScale);
//     });
//   }
//
//   void _setInitialFocus(Offset point, double scale) {
//     final screenSize = MediaQuery.of(context).size;
//
//     // Assuming the image size matches the display size for now
//     final focalPointX = point.dx * imageSize.width; // Adjust based on actual image dimensions
//     final focalPointY = point.dy * imageSize.height; // Adjust based on actual image dimensions
//
//     // Calculate translation to center the point on the screen
//     final translateX = screenSize.width / 2 - (focalPointX * scale);
//     final translateY = screenSize.height / 2 - (focalPointY * scale);
//
//     // Apply the transformation matrix to center the specific point
//     _transformationController.value = Matrix4.identity()
//       ..translate(translateX, translateY)
//       ..scale(scale);
//   }
//
//   @override
//   void dispose() {
//     _transformationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           imageSize = Size(1920, 1080); // Set image dimensions here (adjust as needed)
//
//           return Center(
//             child: Container(
//               width: constraints.maxWidth,
//               height: constraints.maxHeight,
//               color: Colors.black,
//               child: InteractiveViewer(
//                 transformationController: _transformationController,
//                 panEnabled: true, // Enable panning
//                 minScale: 1.0,
//                 maxScale: 4.0, // Adjust based on your zoom level preference
//                 child: Stack(
//                   children: [
//                     Image.asset(
//                       'assets/Background/Level home 1.jpg', // Your uploaded image
//                       fit: BoxFit.cover,
//                     ),
//                     ..._buildLevelButtons(),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // Function to generate buttons based on level positions
//   List<Widget> _buildLevelButtons() {
//     return List.generate(levelPositions.length, (index) {
//       final position = levelPositions[index];
//       return Positioned(
//         left: position.dx * imageSize.width,
//         top: position.dy * imageSize.height,
//         child: ElevatedButton(
//           onPressed: () {
//             _onLevelPressed(index + 1);  // Handle the button press
//           },
//           style: ElevatedButton.styleFrom(
//             shape: CircleBorder(), // Circular buttons
//             padding: EdgeInsets.all(15), // Adjust button size
//             backgroundColor: Colors.blueAccent.withOpacity(0.8), // Button color
//           ),
//           child: Text(
//             'Level ${index + 1}',
//             style: TextStyle(fontSize: 12),
//           ),
//         ),
//       );
//     });
//   }
//
//   // Function to handle level button presses
//   void _onLevelPressed(int level) {
//     // For now, just show a snackbar when a level is pressed
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Level $level pressed')),
//     );
//   }
// }
