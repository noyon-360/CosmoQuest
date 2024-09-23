import 'dart:convert';

import 'package:cosmoquest/Model/ExoplanetModel/PlanetModel.dart';
import 'package:cosmoquest/ViewModel/ExoplanetModel/habitable_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PlanetView extends StatefulWidget {
  const PlanetView({super.key});

  @override
  State<PlanetView> createState() => _PlanetViewState();
}

class _PlanetViewState extends State<PlanetView> {
  final _planetNameController = TextEditingController();
  final PlanetViewModel _planetViewModel = PlanetViewModel();
  Planet? _planet;
  String _habitabilityMessage = '';
  String imageUrl = '';

  // late WebViewController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted);
  // }

  void _checkHabitability() async {
    Planet? planet = await _planetViewModel.fetchPlanetDetails(_planetNameController.text);
    if (planet != null) {
      setState(() {
        _planet = planet;
        _habitabilityMessage = _planetViewModel.isHabitable(planet);
      });
    } else {
      setState(() {
        _habitabilityMessage = 'Planet not found.';
      });
    }
  }

  String replaceSpaces(String input) {
    return input.replaceAll(' ', '-');
  }

  // void _showLink(String name) {
  //   name = replaceSpaces(name);
  //   _controller.loadRequest(Uri.parse('https://science.nasa.gov/exoplanet-catalog/$name/'));
  // }

  // Rest of your code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planet Habitability Checker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _planetNameController,
              decoration: const InputDecoration(labelText: 'Enter Planet Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _checkHabitability();
                // _showLink(_planetNameController.text.toString());
              },
              child: const Text('Check Habitability'),
            ),
            const SizedBox(height: 16),
            _planet != null
                ? Text(
                'Planet: ${_planet!.name}\nRadius: ${_planet!.radius} Earth radii\nStar Temp: ${_planet!.starTemp} K\n$_habitabilityMessage')
                : Text(_habitabilityMessage),

            // link viewer
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 500,
            //   child: WebViewWidget(controller: _controller),
            // ),
          ],
        ),
      ),
    );
  }
}
