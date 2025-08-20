import 'package:firebase_database/firebase_database.dart';
import 'generative_language_service.dart';
import 'dart:convert';
final dbRef = FirebaseDatabase.instance.ref();

Future<List<Map<String, String>>> fetchQuizzes() async {
  final snapshot = await dbRef.child("quizzes").once();
  final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

  if (data == null) return [];

  List<Map<String, String>> quizzes = [];
  data.forEach((key, value) {
    quizzes.add({
      'id': key.toString(),
      'title': value['title'] ?? '',
      'description': value['description'] ?? '',
    });
  });

  return quizzes;
}
