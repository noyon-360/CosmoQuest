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
              backgroundColor: Color(0xff22004c),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Explore',
                backgroundColor: Color(0xff100f26)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_outlined),
              label: 'Leaderboard',
              backgroundColor: Color(0xff141c41),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
              backgroundColor: Color(0xff172e4c),
            ),
          ],
          currentIndex: viewModel.selectedIndex,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white,
          onTap: viewModel.onItemTapped, // Use the ViewModel function
        ),
      ),
    );
  }
}
