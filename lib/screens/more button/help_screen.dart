import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/screens/more%20button/more_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  HelpCenterScreen({Key? key}) : super(key: key);

  final String _email = 'efrensh.support@gmail.com';
  final List<String> _phoneNumbers = ['+216 +92 139 569'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centre d\'aide'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoreScreen(),
              )),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Si vous avez besoin d\'aide ou avez des questions, veuillez nous contacter :',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.email),
                const SizedBox(width: 8),
                Text(
                  _email,
                  style: const TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Ou appelez-nous à l\'un des numéros suivants :',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            for (final phoneNumber in _phoneNumbers)
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8),
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
