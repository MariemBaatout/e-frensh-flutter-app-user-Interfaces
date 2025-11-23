import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/screens/dashboard/dashboard.dart';
import 'package:flutter_e_french_app/screens/featured_screen.dart';
import 'package:flutter_e_french_app/screens/more%20button/more_screen.dart';
import 'package:flutter_e_french_app/screens/profil/user_profil_screen.dart';
import '../constants.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    FeaturedScreen(),
    FeaturedScreen(),
    FeaturedScreen(),
    FeaturedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:
          const BaseScreenBottomNav(), // Call the new Bottom Nav widget
    );
  }
}

// New Bottom Navigation Bar Widget to be used in other screens
class BaseScreenBottomNav extends StatefulWidget {
  const BaseScreenBottomNav({super.key});

  @override
  State<BaseScreenBottomNav> createState() => _BaseScreenBottomNavState();
}

class _BaseScreenBottomNavState extends State<BaseScreenBottomNav> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      backgroundColor: Colors.white,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Acceuil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Profil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Tableau de bord',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_outlined),
          label: 'Autres',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeaturedScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainProfile()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MoreScreen()),
          );
        }
      },
    );
  }
}
