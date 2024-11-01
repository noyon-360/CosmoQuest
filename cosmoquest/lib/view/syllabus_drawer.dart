import 'package:cosmoquest/Model/Game%20_2/level_model.dart';
import 'package:cosmoquest/Utils/Game_2/levels_data.dart';
import 'package:flutter/material.dart';

class SyllabusDrawer extends StatelessWidget {
  final List<LevelModel> levels = getLevelsData(); // Fetch your levels data

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer header with the title "Syllabus"
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff580070), // Customize the header color
            ),
            child: Center(
              child: Text(
                'Level Content',
                style: TextStyle(
                  color: Colors.white, // Header text color
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // ListView to display levels
          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                LevelModel level = levels[index];

                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xff580070), // Customize color as needed
                    child: Text(
                      level.levelNumber.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    level.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(level.subtitle),
                  onTap: () {
                    // Define any action when the list item is tapped
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}