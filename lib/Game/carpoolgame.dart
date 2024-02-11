import 'dart:async';
import 'dart:async' as tm;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/homescreen.dart';

class CarPoolGame extends FlameGame with HasGameRef<CarPoolGame> {
  late final tm.Timer _timer;
  @override
  FutureOr<void> onLoad() {
    _timer = tm.Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (_timer.isActive) {
          _timer.cancel();
          Flame.device.setPortrait();
          Navigator.pushReplacement(
              game.buildContext!,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
        }
      },
    );
    debugPrint("Game Started");
    return super.onLoad();
  }
}
