import 'dart:async';
import 'dart:async' as tm;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Game/Actors/carspriteComponent.dart';
import 'package:mini_carpoolgame/Game/OverlayUI/statUI.dart';
import 'package:mini_carpoolgame/Game/path_finding.dart';
import 'package:mini_carpoolgame/Screens/carSelection.dart';
import 'package:mini_carpoolgame/Screens/homescreen.dart';
import 'package:mini_carpoolgame/Screens/levelselectionscreen.dart';
import 'package:mini_carpoolgame/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarPoolGame extends FlameGame with HasGameRef<CarPoolGame>, TapCallbacks {
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
  // final double xAxisSpriteAdjustment = -30;
  final double xAxisSpriteAdjustment = -40;

  double emissionInGrams = 0;
  int time = 0;
  late final FirstPassengerComp firstPassengerComp;
  late final SecondPassengerComp secondPassengerComp;
  // late final SpriteAnimationComponent firstPassengerComp;
  // late final SpriteAnimationComponent secondPassengerComp;
  bool firstPassengerBoarded = false, secondPassengerBoarded = false;
  bool firstDestinationArrived = false, secondDestinationArrived = false;

  // UI elements
  late final StatUIOverlay statUIOverlay;
  late GameMessageUIOverlay gameMessageUIOverlay;
  String passengerNum = "0", destinationArrivedNum = "0";
  bool firstTime = true;

  // Level related variables
  final String tileName;
  final int emissionInGramsLimit, level;

  // Used to recognize double tap and implement revert functionality
  final Duration _doubleTapThreshold = const Duration(milliseconds: 300);
  DateTime _lastTapTime = DateTime.now();
  List<List<int>> revertPoints = [];
  int currentRevertNum = 0;

  // Passenger movement control
  bool moveFirstPass = false, moveSecondPass = false;
  int firstPassBoar = 0, seconPassBoar = 0, firstPassArr = 0, secondPassArr = 0;
  bool reverse = false;

  // Button
  late SpriteButtonComponent nextLevel, upgradeCar, exitButton;
  late Sprite nextLevelImage, upgradeImage, gotoHome;

  CarPoolGame(
      {required this.tileName,
      required this.level,
      required this.emissionInGramsLimit});

  @override
  FutureOr<void> onLoad() async {
    _timer = tm.Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        // debugPrint("CurrentRevNum ${currentRevertNum.toString()}");
        if (firstPassengerBoarded && secondPassengerBoarded) {
          passengerNum = "2";
        } else if (firstPassengerBoarded || secondPassengerBoarded) {
          passengerNum = "1";
        } else {
          passengerNum = "0";
        }
        if (firstDestinationArrived && secondDestinationArrived) {
          destinationArrivedNum = "2";
        } else if (firstDestinationArrived || secondDestinationArrived) {
          destinationArrivedNum = "1";
        } else {
          destinationArrivedNum = "0";
        }

        if (firstTime) {
          if (buildContext != null) {
            statUIOverlay = StatUIOverlay(
                buildContext: buildContext!,
                destinationNum: destinationArrivedNum,
                emissionNum: emissionInGrams.toStringAsFixed(2),
                passengerNum: passengerNum,
                emissionLimit: emissionInGramsLimit.toString(),
                time: time.toString());
            add(statUIOverlay);
            firstTime = false;
          }
        }
        // debugPrint(
        //     "Emission: ${emissionInGrams.toString()} Time: ${time.toString()}");
        // debugPrint(
        //     "Da: ${firstDestinationArrived.toString()} Sa: ${secondDestinationArrived.toString()} Fp: ${firstPassengerBoarded.toString()} Sp: ${secondPassengerBoarded.toString()}");
        if (emissionInGrams > emissionInGramsLimit &&
            (!firstDestinationArrived || !secondDestinationArrived)) {
          debugPrint("Game Over");
          gameMessageUIOverlay = GameMessageUIOverlay(
              buildContext: buildContext!,
              gameMessage:
                  AppLocalizations.of(buildContext!)!.youWentOverCarbon,
              time: time.toDouble(),
              success: false);
          add(gameMessageUIOverlay);
          await Future.delayed(
            const Duration(seconds: 3),
            () {
              if (_timer.isActive) {
                _timer.cancel();
                Navigator.pushReplacement(
                    buildContext!,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(
                        textDirection: TextDirection.ltr,
                        game: CarPoolGame(
                            emissionInGramsLimit: emissionInGramsLimit,
                            tileName: tileName,
                            level: level),
                        overlayBuilderMap: {
                          'Overlay': (BuildContext context, CarPoolGame game) {
                            return Container(
                              color: Colors.greenAccent,
                              child: Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: const Icon(Icons.play_arrow))
                                ],
                              ),
                            );
                          },
                        },
                      ),
                    ));
                // Flame.device.setPortrait();
                // Navigator.pushReplacement(
                //     game.buildContext!,
                //     MaterialPageRoute(
                //       builder: (context) => const HomeScreen(),
                //     ));
              }
            },
          );
        } else if (firstDestinationArrived &&
            secondDestinationArrived &&
            emissionInGrams <= emissionInGramsLimit) {
          debugPrint("Level Passed");
          gameMessageUIOverlay = GameMessageUIOverlay(
              buildContext: buildContext!,
              gameMessage: AppLocalizations.of(buildContext!)!
                  .sustainabilityGoalAchieved,
              time: time.toDouble(),
              success: true);
          add(gameMessageUIOverlay);
          await Future.delayed(
            const Duration(milliseconds: 1500),
            () {
              nextLevel = SpriteButtonComponent(
                button: nextLevelImage,
                position: Vector2(400, 250),
                size: Vector2(50, 50),
                onPressed: () {
                  debugPrint("Next level Pressed");
                  Flame.device.setPortrait();
                  Navigator.pushReplacement(
                      game.buildContext!,
                      MaterialPageRoute(
                        builder: (context) => const LevelSelectionScreen(),
                      ));
                },
              );
              upgradeCar = SpriteButtonComponent(
                button: upgradeImage,
                position: Vector2(300, 250),
                size: Vector2(50, 50),
                onPressed: () {
                  debugPrint("Upgrade Car Pressed");
                  Flame.device.setPortrait();
                  Navigator.pushReplacement(
                      game.buildContext!,
                      MaterialPageRoute(
                        builder: (context) => const CarSelectionScreen(),
                      ));
                },
              );
              if (_timer.isActive) {
                _timer.cancel();
              }
              addAll([nextLevel, upgradeCar]);
            },
          );
        } else {
          time++;
        }
      },
    );
    debugPrint("Game Started");

    // Loading Images and Tiles
    Sprite carSprite;
    if (HomeScreen.carSelected == 1) {
      carSprite = await game.loadSprite(Global.carPlayerSprite2);
    } else {
      carSprite = await game.loadSprite(Global.carPlayerSprite3);
    }
    // Sprite carSprite = await game.loadSprite(Global.carPlayerSprite);
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
    // firstPassengerComp = SpriteAnimationComponent(
    //     position:
    //         Vector2(spawnPointsPassengers[0].x, spawnPointsPassengers[0].y),
    //     animation: _spriteAnimationCreation(
    //         Global.passengerNunSprite, 6, 0.05, 48 * 64));
    // secondPassengerComp = SpriteAnimationComponent(
    // position:
    //     Vector2(spawnPointsPassengers[1].x, spawnPointsPassengers[1].y),
    // animation: _spriteAnimationCreation(
    //     Global.passengerNunSpriteblue, 6, 0.05, 48 * 64));

    firstPassengerComp = FirstPassengerComp(
        spawnPointsPassengers[0].x, spawnPointsPassengers[0].y, firPassSpr);
    secondPassengerComp = SecondPassengerComp(
        spawnPointsPassengers[1].x, spawnPointsPassengers[1].y, secPassSpr);
    // increase the size of the passenger
    firstPassengerComp.width = 50;
    firstPassengerComp.height = 50;
    secondPassengerComp.width = 50;
    secondPassengerComp.height = 50;
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

    // Creating a sprite button
    nextLevelImage = await game.loadSprite(Global.nextLevelButtonImage);
    upgradeImage = await game.loadSprite(Global.upgradeButtonImage);
    gotoHome = await game.loadSprite(Global.goToHomeImage);
    exitButton = SpriteButtonComponent(
      button: gotoHome,
      position: Vector2(700, 320),
      size: Vector2(50, 50),
      onPressed: () {
        debugPrint("Exit Button Pressed");
        if (_timer.isActive) {
          _timer.cancel();
        }
        Flame.device.setPortrait();
        Navigator.pushReplacement(
            game.buildContext!,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      },
    );
    add(exitButton);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // reversePassengerBoarded(1, firstPassengerComp);
    // debugPrint(
    //     "Fi: ${firstPassBoar.toString()} ${seconPassBoar.toString()} ${firstPassArr} $secondPassArr");
    // debugPrint("Df: $firstDestinationArrived $secondDestinationArrived");
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
    if (!firstTime) {
      statUIOverlay.emissionNum = emissionInGrams.toStringAsFixed(2);
      statUIOverlay.emissionLimit = emissionInGramsLimit.toString();
      statUIOverlay.passengerNum = passengerNum;
      statUIOverlay.destinationNum = destinationArrivedNum;
      statUIOverlay.time = time.toString();
    }

    if (firstDestinationArrived && moveFirstPass) {
      Vector2 newVelocity;
      double dirX = 0.0;
      double dirY = 0.0;
      dirX -= 20;
      newVelocity = Vector2(dirX, dirY);
      firstPassengerComp.position += newVelocity * dt;
    }
    if (secondDestinationArrived && moveSecondPass) {
      Vector2 newVelocity;
      double dirX = 0.0;
      double dirY = 0.0;
      dirX -= 20;
      newVelocity = Vector2(dirX, dirY);
      secondPassengerComp.position += newVelocity * dt;
    }
    super.update(dt);
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

      if (!reverse) {
        // check if you have reached a passenger
        if (!firstPassengerBoarded || !secondPassengerBoarded) {
          Vector2 adjustedPos = Vector2(
              spawnPointsPassengers[0].x + xAxisSpriteAdjustment,
              spawnPointsPassengers[0].y + yAxisSpriteAdjustment);
          Vector2 adjustedPos2 = Vector2(
              spawnPointsPassengers[1].x + xAxisSpriteAdjustment,
              spawnPointsPassengers[1].y + yAxisSpriteAdjustment);
          if (carSpriteComponent.position.distanceTo(adjustedPos) < 45) {
            if (!firstPassengerBoarded) {
              firstPassBoar = currentRevertNum;
              firstPassengerBoarded = true;
              firstPassengerComp.makeTransparent();
            }
          }
          if (carSpriteComponent.position.distanceTo(adjustedPos2) < 45) {
            if (!secondPassengerBoarded) {
              secondPassengerBoarded = true;
              secondPassengerComp.makeTransparent();
              seconPassBoar = currentRevertNum;
            }
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
              firstPassengerBoarded &&
              !firstDestinationArrived) {
            firstDestinationArrived = true;
            firstPassengerComp.position.x = carSpriteComponent.position.x;
            firstPassengerComp.position.y = carSpriteComponent.position.y;
            passengerDestinationaction(firstPassengerComp, dt, 1);
            firstPassArr = currentRevertNum;
          }
          if ((carSpriteComponent.position.distanceTo(adjustedPos2) < 45) &&
              secondPassengerBoarded &&
              !secondDestinationArrived) {
            secondDestinationArrived = true;
            secondPassengerComp.position.x = carSpriteComponent.position.x;
            secondPassengerComp.position.y = carSpriteComponent.position.y;
            passengerDestinationaction(secondPassengerComp, dt, 2);
            secondPassArr = currentRevertNum;
          }
        }
      }

      if ((carSpriteComponent.position.distanceTo(finalDestination) < 10)) {
        finalDestinationReached = true;
        totalNodesInPath.clear();
        currentNode = 0;
        destinationReached = true;
        debugPrint('Car reached the final destination.');
        if (reverse) {
          reverse = false;
        }
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (finalDestinationReached) {
      // debugPrint("Touch is allowed ${carSpriteComponent.position.toString()}");
      Vector2 touchposition =
          Vector2(event.localPosition.x, event.localPosition.y);

      int cNode = 0, destinationNode = 0;
      bool movementPointTouched = false;

      // identifies current node using car position and destination node using touch input
      for (var touchPoint in touchPoints) {
        if ((touchposition - touchPoint).length < 30) {
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
        // Add revert data
        List<int> revertData = [destinationNode, cNode];
        revertPoints.add(revertData);
        currentRevertNum++;
        Map<int, dynamic> returnedMap =
            returnTheBestPath(cNode, destinationNode);
        // debugPrint("Map: ${revertPoints.toString()}");
        List<Vector2> nodesReturned = returnedMap[0];
        // Applies proper Emission rate
        if (HomeScreen.carSelected == 1) {
          emissionInGrams += int.parse(returnedMap[1].toString());
        } else {
          int emiss = int.parse(returnedMap[1].toString());
          double dbEmiss = emiss / 2;
          emissionInGrams += dbEmiss;
        }
        // debugPrint("Emission: ${emissionInGrams.toString()} ${returnedMap[1]}");
        // debugPrint("Path ${nodesReturned.join(" -> ")}");
        // debugPrint("TouchPoints ${touchPoints.join(" -> ")}");
        totalNodesInPath.addAll(nodesReturned);
        // Adds Emission
        // emissionInGrams += totalNodesInPath.length - 1;
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
  }

  // Check for double tap
  // Used to revert one step
  @override
  void onTapUp(TapUpEvent event) {
    final currentTime = DateTime.now();
    if (currentTime.difference(_lastTapTime) < _doubleTapThreshold) {
      if (finalDestinationReached) {
        if (currentRevertNum > 0) {
          if (currentRevertNum == firstPassBoar) {
            reversePassengerBoarded(1);
            firstPassBoar = 0;
          }
          if (currentRevertNum == seconPassBoar) {
            reversePassengerBoarded(2);
            seconPassBoar = 0;
          }
          if (currentRevertNum == firstPassArr) {
            reversePassengerGotToDestination(1);
            firstPassArr = 0;
          }
          if (currentRevertNum == secondPassArr) {
            reversePassengerGotToDestination(2);
            secondPassArr = 0;
          }
          --currentRevertNum;
          reverse = true;
          destinationReached = false;
          finalDestinationReached = false;
          Map<int, dynamic> returnedMap = returnTheBestPath(
              revertPoints[currentRevertNum][0],
              revertPoints[currentRevertNum][1]);
          List<Vector2> nodesReturned = returnedMap[0];
          emissionInGrams -= int.parse(returnedMap[1].toString());
          totalNodesInPath.addAll(nodesReturned);
          destination = Vector2(
              totalNodesInPath[currentNode].x, totalNodesInPath[currentNode].y);

          finalDestination = Vector2(
              totalNodesInPath[totalNodesInPath.length - 1].x,
              totalNodesInPath[totalNodesInPath.length - 1].y);
          velocity = (destination - carSpriteComponent.position).normalized() *
              moveSpeed;
          revertPoints.removeLast();
        }
      }
    }
    _lastTapTime = currentTime;
  }

  Map<int, dynamic> returnTheBestPath(int startNode, int endNode) {
    Map<int, dynamic> returnMap = {};
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
    returnMap[0] = pathNodes;
    returnMap[1] = pathGraph.calculateEmission(nodesReturned);
    debugPrint("Start: ${startNode.toString()} End: ${endNode.toString()}");
    debugPrint("Short Path: ${nodesReturned.join(" -> ")}");
    return returnMap;
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

  void passengerDestinationaction(
      SpriteComponent spriteComponent, double dt, int passType) {
    debugPrint("Called ");
    spriteComponent.makeOpaque();
    switch (passType) {
      case 1:
        moveFirstPass = true;
      case 2:
        moveSecondPass = true;
        break;
      default:
    }
    Future.delayed(const Duration(seconds: 2)).then((value) {
      debugPrint("Sprite Disappeared");
      spriteComponent.makeTransparent();
      switch (passType) {
        case 1:
          moveFirstPass = false;
        case 2:
          moveSecondPass = false;
          break;
        default:
      }
    });
  }

  void reversePassengerBoarded(int passType) {
    switch (passType) {
      case 1:
        firstPassengerBoarded = false;
        firstPassengerComp.position.x = spawnPointsPassengers[0].x;
        firstPassengerComp.position.y = spawnPointsPassengers[0].y;
        firstPassengerComp.makeOpaque();
      case 2:
        secondPassengerBoarded = false;
        secondPassengerComp.position.x = spawnPointsPassengers[1].x;
        secondPassengerComp.position.y = spawnPointsPassengers[1].y;
        secondPassengerComp.makeOpaque();
      default:
    }
  }

  void reversePassengerGotToDestination(int passType) {
    switch (passType) {
      case 1:
        firstDestinationArrived = false;
      case 2:
        secondDestinationArrived = false;
        break;
      default:
    }
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
}
