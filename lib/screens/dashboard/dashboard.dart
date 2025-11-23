// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_e_french_app/backend/score.dart';
import 'package:flutter_e_french_app/screens/feedback_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/backend/course.dart';
import 'package:flutter_e_french_app/screens/courses/course_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ElearningDashboard());

class ElearningDashboard extends StatelessWidget {
  const ElearningDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String _token;
  // method to get the token from shared preferences
  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _token = token ??
          ''; // set the token variable to the retrieved value, or an empty string if null
    });
  }

  List<dynamic> courses = [];
  List<dynamic> scores = [];
  int completedCoursesCount = 0;

  Future<void> getAllCourses() async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/auth/getAllCourse'));
    final responseData = json.decode(response.body) as List<dynamic>;

    setState(() {
      courses = responseData.map((course) => Course.fromJson(course)).toList();
      completedCoursesCount =
          courses.where((course) => course.completed).length;
    });
  }

  Future<void> getAllScores() async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/auth/getAllScore'), headers: {
      'Authorization': 'Bearer $_token', // Include token in headers
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List<dynamic>;

      setState(() {
        scores = responseData.map((score) => Score.fromJson(score)).toList();
      });
    } else {
      print('Failed to load scores');
    }
  }

  @override
  void initState() {
    super.initState();
    getToken().then((_) {
      getAllCourses();
      getAllScores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord d\'apprentissage en ligne'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildStatCard(
                      context,
                      'Cours Statistiques',
                      '$completedCoursesCount Cours Complets',
                      Colors.orange,
                      null),
                  _buildStatCard(
                    context,
                    'Feedback',
                    '200 Commentaires',
                    Colors.pink,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedbackScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildStatCard(
                    context,
                    'Accès rapide aux ressources',
                    '${courses.length} Documents',
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CourseHomeScreen()),
                      );
                    },
                  ),
                  // Assuming `scores` is a list and `responseTime` is a field in each score
                  _buildStatCard(
                      context,
                      'Temps de réponse',
                      scores.isNotEmpty
                          ? '${scores.first.responseTime} sec'
                          : 'N/A',
                      Colors.purple,
                      null),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildStatCard(
                      context,
                      'Réponses Correctes',
                      scores.isNotEmpty
                          ? '${scores.first.correctAnswer}'
                          : 'N/A',
                      Colors.lightBlue,
                      null),
                  _buildStatCard(
                      context,
                      'Réponses Incorrectes',
                      scores.isNotEmpty
                          ? '${scores.first.incorrectAnswer}'
                          : 'N/A',
                      Colors.red,
                      null),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildStatCard(
                      context,
                      'Score',
                      scores.isNotEmpty ? '${scores.first.score} %' : '0%',
                      Colors.yellow,
                      null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      Color color, VoidCallback? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
