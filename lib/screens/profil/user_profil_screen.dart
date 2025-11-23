import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/backend/user.dart';
import 'package:flutter_e_french_app/screens/featured_screen.dart';
import 'package:flutter_e_french_app/screens/profil/update_user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({Key? key}) : super(key: key);

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  List<User> profiles = [];

  Future<void> getSpecificProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse("http://localhost:5000/api/auth/getOneProfil"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is List) {
          final String currentUserEmail = getEmailFromToken(token);

          final List<User> specificUserProfile = responseData
              .map((data) => User.fromJson(data))
              .where((profile) => profile.email == currentUserEmail)
              .toList();

          setState(() {
            profiles = specificUserProfile;
          });
        } else {
          throw Exception('Invalid data format received');
        }
      } else {
        debugPrint('Failed to fetch profile. Status: ${response.statusCode}');
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      debugPrint('Error in getSpecificProfile: $e');
    }
  }

  String getEmailFromToken(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['email'] ?? '';
    } catch (e) {
      throw Exception('Failed to decode token: $e');
    }
  }

  Future<void> deleteSingleProfile(String profileId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:5000/api/auth/deleteSingleProfile/$profileId'),
      );

      if (response.statusCode == 200) {
        await getSpecificProfile();
      } else {
        throw Exception('Failed to delete profile');
      }
    } catch (e) {
      debugPrint('Error in deleteSingleProfile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getSpecificProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Détail du profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeaturedScreen()),
          ),
        ),
      ),
      body: profiles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(children: [head()]),
    );
  }

  Widget head() {
    final User profile = profiles[0];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 60),
          profileRow(Icons.person_2_sharp, profile.name),
          profileDivider(),
          profileRow(Icons.phone, profile.phone.toString()),
          profileDivider(),
          profileRow(
              Icons.cast_for_education, "Classe: ${profile.classe} ère/ème"),
          profileDivider(),
          profileRow(Icons.view_agenda, "Age: ${profile.age} ans"),
          profileDivider(),
          profileRow(Icons.mail, "Email: ${profile.email}"),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              actionButton(
                'Supprimer',
                primaryColor,
                () => deleteSingleProfile(profile.userId),
              ),
              const SizedBox(width: 5),
              actionButton(
                'Mettre à jour',
                Colors.amber[200]!,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfile(user: profile),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget profileRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget profileDivider() {
    return const Divider(color: Colors.grey, thickness: 1, height: 20);
  }

  Widget actionButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
