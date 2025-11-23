import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../backend/course.dart';

class PlaylistSection extends StatefulWidget {
  final String courseId;
  const PlaylistSection(
      {Key? key, required this.courseId, required String token})
      : super(key: key);

  @override
  _PlaylistSectionState createState() => _PlaylistSectionState();
}

class _PlaylistSectionState extends State<PlaylistSection> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Course? course;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    fetchCourse(widget.courseId).then((value) {
      setState(() {
        course = value;
        setAudio(course!.playlistLink);
      });
    }).catchError((error) {
      print('Error fetching course details: $error');
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future<void> setAudio(String url) async {
    try {
      audioPlayer.setReleaseMode(ReleaseMode.loop);

      if (url.isNotEmpty &&
          (url.endsWith('.mp3') ||
              url.endsWith('.wav') ||
              url.endsWith('.aac'))) {
        print('Setting audio source to: $url');
        await audioPlayer.setSourceUrl(url);
        print('Audio source set successfully.');
      } else {
        throw 'Invalid URL format: Not a direct audio link.';
      }
    } catch (e) {
      print('Error setting audio source: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading audio: $e')),
      );
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

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
  Widget build(BuildContext context) {
    final double maxSliderValue = duration.inSeconds.toDouble();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(
              min: 0,
              max: maxSliderValue > 0 ? maxSliderValue : 1,
              value: position.inSeconds.toDouble().clamp(0, maxSliderValue),
              onChanged: maxSliderValue > 0
                  ? (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      await audioPlayer.resume();
                    }
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration - position)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                iconSize: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
