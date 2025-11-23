import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/backend/course.dart';
import 'package:flutter_e_french_app/screens/courses/course_description.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_e_french_app/constants.dart';
import 'package:flutter_e_french_app/screens/courses/course_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrammarListScreen extends StatefulWidget {
  const GrammarListScreen({Key? key}) : super(key: key);

  @override
  State<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends State<GrammarListScreen> {
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

  final TextEditingController _searchController = TextEditingController();

  Future<void> _search(String keyword) async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/auth/searchCourse/$keyword'));
    final responseData = json.decode(response.body) as List<dynamic>;

    setState(() {
      courses = responseData.map((course) => Course.fromJson(course)).toList();
    });
  }

  List<dynamic> courses = [];

  NetworkImage getImage(String name) {
    String url = ("http://localhost:5000/$name");
    return NetworkImage(url);
  }

  Future<void> getAllCourses() async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/auth/getAllCourse'));
    final responseData = json.decode(response.body) as List<dynamic>;

    setState(() {
      courses = responseData
          .map((course) => Course.fromJson(course))
          .where((course) => course.type == 'grammaire')
          .toList();
    });
  }

  Future<void> toggleCompleteStatus(String courseId, bool isCompleted) async {
    final response = await http.patch(
      Uri.parse(
          'http://localhost:5000/api/auth/toggleCourseCompletion/$courseId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({'completed': !isCompleted}),
    );

    if (response.statusCode == 200) {
      setState(() {
        final course = courses.firstWhere((c) => c.courseId == courseId);
        course.completed = !course.completed;
      });
    } else {
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    getAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: const Text("Cours De Grammaire"),
        centerTitle: true,
        //to create an icon button inside AppBar
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CourseHomeScreen()),
              );
            }),
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
                        labelText: 'Recherchez cours de grammaire',
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
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    courses.length,
                    (index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseDescription(
                                      courseId: course.courseId,
                                      token: _token,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: getImage(course.image),
                                    fit: BoxFit.cover,
                                    opacity: 0.8,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => toggleCompleteStatus(
                                            course.courseId, course.completed),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: course.completed
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        child: Text(course.completed
                                            ? 'Complet'
                                            : 'Marquer Complet'),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.more_vert, size: 30),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
