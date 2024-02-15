// import 'dart:math';

import 'package:flame/components.dart';

class CarSpriteComponent extends SpriteComponent {
  final double speed = 200.0;
  // CarSpriteComponent(double x, double y) : super.fr() {
  //   this.x = x;
  //   this.y = y;
  // }
  CarSpriteComponent(double x, double y, Sprite sprite) : super() {
    this.x = x;
    this.y = y;
    this.sprite = sprite;
  }

  // void moveTowards(double targetXpoint, double targetYpoint, double dt) {
  //   double angle = atan2(targetYpoint - y, targetXpoint - x);
  //   double deltaX = speed * cos(angle);
  //   double deltaY = speed * sin(angle);

  //   double distance = speed * dt;

  //   if (calculateDistance(x, y, targetXpoint, targetYpoint) > distance) {
  //     x += deltaX;
  //     y += deltaY;
  //   } else {
  //     x = targetXpoint;
  //     y = targetYpoint;
  //   }

  //   // x += deltaX;
  //   // y += deltaY;
  // }

  // double calculateDistance(double x1, double y1, double x2, double y2) {
  //   return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  // }
}

class FirstPassengerComp extends SpriteComponent {
  final double speed = 200.0;
  FirstPassengerComp(double x, double y, Sprite sprite) : super() {
    this.x = x;
    this.y = y;
    this.sprite = sprite;
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
