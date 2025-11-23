// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/screens/more%20button/more_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A propos E-Frensh'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoreScreen(),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-Frensh',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Rebote Me is a comprehensive mobile application designed to help users take control of their phone use time, while also providing them with a wide range of activities to help break free from routine and enhance their overall lifestyle. With features such as usage limits, users can monitor and reduce their dependence on their devices, resulting in a healthier and more balanced lifestyle.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Expert Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'In addition to the phone control features, Rebote Me offers access to a team of experienced psychotherapists, life trainers, and child psychiatrists. Users can easily browse and choose from a wide variety of experts to find the support they need to improve their mental health and well-being.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Activities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'With Rebote Me, users can discover a diverse range of activities that are designed to help them break away from phone habits and focus on other areas of their lives. From fitness and meditation to art and music, Rebote Me provides a wealth of options to help users find new ways to relax, de-stress, and enhance their overall lifestyle.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Overall',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Rebote Me is the perfect tool for those looking to take control of their phone use time and improve their overall lifestyle. With a wide range of features and access to expert support, Rebote Me is the ultimate app for anyone looking to achieve greater balance and well-being in their lives.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
