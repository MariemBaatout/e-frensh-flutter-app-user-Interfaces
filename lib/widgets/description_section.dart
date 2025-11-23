// ignore_for_file: avoid_print, sized_box_for_whitespace, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import '../backend/course.dart';
import 'package:http/http.dart' as http;

class DescriptionSection extends StatefulWidget {
  final String courseId;
  const DescriptionSection(
      {Key? key, required this.courseId, required String token})
      : super(key: key);

  @override
  _DescriptionSectionState createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  Course? course;

  Future<Course> fetchCourse(String courseId) async {
    final response = await http.get(
        Uri.parse('http://localhost:5000/api/auth/getOneCourse/$courseId'));
    if (response.statusCode == 200) {
      return Course.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Course');
    }
  }

  NetworkImage getImage(String name) {
    String url = "http://localhost:5000/$name";
    return NetworkImage(url);
  }

  @override
  void initState() {
    super.initState();
    fetchCourse(widget.courseId).then((value) {
      setState(() {
        course = value;
      });
    }).catchError((error) {
      print('Error fetching course details: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: course == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Display course image
                    Image(
                      image: getImage(course!.image),
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Display course name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    course!.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Display course description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    course!.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Scrollable Image List
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: course!.image.length, // Number of images
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image(
                          image: getImage(course!.image[index]),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
