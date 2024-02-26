import 'dart:async';
// import 'dart:async' as tm;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/Actors/carspriteComponent.dart';
import 'package:mini_carpoolgame/Game/carpoolgame.dart';
import 'package:mini_carpoolgame/constants.dart';

class Level1 extends World with HasGameRef<CarPoolGame>, TapCallbacks {
  // late final tm.Timer _timer;
  late final TiledComponent firstLevel;
  // late final CameraComponent _cameraComponent;
  List<Vector2> touchPoints = [];

  // bool isFacingright = true, isFacingUp = true;
  late final CarSpriteComponent carSpriteComponent;

  @override
  FutureOr<void> onLoad() async {
    debugPrint("Level 1 Started");
    firstLevel = await TiledComponent.load("testMap3.tmx", Vector2.all(32));
    add(firstLevel);
    final objectLayer =
        firstLevel.tileMap.getLayer<ObjectGroup>("movement points");
    for (var object in objectLayer!.objects) {
      debugPrint("Height: ${object.height} Width: ${object.width}");
      touchPoints.add(Vector2(object.x, object.y));
    }
    Sprite sprite = await game.loadSprite(Global.carPlayerSprite);
    return super.onLoad();
  }
}
