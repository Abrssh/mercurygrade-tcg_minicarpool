import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/LevelCard.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;
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
              children: List.generate(
                  3,
                  (index) => LevelCard(
                      levelName: "Level${index + 1}",
                      levelDetails: "levelDetails ${index + 1}",
                      imagePath: "assets/level${index + 1}.jpg")),
            ),
          ),
        ],
      ),
    );
  }
}
