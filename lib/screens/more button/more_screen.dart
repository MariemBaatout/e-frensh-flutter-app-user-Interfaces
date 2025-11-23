// ignore_for_file: non_constant_identifier_names, avoid_print, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/constants.dart';
import 'package:flutter_e_french_app/screens/featured_screen.dart';
import 'package:flutter_e_french_app/screens/login_screen.dart';
import 'package:flutter_e_french_app/screens/more%20button/about_screen.dart';
import 'package:flutter_e_french_app/screens/more%20button/help_screen.dart';
import 'package:flutter_e_french_app/screens/more%20button/terms_screen.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Load the token from SharedPreferences
  void _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
  }

  // Remove the token from SharedPreferences and call the logout API
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    const url = 'http://localhost:5000/api/auth/logout';
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      await prefs.remove('token');
      setState(() {
        _token = null;
      });
    } else {
      print('error while logged out ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Autres options"),
        centerTitle: true,
        //to create an icon button inside AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FeaturedScreen(),
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.assignment_late_rounded),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: const Text('A propos'),
                  onTap: () {
                    _logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContextcontext) =>
                              const AboutScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.help_center),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: const Text('Centre d\'aide'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContextcontext) => HelpCenterScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.assured_workload),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: const Text('Termes et conditions'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContextcontext) =>
                              const TermsAndConditionsScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.logout_rounded),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: const Text('se déconnecter'),
                  onTap: () {
                    _logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContextcontext) =>
                              const LogInScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
