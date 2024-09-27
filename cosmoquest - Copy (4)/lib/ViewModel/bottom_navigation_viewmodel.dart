import 'package:cosmoquest/Utils/apis.dart';
import 'package:cosmoquest/view/Auth/Profile.dart';
import 'package:cosmoquest/view/ExoplanetDiscover/habitable_zone_view.dart';
import 'package:cosmoquest/view/Game/GameHome.dart';
import 'package:cosmoquest/view/Game/Leaderboard.dart';
import 'package:cosmoquest/view/Game/game_level_map.dart';
import 'package:cosmoquest/view/Game/levels_map.dart';
import 'package:flutter/material.dart';

class BottomNavigationViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  String uid = Apis.user.uid.toString();
  int get selectedIndex => _selectedIndex;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    LevelMapScreen(),
    PlanetView(),
    LeaderboardPage(),
    UserProfile()
  ];

  List<Widget> get widgetOptions => _widgetOptions;

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notify the view to rebuild when the index changes
  }
}
