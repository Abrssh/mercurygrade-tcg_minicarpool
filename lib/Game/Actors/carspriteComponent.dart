// import 'dart:math';

import 'dart:async';

import 'package:flame/components.dart';
import 'package:mini_carpoolgame/Game/carpoolgame.dart';
import 'package:mini_carpoolgame/constants.dart';

enum PlayerState { idle, running }

class CarSpriteComponent extends SpriteGroupComponent {
  CarSpriteComponent(double x, double y) : super() {
    this.x = x;
    this.y = y;
  }
}

class PassengerComp extends SpriteAnimationGroupComponent
    with HasGameRef<CarPoolGame> {
  late final SpriteAnimation idleAnimation, runningAnimation;
  final double stepTime = 0.05;
  final int passengerNum;
  PassengerComp(double x, double y, {required this.passengerNum}) : super() {
    this.x = x;
    this.y = y;
  }

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    return super.onLoad();
  }

  void _loadAllAnimation() {
    if (passengerNum == 1) {
      idleAnimation = _spriteAnimationCreation(
          Global.virtualGuyIdle, 11, stepTime, 32.toDouble());
      runningAnimation = _spriteAnimationCreation(
          Global.virtualGuyRunning, 12, stepTime, 32.toDouble());
    } else {
      idleAnimation = _spriteAnimationCreation(
          Global.pinkManIdle, 11, stepTime, 32.toDouble());
      runningAnimation = _spriteAnimationCreation(
          Global.pinkManRunning, 12, stepTime, 32.toDouble());
    }

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimationCreation(
      String fileName, int numberOfSprites, stepTime, double textureSize) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache(fileName),
        SpriteAnimationData.sequenced(
            amount: numberOfSprites,
            stepTime: stepTime,
            textureSize: Vector2.all(textureSize)));
  }

  void changeAnimation() {
    if (current == PlayerState.idle) {
      current = PlayerState.running;
    } else {
      current = PlayerState.idle;
    }
  }
}

class SecondPassengerComp extends SpriteComponent {
  final double speed = 200.0;
  SecondPassengerComp(double x, double y, Sprite sprite) : super() {
    this.x = x;
    this.y = y;
    this.sprite = sprite;
  }
}

class CopCarComp extends SpriteComponent {
  CopCarComp(double x, double y, Sprite sprite) : super() {
    this.x = x;
    this.y = y;
    this.sprite = sprite;
  }
}
