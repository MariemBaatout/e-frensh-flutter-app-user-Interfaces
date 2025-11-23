// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/backend/quiz.dart';
import 'package:flutter_e_french_app/constants.dart';
import 'package:flutter_e_french_app/screens/quiz%20game/options_screen.dart';
import 'package:flutter_e_french_app/screens/quiz%20game/quiz_score_screen.dart';

import 'package:http/http.dart' as http;

class EasyQuizHomeScreen extends StatefulWidget {
  final String quizId;
  final String token;

  const EasyQuizHomeScreen({
    Key? key,
    required this.quizId,
    required this.token,
  }) : super(key: key);

  @override
  State<EasyQuizHomeScreen> createState() => _EasyQuizHomeScreenState();
}

class _EasyQuizHomeScreenState extends State<EasyQuizHomeScreen> {
  int currentQuestionIndex = 0;
  Quiz? currentQuiz;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  Option? selectedOption;
  bool hasSelectedOption = false;
  late Timer _timer;
  int _elapsedTime = 0;

  void _onOptionSelected(Option option) {
    if (hasSelectedOption) return;
    setState(() {
      selectedOption = option;
      hasSelectedOption = true; // Track the selected option
      if (option.isCorrect) {
        correctAnswers++;
      } else {
        incorrectAnswers++;
      }
    });
    _nextQuestion();
  }

  Future<Quiz> fetchQuiz(String quizId) async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/auth/getOneQuiz/$quizId'));
    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Quiz');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuiz(widget.quizId).then((value) {
      setState(() {
        currentQuiz = value;
      });
    }).catchError((error) {
      print('Error fetching quiz details: $error');
    });

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  void _nextQuestion() {
    if (!hasSelectedOption) return; // Ensure that user selects an option first

    setState(() {
      if (currentQuestionIndex < (currentQuiz?.questions.length ?? 1) - 1) {
        currentQuestionIndex++;
        selectedOption = null;
        hasSelectedOption = false;
      } else {
        _timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScoreScreen(
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
              totalQuestions: currentQuiz?.questions.length ?? 10,
              elapsedTime: _elapsedTime,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = currentQuiz?.questions ?? [];
    final currentQuestion =
        questions.isNotEmpty ? questions[currentQuestionIndex] : null;
    final options = currentQuestion?.options ?? [];
    final minutes = (_elapsedTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedTime % 60).toString().padLeft(2, '0');

    return Scaffold(
      body: currentQuiz == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(
                    height: 421,
                    width: 400,
                    child: Stack(
                      children: [
                        Container(
                          height: 240,
                          width: 390,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Positioned(
                          bottom: 60,
                          left: 22,
                          child: Container(
                            height: 170,
                            width: 350,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 5,
                                    spreadRadius: 3,
                                    color: primaryColor.withOpacity(.4),
                                  ),
                                ]),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$correctAnswers',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        '$incorrectAnswers',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      "question ${currentQuestionIndex + 1}/${questions.length}",
                                      style: const TextStyle(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    currentQuestion?.questionText ?? '',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 210,
                          left: 140,
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Text(
                                '$minutes:$seconds',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                  ...options
                      .map((option) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Options(
                              option: option.optionText,
                              isSelected: selectedOption == option,
                              isDisabled: hasSelectedOption,
                              onTap: () => _onOptionSelected(option),
                            ),
                          ))
                      .toList(),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      onPressed: _nextQuestion,
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
