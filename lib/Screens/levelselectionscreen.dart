import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/LevelCard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mini_carpoolgame/constants.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;

    List<List<List<int>>> lev1 = [], lev2 = [], lev3 = [];
    lev1.add([
      [12, 13],
      [13, 14]
    ]);
    lev1.add([
      [15, 14]
    ]);

    lev2.add([
      [7, 6],
      [7, 8]
    ]);
    lev2.add([
      [0, 1],
      [1, 4],
      [1, 2]
    ]);

    lev3.add([
      [13, 12],
      [13, 14],
      [13, 17],
      [13, 5]
    ]);
    lev3.add([
      [7, 6],
      [7, 8],
      [7, 15],
      [7, 2]
    ]);

    List<LevelCard> levelCards = [];
    levelCards.add(LevelCard(
        tileName: "testMap3.tmx",
        emissionInGramsLimit: 16,
        level: 1,
        levelName: AppLocalizations.of(context)!.lv1,
        levelDetails: AppLocalizations.of(context)!.levelDetail1,
        roadsBlocked: lev1,
        // imagePath: "assets/images/UI Assets/level1.jpg"));
        imagePath: Global.level1ImageLoc));
    levelCards.add(LevelCard(
        tileName: "Level 2.tmx",
        emissionInGramsLimit: 7,
        level: 2,
        roadsBlocked: lev2,
        levelName: AppLocalizations.of(context)!.lv2,
        levelDetails: AppLocalizations.of(context)!.levelDetail2,
        // imagePath: "assets/images/UI Assets/level2.jpg"));
        imagePath: Global.level2ImageLoc));
    levelCards.add(LevelCard(
        tileName: "Level 3.tmx",
        emissionInGramsLimit: 10,
        level: 3,
        roadsBlocked: lev3,
        levelName: AppLocalizations.of(context)!.lv3,
        levelDetails: AppLocalizations.of(context)!.levelDetail3,
        // imagePath: "assets/images/UI Assets/level3.jpg"));
        imagePath: Global.level3ImageLoc));

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Select Level"),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.selectYourLevel,
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
