// ignore_for_file: non_constant_identifier_names, avoid_print, file_names

import 'dart:convert';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class AuthentificationController extends GetxController {
  Future<http.Response> LogIn(String email, String password) async {
    final response = await http.post(
        Uri.parse("http://localhost:5000/api/auth/login"),
        body: {'email': email, 'password': password});
    if (response.statusCode == 200) {
      // Parse the response body and get the token as a string
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['token'];

      // Store the token in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      print(response.body);
    }

    return response;
  }
}
