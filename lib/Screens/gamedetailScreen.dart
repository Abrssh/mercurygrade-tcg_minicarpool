import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/carpoolgame.dart';
import 'package:mini_carpoolgame/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameDetailScreen extends StatefulWidget {
  final String tileName;
  final int emissionInGramsLimit, level;
  const GameDetailScreen(
      {super.key,
      required this.emissionInGramsLimit,
      required this.tileName,
      required this.level});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  bool playButtonEnabled = false;
  late final Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        playButtonEnabled = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gameDetails),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              Global.gameExplanationImageLoc,
              height: deviceHeight * 0.3,
              width: deviceWidth * 0.8,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    AppLocalizations.of(context)!.detailedExplanation,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth * 0.08),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  SizedBox(
                    height: deviceHeight * 0.3,
                    width: deviceWidth * 0.8,
                    child: Text(
                      AppLocalizations.of(context)!.detailedExplanationtext,
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: deviceWidth * 0.05),
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  ElevatedButton(
                      onPressed: playButtonEnabled
                          ? () {
                              Flame.device.setLandscape();
                              Flame.device.fullScreen();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameWidget(
                                      textDirection: TextDirection.ltr,
                                      game: CarPoolGame(
                                          emissionInGramsLimit:
                                              widget.emissionInGramsLimit,
                                          tileName: widget.tileName,
                                          level: widget.level),
                                      overlayBuilderMap: {
                                        'Overlay': (BuildContext context,
                                            CarPoolGame game) {
                                          return Container(
                                            color: Colors.greenAccent,
                                          );
                                        },
                                      },
                                    ),
                                  ));
                            }
                          : null,
                      child: Text(
                        AppLocalizations.of(context)!.play,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: deviceWidth * 0.1),
                      ))
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}
