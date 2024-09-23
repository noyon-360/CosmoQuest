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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Leaderboard',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: viewModel.selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: viewModel.onItemTapped, // Use the ViewModel function
      ),
    );
  }
}
