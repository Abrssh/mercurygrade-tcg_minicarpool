import 'dart:async';
import 'dart:async' as tm;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/Actors/carspriteComponent.dart';
import 'package:mini_carpoolgame/Screens/homescreen.dart';
import 'package:mini_carpoolgame/constants.dart';

class CarPoolGame extends FlameGame with HasGameRef<CarPoolGame>, TapDetector {
  late final tm.Timer _timer;
  late final TiledComponent firstLevel;
  // late final CameraComponent _cameraComponent;

  List<Vector2> touchPoints = [];

  // bool isFacingright = true, isFacingUp = true;
  late final CarSpriteComponent carSpriteComponent;

  @override
  FutureOr<void> onLoad() async {
    _timer = tm.Timer.periodic(
      const Duration(hours: 1),
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
    Sprite sprite = await game.loadSprite(Global.carPlayerSprite);
    await images.loadAllImages();
    debugPrint("Images Loaded: ${images.toString()}");
    firstLevel = await TiledComponent.load("testMap3.tmx", Vector2.all(32));
    // _cameraComponent =
    //     CameraComponent.withFixedResolution(width: 768, height: 384);
    // _cameraComponent.viewfinder.anchor = Anchor.center;
    final objectLayer =
        firstLevel.tileMap.getLayer<ObjectGroup>("movement points");
    for (var object in objectLayer!.objects) {
      debugPrint(
          "Height: ${object.height} Width: ${object.width} ${Global.carPlayerSprite}");
      touchPoints.add(Vector2(object.x, object.y));
    }
    // Sprite sprite = await game.loadSprite(Global.carPlayerSprite);
    carSpriteComponent =
        CarSpriteComponent(touchPoints[0].x, touchPoints[0].y, sprite);
    addAll([firstLevel, carSpriteComponent]);
    return super.onLoad();
  }

  // @override
  // void onTapUp(TapUpInfo info) {
  //   double tapX = info.raw.globalPosition.dx;
  //   double tapY = info.raw.globalPosition.dy;
  //   carSpriteComponent.moveTowards(tapX, tapY, 1.0);
  //   super.onTapUp(info);
  // }

  // @override
  // void onTapUp(TapUpInfo info) {
  //   Vector2 touchposition =
  //       Vector2(info.raw.globalPosition.dx, info.raw.globalPosition.dy);

  //   for (var touchPoint in touchPoints) {
  //     if ((touchposition - touchPoint).length < 20) {
  //       debugPrint("Touch around touchpoints");
  //       // Update sprite position based on touch
  //       carSpriteComponent.x = info.eventPosition.global.x - 35;
  //       carSpriteComponent.y = info.eventPosition.global.y - 35;
  //       break;
  //     }
  //   }
  //   super.onTapUp(info);
  // }

  @override
  void handleTapDown(TapDownDetails details) {
    Vector2 touchposition =
        Vector2(details.localPosition.dx, details.localPosition.dy);

    for (var touchPoint in touchPoints) {
      if ((touchposition - touchPoint).length < 20) {
        debugPrint("Touch around touchpoints");
        // Update sprite position based on touch
        carSpriteComponent.x = details.localPosition.dx - 35;
        carSpriteComponent.y = details.localPosition.dy - 35;
        break;
      }
    }
    super.handleTapDown(details);
  }
}
