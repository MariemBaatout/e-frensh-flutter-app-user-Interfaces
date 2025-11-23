// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/screens/more%20button/more_screen.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termes et Conditions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoreScreen(),
              )),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Termes et Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'En utilisant cette application, vous acceptez les conditions générales suivantes :',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Utilisation de l\'application',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cette application est réservée à un usage personnel uniquement. Vous ne pouvez pas l\'utiliser à des fins commerciales sans notre consentement écrit exprès.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '2. Collecte de données',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nous pouvons collecter certaines données liées à votre utilisation de cette application, telles que le type d\'appareil que vous utilisez et vos habitudes d\'utilisation. Ces données seront utilisées à des fins d\'analyse uniquement et ne seront pas partagées avec des tiers.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '3. Contenu utilisateur',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tout contenu que vous soumettez à cette application, y compris les commentaires et suggestions, peut être utilisé par nous sans aucune obligation de vous rémunérer ou de demander votre autorisation.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '4. Exclusion de garanties',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cette application est fournie « telle quelle » et nous ne donnons aucune garantie, expresse ou implicite, concernant sa fonctionnalité, son exactitude ou son adéquation à quelque fin que ce soit. Nous ne sommes pas responsables des dommages ou pertes pouvant résulter de votre utilisation de cette application.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
