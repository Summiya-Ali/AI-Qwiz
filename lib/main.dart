import 'package:flutter/material.dart';
import 'MyHomePage.dart'; // Import your MyHomePage
import 'quiz_home.dart'; // Import your QuizHomeScreen
import 'quiz_details_screen.dart'; // Import your QuizDetailsScreen
import 'score_display.dart'; // Import your ScoreDisplayScreen

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        '/': (context) => MyHomePage(), // Route for MyHomePage
        '/quizHome': (context) => QuizHomeScreen(), // Route for QuizHomeScreen
        '/quizDetails': (context) => const QuizDetailsScreen( // Basic instance
          quizId: '',
          quizTitle: '',
        ),
        '/score': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ScoreDisplayScreen(
            score: args['score'],
            total: args['total'],
            quizTitle: args['quizTitle'],
          );
        },
      },
    );
  }
}