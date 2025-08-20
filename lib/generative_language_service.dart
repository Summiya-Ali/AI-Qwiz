import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Your prompt function is still perfect! No changes needed here.
String createQuizPrompt({
  required String topic,
  required String complexity,
  required int numQuestions,
}) {
  return """
  Generate a multiple-choice quiz about the topic: "$topic".
  The complexity level should be: "$complexity".
  Generate exactly $numQuestions questions.

  IMPORTANT: Provide the output ONLY in a valid JSON array format. Do not include any text before or after the JSON array.
  Each object in the array should represent a single question and MUST have the following keys:
  - "question": A string containing the question text.
  - "options": An array of 4 strings representing the choices.
  - "answer": A string that exactly matches one of the values in the "options" array.

  EXAMPLE of the required format:
  [
    {
      "question": "What is the capital of France?",
      "options": ["London", "Berlin", "Paris", "Madrid"],
      "answer": "Paris"
    }
  ]
  """;
}

// =========================================================================
//  NEW AND IMPROVED SERVICE USING GOOGLE GEMINI API
// =========================================================================
class GenerativeLanguageService {
  // We use the Gemini 1.5 Flash model - it's fast and powerful
  static const String _model = "gemini-1.5-flash-latest";

  static bool _isInitialized = false;
  static String? _apiKey;

  // Init now just loads the key into memory.
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
    _apiKey = dotenv.env['GEMINI_API_KEY'];
    if (_apiKey == null) {
      throw Exception("GEMINI_API_KEY not found in .env file");
    }
    _isInitialized = true;
    print("Gemini Service Initialized Successfully.");
  }

  static Future<List<Map<String, dynamic>>> generateQuiz(String prompt) async {
    if (!_isInitialized || _apiKey == null) {
      throw Exception("Gemini Service not initialized. Call init() first.");
    }

    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey");

    final headers = {'Content-Type': 'application/json'};

    // The body structure for Gemini is slightly different
    final body = jsonEncode({
      "contents": [
        {"parts": [{"text": prompt}]}
      ],
      // We explicitly ask for a JSON response
      "generationConfig": {
        "response_mime_type": "application/json",
      }
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Gemini makes it easier to get the text, and it's already parsed as JSON
        final String generatedText = responseData['candidates'][0]['content']['parts'][0]['text'];

        // The text itself is a JSON string, so we decode it.
        final List<dynamic> quizList = jsonDecode(generatedText);
        return quizList.cast<Map<String, dynamic>>();

      } else {
        // Provide detailed error info from the server
        print("--- GEMINI API ERROR ---");
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        print("------------------------");
        throw Exception('API Error: ${response.statusCode}. Check debug console for details.');
      }
    } catch (e) {
      throw Exception('Failed to generate quiz. Error: $e');
    }
  }
}