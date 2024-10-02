import 'dart:convert';
import 'dart:ui';
import 'package:cosmoquest/Model/ExoplanetModel/PlanetModel.dart';
import 'package:cosmoquest/ViewModel/ExoplanetModel/habitable_view_model.dart';
import 'package:cosmoquest/view/ExoplanetDiscover/apod_page.dart';
import 'package:cosmoquest/view/Web/WebsiteView.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:url_launcher/url_launcher.dart';

class PlanetView extends StatefulWidget {
  const PlanetView({super.key});

  @override
  State<PlanetView> createState() => _PlanetViewState();
}

class _PlanetViewState extends State<PlanetView> {
  final _planetNameController = TextEditingController();
  final PlanetViewModel _planetViewModel = PlanetViewModel();

  List<Planet> planets = [];
  List<Planet> filteredPlanets = [];
  bool isLoading = false;
  String filterOption = 'All'; // Default filter option

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  @override
  void dispose(){
    _planetNameController.dispose();
    super.dispose();
  }

  Future<void> _loadPage() async {
    setState(() {
      isLoading = true;
    });

    List<Planet> newPlanets = await PlanetViewModel.fetchPlanets();
    setState(() {
      planets = newPlanets;
      filteredPlanets = newPlanets; // Initialize the filtered list
      isLoading = false;
    });
    // _sortPlanets(true);
  }

  void _filterPlanets(String query) {
    List<Planet> tempList = planets.where((planet) {
      return planet.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filterOption == 'Habitable') {
      tempList = tempList
          .where((planet) =>
              _planetViewModel.isHabitable(planet) ==
              'This planet is potentially habitable')
          .toList();
    } else if (filterOption == 'Not Habitable') {
      tempList = tempList
          .where((planet) =>
              _planetViewModel.isHabitable(planet) ==
              'This planet is likely not habitable')
          .toList();
    }

    setState(() {
      filteredPlanets = tempList;
    });
  }

  void _applyFilter(String option) {
    setState(() {
      filterOption = option;
      _filterPlanets(_planetNameController.text); // Reapply the filter
    });
  }

  // void _sortPlanets(bool ascending) {
  //   setState(() {
  //     filteredPlanets.sort((a, b) {
  //       // Get the last letter of each planet's name
  //       String lastA = a.name.isNotEmpty ? a.name[a.name.length - 1] : '';
  //       String lastB = b.name.isNotEmpty ? b.name[b.name.length - 1] : '';
  //
  //       int comparison = lastA.compareTo(lastB);
  //       return ascending
  //           ? comparison
  //           : -comparison; // Reverse comparison for Z-A
  //     });
  //   });
  // }

  String replaceSpaces(String input) {
    return input.replaceAll(' ', '-').toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff100f26),
            title: Text("Exoplanets"),),
          body: Stack(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage('assets/Background/Exoplanet.png'),
                            fit: BoxFit.cover,
                          ),
                      ),
                     ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              // _buildExoplanetsTab(),
              Column(
                children: [
                  const TabBar(
                    isScrollable: true,
                    labelColor: Colors.white, // Color for selected tab
                    unselectedLabelColor: Colors.white70, // Color for unselected tabs
                    indicatorColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors.transparent, // Transparent background for the indicator
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white, // White line under the selected tab
                          width: 2.0, // Width of the underline
                        ),
                      ),
                    ),
                    tabs: [
                      Tab(text: 'Planets'),
                      Tab(text: 'Exoplanets'),
                      Tab(text: 'NASA Image'),
                      // Add more tabs here as needed
                    ],
                  ),
                  Expanded( // Use Expanded to fill remaining space
                    child: TabBarView(
                      children: [
                        _buildPlanetsTab(), // Content for the 'Planets' tab
                        _buildExoplanetsTab(), // Content for the 'Exoplanets' tab
                        APODPage(), // Content for the 'NASA Image' tab
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExoplanetsTab() {
   return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _planetNameController,
                  onChanged: _filterPlanets,
                  decoration: InputDecoration(
                    labelText: 'Search Planet Name',
                    labelStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[850],
                    // Dark grey for the text field background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Round corners
                      borderSide: BorderSide.none, // Remove border outline
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.white
                              .withOpacity(0.3)), // Subtle border when enabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2), // Stronger border when focused
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20), // Padding inside the TextField
                  ),
                  style: const TextStyle(
                      color: Colors.white), // Text color inside the TextField
                ),
              ),
              PopupMenuButton<String>(
                onSelected: _applyFilter,
                itemBuilder: (BuildContext context) {
                  return {'All', 'Habitable', 'Not Habitable'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),

          const SizedBox(height: 16),
          if (!isLoading)
            Expanded(
              child: Scrollbar(
                // This allows you to customize the scrollbar appearance
                thumbVisibility: false, // Make the scrollbar always visible
                thickness: 3.0, // Set the thickness of the scrollbar
                radius: const Radius.circular(10), // Rounded corners
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true, // Make the GridView take only as much space as it needs
                    physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // Two items per row
                      childAspectRatio: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: filteredPlanets.length,
                    itemBuilder: (context, index) {
                      Planet planet = filteredPlanets[index];
                      String habitability = _planetViewModel.isHabitable(planet);

                      return GestureDetector(
                        onTap: () async {
                          print(planet.name);
                          String planetName = replaceSpaces(planet.name);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                url: 'https://science.nasa.gov/exoplanet-catalog/$planetName/', // Pass the URL here
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF091422), // Deep space-like background color
                                  Color(0xFF111B32),
                                ],
                              ),
                              // color: Colors.white12,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child:
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    // Planet Image
                                    // Container(
                                    //   width: 65,
                                    //   height: 65,
                                    //   decoration: const BoxDecoration(
                                    //     shape: BoxShape.circle,
                                    //     image: DecorationImage(
                                    //       image: AssetImage(''), // Make sure your Planet class has an image URL
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //     gradient: LinearGradient(
                                    //       colors: [
                                    //         Color(0xFF00E5E5),
                                    //         Color(0xFF72A4F1),
                                    //         Color(0xFFE860FF),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            planet.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.white, // High contrast text
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Radius: ${planet.radius} Earth radii.',
                                            style: TextStyle(color: Colors.white.withOpacity(0.8)),
                                          ),
                                          Text(
                                            'Star Temp: ${planet.starTemp} K.',
                                            style: TextStyle(color: Colors.white.withOpacity(0.8)),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            habitability,
                                            style: TextStyle(
                                              color: habitability == "This planet is potentially habitable"
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight, // Position "Details" in the bottom right corner
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0), // Adjust padding as necessary
                                        child: Text(
                                          "Details",
                                          style: TextStyle(
                                            color: Colors.blueAccent.withOpacity(0.9), // Color for the "Details" text
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )


                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          if (isLoading)
            Lottie.asset(
              'assets/Animations/loading space.json',
              repeat: true,
              reverse: false,
              animate: true,
              width: 200,
              height: 200,
            )
        ],
      ),
    );

  }
  Widget _buildPlanetsTab(){
    return Container();
  }
  Widget _buildNasaImageTab(){
    return Container();
  }
}
