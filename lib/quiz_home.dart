import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_details_screen.dart';

class QuizHomeScreen extends StatefulWidget {
  @override
  _QuizHomeScreenState createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
  final List<Map<String, String>> _allQuizzes = [
    {
      'id': '1',
      'title': 'General Knowledge',
      'description': 'Test your general knowledge with a fun quiz!',
    },
    {
      'id': '2',
      'title': 'Science Quiz',
      'description': 'How well do you know the world of science?',
    },
    {
      'id': '3',
      'title': 'History Quiz',
      'description': 'Dive into the past and test your knowledge of history.',
    },
    {
      'id': '4',
      'title': 'Mathematics Quiz',
      'description': 'Challenge your math skills with tricky questions.',
    },
    {
      'id': '5',
      'title': 'Geography Quiz',
      'description': 'Explore the world and its geography through this quiz.',
    },
    // Add more quizzes here in the future
  ];

  List<Map<String, String>> _filteredQuizzes = [];
  TextEditingController _searchController = TextEditingController();
  final IconData _defaultIcon = Icons
      .quiz_outlined; // Define a single default icon

  @override
  void initState() {
    super.initState();
    _filteredQuizzes.addAll(_allQuizzes); // Initially show all quizzes
  }

  void _filterQuizzes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredQuizzes.clear();
        _filteredQuizzes.addAll(_allQuizzes);
      } else {
        _filteredQuizzes = _allQuizzes
            .where((quiz) =>
        quiz['title']!.toLowerCase().contains(query.toLowerCase()) ||
            quiz['description']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Custom top text header
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                "Let's play!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterQuizzes,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search quizzes...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      _filterQuizzes(''); // Clear the filter
                    },
                  ),
                  filled: true,
                  fillColor: Colors.deepPurpleAccent.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Main content: ListView of quizzes
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _filteredQuizzes.length,
                itemBuilder: (context, index) {
                  return _buildQuizItem(_filteredQuizzes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build each quiz item with gradient color, shadow, and rounded icon
  // Build each quiz item with gradient color, shadow, and rounded icon
  Widget _buildQuizItem(Map<String, String> quiz) {
    return GestureDetector(
      onTap: () {
        // Navigate to QuizDetailsScreen using the named route
        Navigator.pushNamed(
          context,
          '/quizDetails',
          arguments: {
            'quizId': quiz['id'],
            'quizTitle': quiz['title'],
          },
        );
      },
      child: Container( // This is the child of the GestureDetector
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 8,
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Optional background color for the circle
            ),
            child: Center(
              child: Icon(
                _defaultIcon, // Use the single default icon
                color: Colors.deepPurpleAccent,
                size: 28,
              ),
            ),
          ),
          title: Text(
            quiz['title']!,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            quiz['description']!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}