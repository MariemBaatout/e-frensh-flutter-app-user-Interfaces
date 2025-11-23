import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/constants.dart';
import 'package:flutter_e_french_app/screens/courses/grammar_course_list.dart';
import 'package:flutter_e_french_app/screens/courses/ortho_course_list.dart';
import 'package:flutter_e_french_app/screens/courses/pronounciation_course_list.dart';
import 'package:flutter_e_french_app/screens/courses/vocab_course_list.dart';
import 'package:flutter_e_french_app/screens/featured_screen.dart';

class CourseHomeScreen extends StatefulWidget {
  const CourseHomeScreen({super.key});

  @override
  State<CourseHomeScreen> createState() => _CourseHomeScreenState();
}

class _CourseHomeScreenState extends State<CourseHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List imgList = [
    {
      'image': 'asset/images/moyen-de-transport.webp',
      'text': 'Moyen de Transport'
    },
    {'image': 'asset/images/dictee.jpg', 'text': 'Dictée'},
    {'image': 'asset/images/jeux-de-role.png', 'text': 'Jeux de Role'},
    {'image': 'asset/images/verbes.webp', 'text': 'Verbes'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeaturedScreen()),
                  );
                },
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "C'est une belle journée pour apprendre de nouveaux mots français",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                width: MediaQuery.of(context).size.width,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Trouvez votre leçon",
                    hintStyle: TextStyle(
                      color: primaryColor.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: primaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              // ignore: prefer_const_literals_to_create_immutables
              TabBar(
                  controller: _tabController,
                  labelColor: primaryColor,
                  unselectedLabelColor: primaryColor.withOpacity(0.5),
                  isScrollable: true,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 3,
                      color: primaryColor,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  labelStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                  tabs: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VocabListScreen()),
                        );
                      },
                      child: const Tab(text: "Vocabulaire"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrthoListScreen()),
                        );
                      },
                      child: const Tab(text: "Orthographe"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GrammarListScreen()),
                        );
                      },
                      child: const Tab(text: "Grammaire"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PronounciationListScreen()),
                        );
                      },
                      child: const Tab(text: "Prononciation"),
                    ),
                  ]),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: imgList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Expanded(
                          child: Image.asset(imgList[index]['image']),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          imgList[index]['text'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
