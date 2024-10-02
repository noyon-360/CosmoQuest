import 'dart:convert';
import 'package:cosmoquest/Service/auth_service.dart';
import 'package:cosmoquest/Utils/apis.dart';
import 'package:http/http.dart' as http;

// Replace with your OpenAI API key
String apiKey = Apis.gptApi;

Future<String> generateQuizQuestions(String prompt) async {
  const String apiUrl = "https://api.openai.com/v1/completions";

  // Define headers and body for the request
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = jsonEncode({
    "model": "text-davinci-003", // OpenAI model
    "prompt": prompt,
    "max_tokens": 300, // Number of tokens (length of generated content)
    "n": 1, // Number of responses
    "stop": null, // Optional stop sequence
    "temperature": 0.7 // Controls randomness (0 = deterministic)
  });

  // Send POST request to OpenAI API
  final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

  // Check if the response is successful
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['text'].trim(); // Extract and return the generated text
  } else {
    throw Exception('Failed to generate quiz questions');
  }
}
