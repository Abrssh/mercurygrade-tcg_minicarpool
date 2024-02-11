import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/carpoolgame.dart';

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({super.key});

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
        title: const Text("Game Details"),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "assets/gameExplanationImage.jpg",
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
                    "Detailed Explanation",
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
                      "We will put detailed explanations here. We will put detailed explanations here. We will put detailed explanations here.",
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
                                    builder: (context) =>
                                        GameWidget(game: CarPoolGame()),
                                  ));
                            }
                          : null,
                      child: Text(
                        "Play",
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
