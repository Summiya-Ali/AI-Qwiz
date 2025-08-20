import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'generative_language_service.dart';
import 'firebase_service.dart';
import 'quiz_details_screen.dart';
import 'analytics.dart';

class QuizHomeScreen extends StatefulWidget {
  @override
  _QuizHomeScreenState createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
  final Map<String, String> _quizImageMap = {
    'science': 'science.jpg',
    'history': 'history.jpg',
    'general knowledge': 'gkNew.jpg',
    'geography': 'geogNew.jpg',
    'mathematics': 'maths.jpg',
    'english': 'front.jpg',
  };

  List<Map<String, String>> _allQuizzes = [];
  List<Map<String, String>> _filteredQuizzes = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchQuizzesFromDb();
  }

  Future<void> _fetchQuizzesFromDb() async {
    final fetchedQuizzes = await fetchQuizzes();
    setState(() {
      _allQuizzes = fetchedQuizzes;
      _filteredQuizzes = List.from(_allQuizzes);
    });
  }

  void _filterQuizzes(String query) {
    setState(() {
      _filteredQuizzes = query.isEmpty
          ? List.from(_allQuizzes)
          : _allQuizzes.where((quiz) {
        return quiz['title']!
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            quiz['description']!
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _handleQuizSelection(Map<String, String> quiz) async {
    final options = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _QuizOptionsDialog(),
    );

    if (options == null) return;

    setState(() => _isLoading = true);

    try {
      final String prompt = createQuizPrompt(
        topic: quiz['title']!,
        complexity: options['complexity']!,
        numQuestions: 5,
      );

      final List<Map<String, dynamic>> aiQuestions =
      await GenerativeLanguageService.generateQuiz(prompt);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizDetailsScreen(
              quizTitle: quiz['title']!,
              questions: aiQuestions,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate quiz: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFF0D1B2A),
                  Color(0xFF1B263B),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.7, 1.0],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 60),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.5),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [Colors.white, Colors.deepPurpleAccent.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      "Let's Play!",
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.deepPurple.withOpacity(0.5),
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterQuizzes,
                    style: TextStyle(color: Colors.deepPurple.shade900),
                    decoration: InputDecoration(
                      hintText: 'Search quizzes...',
                      hintStyle: TextStyle(color: Colors.deepPurple.shade300),
                      prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.deepPurple),
                        onPressed: () {
                          _searchController.clear();
                          _filterQuizzes('');
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.deepPurple.shade200,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.deepPurple.shade200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _filteredQuizzes.isEmpty
                      ? Center(
                    child: Text(
                      "No quizzes found.",
                      style: GoogleFonts.poppins(
                        color: Colors.deepPurple.shade300,
                        fontSize: 18,
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredQuizzes.length,
                    itemBuilder: (context, index) {
                      return _buildQuizItem(_filteredQuizzes[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade100,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "View Analytics",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                        );
                      },
                    ),
                  ),
                ),


              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Generating your quiz...',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],

      ),

    );
  }

  Widget _buildQuizItem(Map<String, String> quiz) {
    final titleKey = quiz['title']?.toLowerCase().trim() ?? 'science';
    final imageFileName = _quizImageMap[titleKey] ?? 'science.jpg';
    final imageAsset = 'assets/images/$imageFileName';

    return InkWell(
      onTap: _isLoading ? null : () => _handleQuizSelection(quiz),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/science.jpg',
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz['title'] ?? "No Title",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (quiz['description'] != null)
                      Text(
                        quiz['description']!,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizOptionsDialog extends StatefulWidget {
  @override
  __QuizOptionsDialogState createState() => __QuizOptionsDialogState();
}

class __QuizOptionsDialogState extends State<_QuizOptionsDialog> {
  String _selectedComplexity = 'Easy';
  final List<String> _complexities = [
    'Easy',
    'Medium',
    'Hard',
    'Very Hard for an expert'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Quiz Complexity'),
      content: DropdownButton<String>(
        value: _selectedComplexity,
        isExpanded: true,
        items: _complexities
            .map((complexity) =>
            DropdownMenuItem(value: complexity, child: Text(complexity)))
            .toList(),
        onChanged: (val) => setState(() => _selectedComplexity = val!),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context, null),
        ),
        ElevatedButton(
          child: Text('Generate Quiz'),
          onPressed: () =>
              Navigator.pop(context, {'complexity': _selectedComplexity}),
        ),
      ],
    );



  }
}
