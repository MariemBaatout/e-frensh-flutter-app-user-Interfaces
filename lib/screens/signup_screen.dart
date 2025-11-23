// ignore_for_file: unused_field

import 'dart:convert';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/constants.dart';
import 'package:flutter_e_french_app/screens/login_screen.dart';
import 'package:flutter_e_french_app/widgets/custom_scaffold.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool agreePersonalData = true;

  final _formKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  late String _userName, _email, _password, _phoneNumber, _age, _classe;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController classeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();

  List<dynamic> users = [];

  // function to insert user data in db

  // ignore: non_constant_identifier_names
  Future<void> SignUp() async {
    Map<String, dynamic> map = {
      "name": nameController.text.toString().trim(),
      "email": emailController.text.toString().trim(),
      "phone": phoneController.text.toString().trim(),
      "age": ageController.text.toString().trim(),
      "classe": classeController.text.toString().trim(),
      "password": passwordController.text.toString().trim(),
    };

    var body = json.encode(map);
    var encoding = Encoding.getByName('utf-8');
    const headers = {"Content-Type": "application/json"};

    await http
        .post(Uri.parse('http://localhost:5000/api/auth/signup'),
            headers: headers, body: body, encoding: encoding)
        .then((value) {
      getAllUsersData();
    });
  }

  Future<void> getAllUsersData() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/auth/getUser'));
    final responseData = json.decode(response.body) as List<dynamic>;

    setState(() {
      users = responseData;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      const Text(
                        'Merci de créer votre profil',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          label: const Text('Nom Complet'),
                          hintText: 'Entrer votre nom et prénom',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: RequiredValidator(
                            errorText: 'Username is required'),
                        onSaved: (username) => _userName = username!,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      //phone
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: RequiredValidator(
                            errorText: 'Phone number is required'),
                        onSaved: (phoneNumber) => _phoneNumber = phoneNumber!,
                        decoration: InputDecoration(
                          label: const Text('Téléphone'),
                          hintText: 'Entrer Votre Numéro de Téléphone',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      //age
                      TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.phone,
                        validator:
                            RequiredValidator(errorText: 'Age is required'),
                        onSaved: (age) => _age = age!,
                        decoration: InputDecoration(
                          label: const Text('Age'),
                          hintText: 'Entrer Votre Age',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      //classe
                      TextFormField(
                        controller: classeController,
                        keyboardType: TextInputType.phone,
                        validator:
                            RequiredValidator(errorText: 'Class is required'),
                        onSaved: (classe) => _classe = classe!,
                        decoration: InputDecoration(
                          label: const Text('Classe'),
                          hintText: 'Entrer Votre Classe',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: const Text('E-mail'),
                          hintText: 'Entrer E-mail',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator:
                            EmailValidator(errorText: 'Use a valid email ! '),
                        onSaved: (email) => _email = email!,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // password
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: '*',
                        controller: passwordController,

                        decoration: InputDecoration(
                          label: const Text('Mot De Passe'),
                          hintText: 'Entrer Mot De Passe',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.password),
                        ),
                        //for password we check multiple things
                        validator: passwordValidator,
                        onSaved: (password) => _password = password!,
                        //validate our password
                        onChanged: (pass) => _password = pass,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // i agree to the processing
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: primaryColor,
                          ),
                          const Text(
                            'J\'accepte le traitement des ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          const Text(
                            'Données personnelles',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                agreePersonalData) {
                              SignUp();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LogInScreen(),
                                  ));
                            } else if (!agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Veuillez accepter le traitement des données personnelles'),
                                ),
                              );
                            }
                          },
                          child: const Text('S\'inscrire'),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),

                      const SizedBox(
                        height: 30.0,
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      // already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Vous avez déjà un compte? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const LogInScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Se connecter',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
