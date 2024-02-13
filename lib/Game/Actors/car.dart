// import 'dart:async';

// import 'package:flame/components.dart';
// import 'package:mini_carpoolgame/Game/carpoolgame.dart';

// enum PlayerDirection { left, right, up, down }

// class CarPlayer extends SpriteAnimationGroupComponent
//     with HasGameRef<CarPoolGame> {
//   final List<Vector2> touchPoints;

//   CarPlayer({required this.touchPoints});

//   bool isFacingright = true, isFacingUp = true;

//   double moveSpeed = 100;
//   Vector2 velocity = Vector2.zero();

//   PlayerDirection playerDirection = PlayerDirection.right;

//   @override
//   FutureOr<void> onLoad() {
//     return super.onLoad();
//   }

//   @override
//   void update(double dt) {
//     updatePlayerMovement(dt);
//     super.update(dt);
//   }

//   void updatePlayerMovement(double dt) {
//     double dirX = 0, dirY = 0;

//     switch (playerDirection) {
//       case PlayerDirection.right:
//         if (!isFacingright) {
//           di
//         }
//         dirX -= moveSpeed;
//         break;
//       default:
//     }
//   }
// }
