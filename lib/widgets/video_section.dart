import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../backend/course.dart';

class VideoSection extends StatefulWidget {
  final String courseId;
  final String token;

  const VideoSection({
    Key? key,
    required this.courseId,
    required this.token,
  }) : super(key: key);

  @override
  _VideoSectionState createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late FlickManager flickManager;
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
        // Initialize FlickManager with the fetched video URL
        flickManager = FlickManager(
          // ignore: deprecated_member_use
          videoPlayerController: VideoPlayerController.network(
            course!.videoLink,
          ),
        );
      });
    }).catchError((error) {
      print('Error fetching course details: $error');
    });
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while fetching data
    if (course == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      child: FlickVideoPlayer(flickManager: flickManager),
    );
  }
}
