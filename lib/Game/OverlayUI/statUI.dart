import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/carpoolgame.dart';

class StatUIOverlay extends Component with HasGameRef<CarPoolGame> {
  String emissionNum, emissionLimit, passengerNum, destinationNum;

  StatUIOverlay(
      {required this.emissionNum,
      required this.passengerNum,
      required this.destinationNum,
      required this.emissionLimit});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    const textstyle = TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold);
    const textstyle2 = TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300);
    final firstPosition = Vector2(10, 10);
    TextPainter(
        text: TextSpan(
          text: "Emission: $emissionNum / $emissionLimit (g)",
          style: textstyle,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, firstPosition.toOffset());
    final secondPosition = Vector2(game.size.x - 230, 10);
    TextPainter(
        text: TextSpan(
          text: "Passenger: $passengerNum / 2",
          style: textstyle2,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, secondPosition.toOffset());
    final thirdPosition = Vector2(game.size.x - 450, 10);
    TextPainter(
        text: TextSpan(
          text: "Dropped Off: $destinationNum / 2",
          style: textstyle2,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, thirdPosition.toOffset());
    // TextComponent passengerDropped = TextComponent(
    //     text: "Dropped Off: $destinationNum / 2",
    //     anchor: Anchor.topRight,
    //     position: Vector2(game.size.x - 60, 40),
    //     textRenderer: TextPaint(
    //         style: const TextStyle(color: Colors.white, fontSize: 20)));
    // add(passengerDropped);
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
    final screenSize = Vector2(game.size.x / 2, game.size.y / 2);
    // final centerTextPosition = ;
    TextPainter(
        text: TextSpan(text: gameMessage, style: textstyle),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, screenSize.toOffset());
  }
}
