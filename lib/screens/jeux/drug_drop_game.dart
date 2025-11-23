import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_french_app/screens/jeux/item_model.dart';

void main() => runApp(const ElearningDashboard());

class ElearningDashboard extends StatelessWidget {
  const ElearningDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DrugAndDropScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DrugAndDropScreen extends StatefulWidget {
  const DrugAndDropScreen({super.key});

  @override
  State<DrugAndDropScreen> createState() => _DrugAndDropScreenState();
}

class _DrugAndDropScreenState extends State<DrugAndDropScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late bool gameOver;

  initGame() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(name: 'Lion', img: 'asset/images/lion.png', value: 'lion'),
      ItemModel(name: 'Panda', img: 'asset/images/panda.png', value: 'panda'),
      ItemModel(
          name: 'Chameau', img: 'asset/images/camel.png', value: 'chameau'),
      ItemModel(name: 'Chien', img: 'asset/images/dog.png', value: 'chien'),
      ItemModel(name: 'Chat', img: 'asset/images/cat.png', value: 'chat'),
      ItemModel(name: 'Cheval', img: 'asset/images/horse.png', value: 'cheval'),
      ItemModel(name: 'Mouton', img: 'asset/images/sheep.png', value: 'mouton'),
      ItemModel(name: 'Poule', img: 'asset/images/hen.png', value: 'poule'),
      ItemModel(name: 'Renard', img: 'asset/images/fox.png', value: 'renard'),
      ItemModel(name: 'Vache', img: 'asset/images/cow.png', value: 'vache'),
    ];
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  Future<void> _playSound(String fileName) async {
    await _audioPlayer.play(AssetSource(fileName));
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) gameOver = true;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'Score: ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: '$score',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.teal),
                    ),
                  ]),
                ),
              ),
              if (!gameOver)
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: items.map((item) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          child: Draggable<ItemModel>(
                            data: item,
                            childWhenDragging: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.img),
                              radius: 50,
                            ),
                            feedback: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.img),
                              radius: 30,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.img),
                              radius: 30,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Spacer(flex: 2),
                    Column(
                      children: items2.map((item) {
                        return DragTarget<ItemModel>(
                          onAccept: (receivedItem) {
                            if (item.value == receivedItem.value) {
                              setState(() {
                                items.remove(receivedItem);
                                items2.remove(item);
                              });
                              score += 10;
                              item.accepting = false;
                              _playSound('true.wav');
                            } else {
                              setState(() {
                                score -= 5;
                                item.accepting = false;
                                _playSound('false.wav');
                              });
                            }
                          },
                          onWillAccept: (receivedItem) {
                            setState(() {
                              item.accepting = true;
                            });
                            return true;
                          },
                          onLeave: (receivedItem) {
                            setState(() {
                              item.accepting = false;
                            });
                          },
                          builder: (context, acceptedItems, rejectedItems) =>
                              Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: item.accepting
                                  ? Colors.grey[400]
                                  : Colors.grey[200],
                            ),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width / 6.5,
                            width: MediaQuery.of(context).size.width / 3,
                            margin: const EdgeInsets.all(8),
                            child: Text(
                              item.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                  ],
                ),
              if (gameOver)
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Jeu Terminé',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          result(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              if (gameOver)
                Container(
                  height: MediaQuery.of(context).size.width / 10,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          initGame();
                        });
                      },
                      child: const Text(
                        'Nouveau Jeu',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String result() {
    if (score == 100) {
      _playSound('success.wav');
      return 'Géniale!';
    } else {
      _playSound('tryAgain.wav');
      return 'Rejouer pour obtenir un meilleur score';
    }
  }
}
