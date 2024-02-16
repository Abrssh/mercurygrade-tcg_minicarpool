import 'dart:async';
import 'dart:async' as tm;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/Actors/carspriteComponent.dart';
import 'package:mini_carpoolgame/Game/OverlayUI/statUI.dart';
import 'package:mini_carpoolgame/Game/path_finding.dart';
import 'package:mini_carpoolgame/Screens/homescreen.dart';
import 'package:mini_carpoolgame/constants.dart';

class CarPoolGame extends FlameGame with HasGameRef<CarPoolGame>, TapDetector {
  late final tm.Timer _timer;
  late final TiledComponent firstLevel;

  List<Vector2> touchPoints = [],
      spawnPointsPassengers = [],
      destinationSpawnPoints = [];
  Vector2 playerSpawnPoint = Vector2.zero();

  late final CarSpriteComponent carSpriteComponent;
  // determines the next node in the path is reached while final destination
  // determines if the goal node of the path is reached
  bool destinationReached = true, finalDestinationReached = true;
  late Vector2 destination, finalDestination, velocity;
  // holds all the nodes in the path that will be returned from the path finding method
  List<Vector2> totalNodesInPath = [];
  // indicate which node is the current destination
  int currentNode = 0;

  late final PathFinding pathGraph;
  final double moveSpeed = 200;
  final double yAxisSpriteAdjustment = -62;
  final double xAxisSpriteAdjustment = -30;

  int emissionInGrams = 0, time = 0;
  late final FirstPassengerComp firstPassengerComp;
  late final SecondPassengerComp secondPassengerComp;
  bool firstPassengerBoarded = false, secondPassengerBoarded = false;
  bool firstDestinationArrived = false, secondDestinationArrived = false;

  // UI elements
  late final StatUIOverlay statUIOverlay;
  late GameMessageUIOverlay gameMessageUIOverlay;
  String passengerNum = "0";
  bool firstTime = true;

  // Level related variables
  final String tileName;
  final int emissionInGramsLimit, level;

  CarPoolGame(
      {required this.tileName,
      required this.level,
      required this.emissionInGramsLimit});

  @override
  FutureOr<void> onLoad() async {
    _timer = tm.Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (firstPassengerBoarded && secondPassengerBoarded) {
          passengerNum = "2";
        } else if (firstPassengerBoarded || secondPassengerBoarded) {
          passengerNum = "1";
        }
        if (firstTime) {
          statUIOverlay = StatUIOverlay(
              emissionNum: emissionInGrams.toString(),
              passengerNum: passengerNum,
              emissionLimit: emissionInGramsLimit.toString());
          add(statUIOverlay);
          firstTime = false;
        }
        statUIOverlay.emissionNum = emissionInGrams.toString();
        statUIOverlay.emissionLimit = emissionInGramsLimit.toString();
        statUIOverlay.passengerNum = passengerNum;
        debugPrint(
            "Emission: ${emissionInGrams.toString()} Time: ${time.toString()}");
        debugPrint(
            "Da: ${firstDestinationArrived.toString()} Sa: ${secondDestinationArrived.toString()} Fp: ${firstPassengerBoarded.toString()} Sp: ${secondPassengerBoarded.toString()}");
        if (emissionInGrams > emissionInGramsLimit &&
            (!firstDestinationArrived || !secondDestinationArrived)) {
          debugPrint("Game Over");
          gameMessageUIOverlay = GameMessageUIOverlay(gameMessage: "Game Over");
          add(gameMessageUIOverlay);
          await Future.delayed(
            const Duration(seconds: 3),
            () {
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
        } else if (firstDestinationArrived &&
            secondDestinationArrived &&
            emissionInGrams <= emissionInGramsLimit) {
          debugPrint("Level Passed");
          gameMessageUIOverlay =
              GameMessageUIOverlay(gameMessage: "Level Passed");
          add(gameMessageUIOverlay);
          await Future.delayed(
            const Duration(seconds: 3),
            () {
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
        } else {
          time++;
        }
      },
    );
    debugPrint("Game Started");

    // Loading Images and Tiles
    Sprite carSprite = await game.loadSprite(Global.carPlayerSprite);
    Sprite firPassSpr = await game.loadSprite(Global.passenger1Sprite);
    Sprite secPassSpr = await game.loadSprite(Global.passenger2Sprite);
    await images.loadAllImages();
    debugPrint("Images Loaded: ${images.toString()} $tileName");
    firstLevel = await TiledComponent.load(tileName, Vector2.all(32));

    // Gets allowed movement points for the touch input and spawn points
    final objectLayer = firstLevel.tileMap.getLayer<ObjectGroup>("mov lay");
    final spawnLayer = firstLevel.tileMap.getLayer<ObjectGroup>("spawnPoints");
    for (var object in objectLayer!.objects) {
      // debugPrint(
      //     "Height: ${object.height} Width: ${object.width} ${Global.carPlayerSprite}");
      touchPoints.add(Vector2(object.x, object.y));
    }
    for (var spawnPoint in spawnLayer!.objects) {
      if (spawnPoint.class_ == "player") {
        playerSpawnPoint = Vector2(spawnPoint.x, spawnPoint.y);
      } else if (spawnPoint.class_ == "passenger") {
        spawnPointsPassengers.add(Vector2(spawnPoint.x, spawnPoint.y));
      } else {
        destinationSpawnPoints.add(Vector2(spawnPoint.x, spawnPoint.y));
      }
    }

    // creating and spawning car at a specific location
    carSpriteComponent = CarSpriteComponent(
        playerSpawnPoint.x + xAxisSpriteAdjustment,
        playerSpawnPoint.y + yAxisSpriteAdjustment,
        carSprite);
    firstPassengerComp = FirstPassengerComp(
        spawnPointsPassengers[0].x, spawnPointsPassengers[0].y, firPassSpr);
    secondPassengerComp = SecondPassengerComp(
        spawnPointsPassengers[1].x, spawnPointsPassengers[1].y, secPassSpr);
    addAll([
      firstLevel,
      carSpriteComponent,
      firstPassengerComp,
      secondPassengerComp,
    ]);

    // Creating path graph which will be used to implement proper movement
    switch (level) {
      case 1:
        pathGraph = addLevel1PathGraph();
      case 2:
        pathGraph = addLevel2PathGraph();
      case 3:
        pathGraph = addLevel3PathGraph();
        break;
      default:
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // debugPrint(
    //     "Fd: $finalDestinationReached D: $destinationReached Tn: ${totalNodesInPath.length.toString()} CNode: ${currentNode.toString()}");
    if (!destinationReached) {
      moveTowards(dt);
    } else if (!finalDestinationReached) {
      currentNode++;
      destination = Vector2(
          totalNodesInPath[currentNode].x, totalNodesInPath[currentNode].y);
      velocity =
          (destination - carSpriteComponent.position).normalized() * moveSpeed;
      destinationReached = false;
    } else {}
    super.update(dt);
  }

  @override
  void handleTapDown(TapDownDetails details) {
    if (finalDestinationReached) {
      debugPrint("Touch is allowed ${carSpriteComponent.position.toString()}");
      Vector2 touchposition =
          Vector2(details.localPosition.dx, details.localPosition.dy);

      int cNode = 0, destinationNode = 0;
      bool movementPointTouched = false;

      // identifies current node using car position and destination node using touch input
      for (var touchPoint in touchPoints) {
        if ((touchposition - touchPoint).length < 20) {
          debugPrint("Touch around touchpoints");
          // Update sprite position based on touch
          // carSpriteComponent.x = details.localPosition.dx - 35;
          // carSpriteComponent.y = details.localPosition.dy - 35;

          destinationNode = touchPoints.indexOf(touchPoint);
          movementPointTouched = true;
          break;
        }
      }

      if (movementPointTouched) {
        for (var touchPoint in touchPoints) {
          // Accounts for the Yaxis adjustment done in returnBestPath method
          // for UI purposes
          Vector2 adjustedTouchPoint = Vector2(
              touchPoint.x + xAxisSpriteAdjustment,
              touchPoint.y + yAxisSpriteAdjustment);
          if ((carSpriteComponent.position.distanceTo(touchPoint) < 10) ||
              (carSpriteComponent.position.distanceTo(adjustedTouchPoint) <
                  10)) {
            cNode = touchPoints.indexOf(touchPoint);
            debugPrint("CarSprite TouchPoint Found ${cNode.toString()}");
            break;
          }
        }

        // debugPrint("Cn: ${cNode.toString()} ${destinationNode.toString()}");
        destinationReached = false;
        finalDestinationReached = false;
        List<Vector2> nodesReturned = returnTheBestPath(cNode, destinationNode);
        // debugPrint("Path ${nodesReturned.join(" -> ")}");
        // debugPrint("TouchPoints ${touchPoints.join(" -> ")}");
        totalNodesInPath.addAll(nodesReturned);
        // Adds Emission
        emissionInGrams += totalNodesInPath.length - 1;
        destination = Vector2(
            totalNodesInPath[currentNode].x, totalNodesInPath[currentNode].y);
        // finalDestination = Vector2(
        //     touchPoints[destinationNode].x, touchPoints[destinationNode].y);
        finalDestination = Vector2(
            totalNodesInPath[totalNodesInPath.length - 1].x,
            totalNodesInPath[totalNodesInPath.length - 1].y);
        velocity = (destination - carSpriteComponent.position).normalized() *
            moveSpeed;
      }
    }
    super.handleTapDown(details);
  }

  // implments the process of moving the car to the desired location
  void moveTowards(double dt) {
    // debugPrint(
    //     "Car in progress ${destination.toString()} finalDest: ${finalDestination.toString()}");
    // debugPrint(
    //     "Cp: ${(carSpriteComponent.position - destination).length.toString()}  Vldt: ${(carSpriteComponent.position.distanceTo(finalDestination)).toString()}");
    carSpriteComponent.position.x += velocity.x * dt;
    carSpriteComponent.position.y += velocity.y * dt;

    // Check if the car reached the destination
    if ((carSpriteComponent.position - destination).length < 10) {
      carSpriteComponent.x = destination.x;
      carSpriteComponent.y = destination.y;
      destinationReached = true;

      // check if you have reached a passenger
      if (!firstPassengerBoarded || !secondPassengerBoarded) {
        Vector2 adjustedPos = Vector2(
            spawnPointsPassengers[0].x + xAxisSpriteAdjustment,
            spawnPointsPassengers[0].y + yAxisSpriteAdjustment);
        Vector2 adjustedPos2 = Vector2(
            spawnPointsPassengers[1].x + xAxisSpriteAdjustment,
            spawnPointsPassengers[1].y + yAxisSpriteAdjustment);
        if (carSpriteComponent.position.distanceTo(adjustedPos) < 45) {
          firstPassengerBoarded = true;
          firstPassengerComp.makeTransparent();
        }
        if (carSpriteComponent.position.distanceTo(adjustedPos2) < 45) {
          secondPassengerBoarded = true;
          secondPassengerComp.makeTransparent();
        }
      }

      // check if you have reached a destination
      if (!firstDestinationArrived ||
          !secondDestinationArrived && firstPassengerBoarded ||
          secondPassengerBoarded) {
        Vector2 adjustedPos = Vector2(
            destinationSpawnPoints[0].x + xAxisSpriteAdjustment,
            destinationSpawnPoints[0].y + yAxisSpriteAdjustment);
        Vector2 adjustedPos2 = Vector2(
            destinationSpawnPoints[1].x + xAxisSpriteAdjustment,
            destinationSpawnPoints[1].y + yAxisSpriteAdjustment);
        if ((carSpriteComponent.position.distanceTo(adjustedPos) < 45) &&
            firstPassengerBoarded) {
          firstDestinationArrived = true;
        }
        if ((carSpriteComponent.position.distanceTo(adjustedPos2) < 45) &&
            secondPassengerBoarded) {
          secondDestinationArrived = true;
        }
      }

      if ((carSpriteComponent.position.distanceTo(finalDestination) < 10)) {
        finalDestinationReached = true;
        totalNodesInPath.clear();
        currentNode = 0;
        destinationReached = true;
        debugPrint('Car reached the final destination.');
      }
    }
  }

  List<Vector2> returnTheBestPath(int startNode, int endNode) {
    List<Vector2> pathNodes = [];
    List<int> nodesReturned = [];
    nodesReturned.addAll(pathGraph.shortestPath(startNode, endNode));
    for (var nodeReturned in nodesReturned) {
      Vector2 nodepP =
          Vector2(touchPoints[nodeReturned].x, touchPoints[nodeReturned].y);
      nodepP.y += yAxisSpriteAdjustment;
      nodepP.x += xAxisSpriteAdjustment;
      // debugPrint(
      //     "Np: ${nodepP.y.toString()} Tp: ${touchPoints[nodeReturned].y.toString()}");
      pathNodes.add(nodepP);
    }
    debugPrint("Start: ${startNode.toString()} End: ${endNode.toString()}");
    debugPrint("Short Path: ${nodesReturned.join(" -> ")}");
    return pathNodes;
  }

  PathFinding addLevel1PathGraph() {
    PathFinding tmPathGraph = PathFinding(16);
    tmPathGraph.addEdge(0, 1, 3);
    tmPathGraph.addEdge(1, 2, 1);
    tmPathGraph.addEdge(2, 3, 2);
    tmPathGraph.addEdge(3, 4, 1);
    tmPathGraph.addEdge(4, 5, 1);
    tmPathGraph.addEdge(5, 6, 1);
    tmPathGraph.addEdge(6, 7, 2);
    tmPathGraph.addEdge(7, 8, 1);
    tmPathGraph.addEdge(8, 9, 1);
    tmPathGraph.addEdge(9, 10, 1);
    tmPathGraph.addEdge(10, 11, 1);
    tmPathGraph.addEdge(11, 12, 2);
    tmPathGraph.addEdge(12, 13, 1);
    tmPathGraph.addEdge(13, 14, 2);
    tmPathGraph.addEdge(14, 15, 1);
    return tmPathGraph;
  }

  PathFinding addLevel2PathGraph() {
    PathFinding tmPathGraph = PathFinding(10);
    tmPathGraph.addEdge(0, 1, 1);
    tmPathGraph.addEdge(0, 9, 2);
    tmPathGraph.addEdge(1, 4, 1);
    tmPathGraph.addEdge(1, 2, 1);
    tmPathGraph.addEdge(2, 3, 1);
    tmPathGraph.addEdge(4, 5, 3);
    tmPathGraph.addEdge(6, 7, 1);
    tmPathGraph.addEdge(7, 8, 1);
    tmPathGraph.addEdge(8, 2, 3);
    tmPathGraph.addEdge(8, 9, 1);
    return tmPathGraph;
  }

  PathFinding addLevel3PathGraph() {
    PathFinding tmPathGraph = PathFinding(24);
    tmPathGraph.addEdge(0, 1, 1);
    tmPathGraph.addEdge(0, 4, 1);
    tmPathGraph.addEdge(1, 2, 2);
    tmPathGraph.addEdge(1, 5, 1);
    tmPathGraph.addEdge(2, 3, 2);
    tmPathGraph.addEdge(2, 7, 1);
    tmPathGraph.addEdge(3, 9, 1);
    tmPathGraph.addEdge(4, 12, 1);
    tmPathGraph.addEdge(5, 6, 1);
    tmPathGraph.addEdge(5, 13, 1);
    tmPathGraph.addEdge(6, 7, 1);
    tmPathGraph.addEdge(6, 14, 1);
    tmPathGraph.addEdge(7, 8, 1);
    tmPathGraph.addEdge(7, 15, 1);
    tmPathGraph.addEdge(8, 9, 1);
    tmPathGraph.addEdge(8, 20, 1);
    tmPathGraph.addEdge(9, 3, 1);
    tmPathGraph.addEdge(9, 10, 1);
    tmPathGraph.addEdge(10, 11, 1);
    tmPathGraph.addEdge(12, 13, 1);
    tmPathGraph.addEdge(12, 16, 1);
    tmPathGraph.addEdge(13, 14, 1);
    tmPathGraph.addEdge(13, 17, 1);
    tmPathGraph.addEdge(14, 15, 1);
    tmPathGraph.addEdge(14, 18, 1);
    tmPathGraph.addEdge(15, 19, 1);
    tmPathGraph.addEdge(16, 17, 1);
    tmPathGraph.addEdge(18, 19, 1);
    tmPathGraph.addEdge(20, 21, 1);
    tmPathGraph.addEdge(20, 23, 1);
    tmPathGraph.addEdge(21, 22, 1);
    tmPathGraph.addEdge(22, 23, 1);
    return tmPathGraph;
  }
}
