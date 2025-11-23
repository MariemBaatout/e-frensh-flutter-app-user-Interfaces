import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_e_french_app/screens/quiz%20game/primary_quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScoreScreen extends StatefulWidget {
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalQuestions;
  final int elapsedTime;

  const QuizScoreScreen({
    Key? key,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.totalQuestions,
    required this.elapsedTime,
  }) : super(key: key);

  @override
  State<QuizScoreScreen> createState() => _QuizScoreScreenState();
}

class _QuizScoreScreenState extends State<QuizScoreScreen> {
  late String _token = '';

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _token = token ?? '';
    });
  }

  Future<void> submitQuizScore({
    required int correctAnswers,
    required int incorrectAnswers,
    required String score,
    required int elapsedTime,
  }) async {
    final url = Uri.parse('http://localhost:5000/api/auth/AddScore');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'correctAnswer': correctAnswers.toString(),
        'incorrectAnswer': incorrectAnswers.toString(),
        'score': score,
        'responseTime': elapsedTime.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print('Score submitted successfully');
    } else {
      print('Failed to submit score: ${response.body}');
    }
  }

  Future<void> getAllScores() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/auth/getAllScore'));
    final responseData = json.decode(response.body) as List<dynamic>;

    setState(() {
      scores = responseData;
    });
  }

  List<dynamic> scores = [];

  @override
  void initState() {
    super.initState();
    getToken().then((_) {
      getAllScores();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        submitQuizScore(
          correctAnswers: widget.correctAnswers,
          incorrectAnswers: widget.incorrectAnswers,
          score: (widget.correctAnswers / widget.totalQuestions * 100)
              .toStringAsFixed(0),
          elapsedTime: widget.elapsedTime,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final score = (widget.correctAnswers / widget.totalQuestions * 100)
        .toStringAsFixed(0);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 521,
            width: 400,
            child: Stack(
              children: [
                Container(
                  height: 340,
                  width: 410,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: CircleAvatar(
                        radius: 85,
                        backgroundColor: Colors.white.withOpacity(.3),
                        child: CircleAvatar(
                          radius: 71,
                          backgroundColor: Colors.white.withOpacity(.4),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Votre Score",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: primaryColor,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: score,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' %',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Temps de réponse",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '${widget.elapsedTime} seconde',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 22,
                  child: Container(
                    height: 190,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 3,
                          color: primaryColor.withOpacity(.7),
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: primaryColor,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${(widget.correctAnswers / widget.totalQuestions * 100).toStringAsFixed(0)}%',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Text('Complète'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: primaryColor,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${widget.totalQuestions}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Text('Questions Totales')
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: primaryColor,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${widget.correctAnswers}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Text('Correctes'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 70.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 15,
                                              width: 15,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryColor,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${widget.incorrectAnswers}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Text('Faux'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (score != '100')
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PrimaryQuizScreen(),
                                ));
                          },
                          child: const CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 35,
                            child: Center(
                              child: Icon(
                                Icons.refresh,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Rejouer',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  const SizedBox(width: 50),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrimaryQuizScreen(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 35,
                          child: Center(
                            child: Icon(
                              Icons.home,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Accueil',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
