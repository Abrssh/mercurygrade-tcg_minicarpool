import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/carpoolgame.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatUIOverlay extends Component with HasGameRef<CarPoolGame> {
  String emissionNum, emissionLimit, passengerNum, destinationNum, time;
  BuildContext buildContext;

  StatUIOverlay(
      {required this.emissionNum,
      required this.passengerNum,
      required this.destinationNum,
      required this.time,
      required this.buildContext,
      required this.emissionLimit});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    const textstyle = TextStyle(
        color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold);
    const textstyle2 = TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300);
    const textstyle3 = TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300);
    final firstPosition = Vector2(10, 10);
    TextPainter(
        text: TextSpan(
          text:
              "${AppLocalizations.of(buildContext)!.emission}: $emissionNum / $emissionLimit (g)",
          style: textstyle,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, firstPosition.toOffset());
    final secondPosition = Vector2(game.size.x - 230, 10);
    TextPainter(
        text: TextSpan(
          text:
              "${AppLocalizations.of(buildContext)!.passenger}: $passengerNum / 2",
          style: textstyle2,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, secondPosition.toOffset());
    final thirdPosition = Vector2(game.size.x - 430, 10);
    TextPainter(
        text: TextSpan(
          text:
              "${AppLocalizations.of(buildContext)!.droppedOff}: $destinationNum / 2",
          style: textstyle2,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, thirdPosition.toOffset());
    final fourthPosition = Vector2(game.size.x - 540, 10);
    TextPainter(
        text: TextSpan(
          text: "${AppLocalizations.of(buildContext)!.time}: $time",
          style: textstyle3,
        ),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, fourthPosition.toOffset());
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
  double time;
  bool success = false;
  BuildContext buildContext;

  GameMessageUIOverlay(
      {required this.gameMessage,
      required this.time,
      required this.success,
      required this.buildContext});

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    TextStyle textstyle = TextStyle(
        color: success ? Colors.greenAccent : Colors.white,
        fontSize: success ? 27 : 34,
        fontWeight: success ? FontWeight.bold : FontWeight.bold);
    TextStyle textstyle2 = TextStyle(
        color: success ? Colors.white : Colors.red,
        fontSize: success ? 27 : 20,
        fontWeight: success ? FontWeight.bold : FontWeight.bold);
    // final screenSize = Vector2(game.size.x / 2, game.size.y / 2);
    final screenSize = Vector2(game.size.x / 2 - 180, game.size.y / 2 - 30);
    final screenSize2 = Vector2(game.size.x / 2 - 140, game.size.y / 2 + 10);
    final screenSize3 = Vector2(game.size.x / 2 - 120, game.size.y / 2 - 20);
    final screenSize4 = Vector2(game.size.x / 2 - 190, game.size.y / 2 + 25);
    // final centerTextPosition = ;
    TextPainter(
        text: TextSpan(
            text: success
                ? gameMessage
                : AppLocalizations.of(buildContext)!.gameOver,
            // : "Game Over",
            style: textstyle),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(canvas, success ? screenSize.toOffset() : screenSize3.toOffset());
    TextPainter(
        text: TextSpan(
            text: success
                ? "${AppLocalizations.of(buildContext)!.score}: ${(100 / time).toDouble().floor().toString()}"
                : gameMessage,
            style: textstyle2),
        textDirection: TextDirection.ltr)
      ..layout()
      ..paint(
          canvas, success ? screenSize2.toOffset() : screenSize4.toOffset());
  }
}
