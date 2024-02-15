import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/carpoolgame.dart';

class StatUIOverlay extends Component with HasGameRef<CarPoolGame> {
  String emissionNum, emissionLimit, passengerNum;

  StatUIOverlay(
      {required this.emissionNum,
      required this.passengerNum,
      required this.emissionLimit});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    const textstyle = TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold);
    final firstPosition = Vector2(10, 10);
    TextPainter(
        text: TextSpan(
          text: "Emission(g): $emissionNum / $emissionLimit",
          style: textstyle,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, firstPosition.toOffset());
    final secondPosition = Vector2(game.size.x - 300, 10);
    TextPainter(
        text: TextSpan(
          text: "Passenger: $passengerNum / 2",
          style: textstyle,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, secondPosition.toOffset());
  }
}

class GameMessageUIOverlay extends Component with HasGameRef<CarPoolGame> {
  String gameMessage;

  GameMessageUIOverlay({required this.gameMessage});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    const textstyle = TextStyle(
        color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold);
    final screenSize = Vector2(game.size.x, game.size.y);
    final centerTextPosition = (screenSize - Vector2.all(24)) / 2;
    TextPainter(
        text: TextSpan(text: gameMessage, style: textstyle),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, centerTextPosition.toOffset());
  }
}
