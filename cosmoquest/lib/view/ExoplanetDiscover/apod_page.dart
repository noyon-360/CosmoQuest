import 'package:cosmoquest/Model/ExoplanetModel/APODDataModel.dart';
import 'package:cosmoquest/ViewModel/ExoplanetModel/apod_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class APODPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   title: Text('NASA APOD Viewer'),
      // ),
      body: ChangeNotifierProvider(
        create: (_) => APODViewModel()..fetchAPODData(),
        child: Consumer<APODViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            } else if (viewModel.apodList.isEmpty) {
              return Center(child: Text('No data available'));
            }

            List<APODData> apodList = viewModel.apodList;

            // Calculate which set of 5 to show for today
            List<APODData> displayedList = _getTodayAPODs(apodList);

            return ListView.builder(
              itemCount: displayedList.length,
              itemBuilder: (context, index) {
                var apod = displayedList[index];
                return _buildAPODCard(apod, context);
              },
            );
          },
        ),
      ),
    );
  }

  // Method to get the 5 APOD items for the current day
  List<APODData> _getTodayAPODs(List<APODData> apodList) {
    if (apodList.isEmpty) return [];

    // Get the current day of the year (1-365 or 366)
    int dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;

    // Use the dayOfYear to get a starting index for today
    int startIndex = dayOfYear % apodList.length; // Ensure it wraps around

    // Get 5 items starting from the startIndex, wrapping around if necessary
    List<APODData> todayAPODs = [];
    for (int i = 0; i < 5; i++) {
      int currentIndex = (startIndex + i) % apodList.length;
      todayAPODs.add(apodList[currentIndex]);
    }

    return todayAPODs;
  }

  // Build method for APOD card
  Widget _buildAPODCard(APODData apod, BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ExpansionTile(
        title: Text(apod.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('Date: ${apod.date}', style: TextStyle(fontSize: 14)),
        leading: Image.network(
          apod.url,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              apod.explanation,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Copyright: ${apod.copyright ?? 'N/A'}',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
