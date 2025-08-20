import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final dbRef = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  Map<String, List<Map<String, dynamic>>> groupedResults = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _loadUserAnalytics(user!.uid);
    }
  }

  Future<void> _loadUserAnalytics(String uid) async {
    try {
      final snapshot = await dbRef.child('quiz_results').child(uid).once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        Map<String, List<Map<String, dynamic>>> tempMap = {};
        for (var entry in data.entries) {
          final quizData = entry.value as Map<dynamic, dynamic>;
          final title = quizData['quizTitle'] ?? 'Unknown';
          final result = {
            'score': quizData['score'] ?? 0,
            'total': quizData['total'] ?? 0,
            'timestamp': quizData['timestamp'] ?? '',
          };

          tempMap.putIfAbsent(title, () => []);
          tempMap[title]!.add(result);
        }

        setState(() {
          groupedResults = tempMap;
        });
      }
    } catch (e) {
      print("Error loading analytics: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  double _calculateAverage(List<Map<String, dynamic>> results) {
    if (results.isEmpty) return 0;
    final totalScore =
    results.fold(0, (sum, res) => sum + (res['score'] as int));
    final totalPossible =
    results.fold(0, (sum, res) => sum + (res['total'] as int));
    return totalPossible == 0 ? 0 : (totalScore / totalPossible) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Quiz Analytics'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFD1C4E9),
              Color(0xFFB39DDB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple))
            : groupedResults.isEmpty
            ? Center(
          child: Text(
            "No quiz results found.",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.deepPurple.shade700,
            ),
          ),
        )
            : ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(height: 10),
            ...groupedResults.entries.map((entry) {
              final subject = entry.key;
              final results = entry.value;
              final avgScore = _calculateAverage(results);

              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 20,
                        child: Stack(
                          children: [
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10),
                                color: Colors.deepPurple.shade100,
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: avgScore / 100,
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Average Score: ${avgScore.toStringAsFixed(1)}%",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      const Divider(height: 20),
                      ...results.map((res) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Score: ${res['score']} / ${res['total']}",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                res['timestamp'] != null
                                    ? res['timestamp']
                                    .toString()
                                    .split('T')
                                    .first
                                    : "",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
