import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/backend/user.dart';
import 'package:flutter_e_french_app/screens/profil/user_profil_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class UpdateProfile extends StatefulWidget {
  final User user;
  const UpdateProfile({Key? key, required this.user}) : super(key: key);
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController classeController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  List<dynamic> profiles = [];

  // ignore: non_constant_identifier_names
  Future<void> UpdateProfile(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> map = {
      "name": nameController.text.toString().trim(),
      "age": ageController.text.toString().trim(),
      "classe": classeController.text.toString().trim(),
      "phone": phoneController.text.toString().trim(),
    };

    var body = json.encode(map);
    var encoding = Encoding.getByName('utf-8');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // ignore: unused_local_variable
    final response = await http
        .put(
            Uri.parse(
                'http://localhost:5000/api/auth/UpdateUserProfile/$userId'),
            headers: headers,
            body: body,
            encoding: encoding)
        .then((value) {
      getAllProfiles();
    });
  }

  Future<void> getAllProfiles() async {
    final response = await http
        .get(Uri.parse('http://localhost:5000/api/auth/getOneProfil'));
    final responseData = json.decode(response.body) as List<dynamic>;

    setState(() {
      profiles = responseData;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllProfiles();

    nameController.text = widget.user.name;
    ageController.text = widget.user.age.toString();
    classeController.text = widget.user.classe.toString();
    phoneController.text = widget.user.phone.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("mettre à jour le profil"),
        centerTitle: true,
        //to create an icon button inside AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MainProfile(),
              )),
        ),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            nameTextField(),
            const SizedBox(height: 20),
            ageTextField(),
            const SizedBox(height: 20),
            classeTextField(),
            const SizedBox(height: 20),
            phoneTextField(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                UpdateProfile(widget.user.userId);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainProfile(),
                    ));
              },
              child: const Text("Soumettre"),
            ),
          ],
        ),
      ),
    );
  }

  Widget nameTextField() {
    return TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Nom et Prénom",
        hintText: " Mariem Baatout",
      ),
    );
  }

  Widget phoneTextField() {
    return TextFormField(
      controller: phoneController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.phone,
          color: Colors.green,
        ),
        labelText: "Téléphone",
        hintText: "12345678",
      ),
      //for validate our text field we use a package
      validator: validatePhoneNumber,
    );
  }

  Widget ageTextField() {
    return TextFormField(
      controller: ageController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Age",
        hintText: "12",
      ),
    );
  }

  Widget classeTextField() {
    return TextFormField(
      controller: classeController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Classe",
        hintText: "6",
      ),
    );
  }
}
