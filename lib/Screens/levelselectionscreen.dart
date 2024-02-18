import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/LevelCard.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;

    List<LevelCard> levelCards = [];
    levelCards.add(const LevelCard(
        tileName: "testMap3.tmx",
        emissionInGramsLimit: 16,
        level: 1,
        levelName: "Level 1",
        levelDetails: "Level Details goes here for Level 1",
        imagePath: "assets/images/UI Assets/level1.jpg"));
    levelCards.add(const LevelCard(
        tileName: "Level 2.tmx",
        emissionInGramsLimit: 7,
        level: 2,
        levelName: "Level 2",
        levelDetails: "Level Details goes here for Level 1",
        imagePath: "assets/images/UI Assets/level2.jpg"));
    levelCards.add(const LevelCard(
        tileName: "Level 3.tmx",
        emissionInGramsLimit: 10,
        level: 3,
        levelName: "Level 3",
        levelDetails: "Level Details goes here for Level 1",
        imagePath: "assets/images/UI Assets/level3.jpg"));

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Select Level"),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Select Your Level",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: deviceWidth * 0.08),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: levelCards,
            ),
          ),
        ],
      ),
    );
  }
}
