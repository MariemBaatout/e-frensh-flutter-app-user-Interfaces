import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController feedbackController = TextEditingController();

  List<dynamic> avis = [];

  // ignore: non_constant_identifier_names
  Future<void> AddAvis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> map = {
      "avis": feedbackController.text.toString().trim(),
    };

    var body = json.encode(map);
    var encoding = Encoding.getByName('utf-8');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    var response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/AddFeedback'),
        headers: headers,
        body: body,
        encoding: encoding);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      getAllFeedbacks();
      var avisId = responseData['avisId'];
      return avisId;
    } else {
      throw Exception('Failed to add feedback');
    }
  }

  Future<void> getAllFeedbacks() async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/auth/getAllFeedbacks'));
    final responseData = json.decode(response.body) as List<dynamic>;

    setState(() {
      avis = responseData;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avis"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                labelText: "Donnez votre avis",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                var avisId = await AddAvis();
              },
              child: const Text("Submit"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
