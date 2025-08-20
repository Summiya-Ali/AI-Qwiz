import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'score_display.dart';
import 'login.dart';
import 'register.dart';
// --- NEW ---
// Import the generative language service to initialize it
import 'generative_language_service.dart';

// Your existing imports (make sure paths are correct)
import 'MyHomePage.dart';
import 'quiz_home.dart';
// Note: QuizDetailsScreen and ScoreDisplay are used in routes, not directly imported here.

void main() async {
  // --- MODIFIED: Wrapped in a try-catch block for robust error handling ---
  try {
    // Ensure Flutter engine is ready
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase first (as it was in your original code)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          // WARNING: See security note below about these hardcoded keys
          apiKey: 'AIzaSyA6HiW1FvLH3goPnNs9cuYoIBkIgwG3ei0',
          authDomain: 'my-flutter-b89b1.firebaseapp.com',
          projectId: 'my-flutter-b89b1',
          storageBucket: 'my-flutter-b89b1.appspot.com',
          messagingSenderId: '156853416274',
          appId: '1:156853416274:web:747b21e7d9d8e860780a8b',
          databaseURL: 'https://my-flutter-b89b1-default-rtdb.firebaseio.com',
        ),
      );
      print("Firebase initialized successfully.");
    }

    // --- NEW ---
    // Initialize our AI service to load the .env file with the API key.
    // This fixes the 'NotInitializedError'.
    await GenerativeLanguageService.init();
    print("Generative Language Service initialized successfully.");

    // If all initializations succeed, run the app
    runApp(const QuizApp());

  } catch (e) {
    // If any initialization fails, print the error and show a basic error screen.
    print("!!!!!!!!!! FAILED TO INITIALIZE APP !!!!!!!!!!");
    print(e);
    runApp(ErrorApp(error: e.toString()));
  }
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your routing logic remains exactly the same.
    return MaterialApp(
      title: 'Quiz Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterPage(),// 👈 Add this
          '/quizHome': (context) => QuizHomeScreen(),
          '/score': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ScoreDisplayScreen(
              score: args['score'],
              total: args['total'],
              quizTitle: args['quizTitle'],
              questions: args['qestions'],
              selectedAnswers: args['selectedAnswers'],
            );
          },
        }

    );
  }
}

// --- NEW (Optional but recommended) ---
// A simple widget to display if the app fails to start.
class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Application failed to start. Please restart.\n\nError: $error",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}