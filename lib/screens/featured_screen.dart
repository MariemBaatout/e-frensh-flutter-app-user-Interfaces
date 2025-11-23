import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_e_french_app/widgets/category_card.dart';
import 'package:flutter_e_french_app/constants.dart';
import 'package:flutter_e_french_app/screens/teacher_screen.dart';
import 'package:flutter_e_french_app/widgets/search_field.dart';
import 'package:flutter_e_french_app/models/category.dart';
import 'package:flutter_e_french_app/screens/base_screen.dart'; // Import the BaseScreen

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({Key? key}) : super(key: key);

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            TopBar(),
            Expanded(child: Body()),
          ],
        ),
        bottomNavigationBar:
            BaseScreenBottomNav(), // Add the bottom navigation bar
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Explorer l\'enseignant',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeacherScreen(),
                  ),
                ),
                child: Text(
                  'Voir Tout',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: primaryColor,
                      ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: categoryList.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 24,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(category: categoryList[index]);
          },
        ),
      ],
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      height: 150,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xff886ff2),
            Color(0xff6849ef),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Salut,\nBonjour',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.logout_outlined),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SearchTextField(),
        ],
      ),
    );
  }
}
