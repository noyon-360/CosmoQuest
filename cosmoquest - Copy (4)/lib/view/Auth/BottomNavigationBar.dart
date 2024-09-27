import 'package:cosmoquest/ViewModel/bottom_navigation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarHome extends StatelessWidget {
  const BottomNavigationBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BottomNavigationViewModel>(context);

    return Scaffold(
      body: Center(
        child: viewModel.widgetOptions.elementAt(viewModel.selectedIndex),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Color(0xff70037a),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Explore',
                backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_outlined),
              label: 'Leaderboard',
              backgroundColor: Color(0xff141c41),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
              backgroundColor: Colors.pink,
            ),
          ],
          currentIndex: viewModel.selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: viewModel.onItemTapped, // Use the ViewModel function
        ),
      ),
    );
  }
}
