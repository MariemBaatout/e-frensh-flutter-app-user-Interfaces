// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/backend/quiz.dart';
import 'package:flutter_e_french_app/screens/quiz%20game/quiz_home_screen.dart';
import 'package:flutter_e_french_app/screens/quiz%20game/primary_quiz_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_e_french_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EasyQuizListScreen extends StatefulWidget {
  const EasyQuizListScreen({Key? key}) : super(key: key);

  @override
  State<EasyQuizListScreen> createState() => _EasyQuizListScreenState();
}

class _EasyQuizListScreenState extends State<EasyQuizListScreen> {
  late String _token = '';
  List<dynamic> quizes = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _token = token ?? '';
    });

    getAllQuizes();
  }

  Future<void> _search(String keyword) async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/auth/searchQuiz/$keyword'));
    final responseData = json.decode(response.body) as List<dynamic>;
    setState(() {
      quizes = responseData.map((quiz) => Quiz.fromJson(quiz)).toList();
    });
  }

  // Fetch all quizzes and filter the ones with type 'easy'
  Future<void> getAllQuizes() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/auth/getAllQuiz'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List<dynamic>;
      final easyQuizzes =
          responseData.where((quiz) => quiz['type'] == 'easy').toList();

      setState(() {
        quizes = easyQuizzes.map((quiz) => Quiz.fromJson(quiz)).toList();
      });
    } else {
      // Handle error response
      print("Error fetching quizzes");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: const Text("Liste Des Quiz Facile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PrimaryQuizScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Recherchez selon le cours',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (String keyword) {
                        _search(keyword);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: quizes.length,
                itemBuilder: (context, index) {
                  final quiz = quizes[index];
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EasyQuizHomeScreen(
                              quizId: quiz.quizId,
                              token: _token,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
