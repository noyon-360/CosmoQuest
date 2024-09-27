import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CMEData extends StatefulWidget {
  const CMEData({super.key});

  @override
  _CMEDataState createState() => _CMEDataState();
}

class _CMEDataState extends State<CMEData> {
  List<dynamic> _cmeData = [];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Function to fetch CME data
  Future<void> fetchCMEData(String startDate, String endDate) async {
    final String apiKey = 'DEMO_KEY'; // Replace with your actual NASA API key
    final String url =
        'https://api.nasa.gov/DONKI/CME?startDate=$startDate&endDate=$endDate&api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _cmeData = data;
      });
    } else {
      throw Exception('Failed to load CME data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CME Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input for start date
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                labelText: 'Start Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Input for end date
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(
                labelText: 'End Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Button to fetch data
            ElevatedButton(
              onPressed: () {
                String startDate = _startDateController.text;
                String endDate = _endDateController.text;
                fetchCMEData(startDate, endDate);
              },
              child: Text('Fetch CME Data'),
            ),

            // Displaying the fetched data
            Expanded(
              child: _cmeData.isNotEmpty
                  ? ListView.builder(
                itemCount: _cmeData.length,
                itemBuilder: (context, index) {
                  final cme = _cmeData[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('CME ID: ${cme['activityID']}'),
                      subtitle: Text('Start Time: ${cme['startTime']}'),
                      trailing: Text('CME Score: ${cme['cmeAnalyses'] != null && cme['cmeAnalyses'].isNotEmpty ? cme['cmeAnalyses'][0]['speed'].toString() : 'Unknown'} km/s'),
                    ),
                  );
                },
              )
                  : Center(
                child: Text('No data available'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
