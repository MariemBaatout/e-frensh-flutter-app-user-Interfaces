// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../backend/course.dart';
import '../../constants.dart';
import '../../widgets/description_section.dart';
import '../../widgets/playlist_section.dart';
import '../../widgets/video_section.dart';

class CourseDescription extends StatefulWidget {
  final String courseId;
  final String token;

  const CourseDescription({
    Key? key,
    required this.courseId,
    required this.token,
  }) : super(key: key);

  @override
  State<CourseDescription> createState() => _CourseDescriptionState();
}

class _CourseDescriptionState extends State<CourseDescription> {
  bool isPlaylist = true;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: course == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                course!.videoLink.isNotEmpty
                    ? VideoSection(
                        courseId: widget.courseId,
                        token: widget.token,
                      )
                    : const Center(child: Text('No video available')),
                const SizedBox(height: 15),
                Text(
                  course!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: isPlaylist
                            ? primaryColor
                            : primaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isPlaylist = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 35),
                            child: const Text(
                              'Playlists',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: isPlaylist
                            ? primaryColor.withOpacity(0.6)
                            : primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isPlaylist = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 35),
                            child: const Text(
                              'Description',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: isPlaylist
                      ? PlaylistSection(
                          courseId: widget.courseId,
                          token: widget.token,
                        )
                      : DescriptionSection(
                          courseId: widget.courseId,
                          token: widget.token,
                        ),
                ),
              ],
            ),
    );
  }
}
