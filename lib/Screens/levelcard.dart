import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/gamedetailScreen.dart';

class LevelCard extends StatelessWidget {
  final String levelName;
  final String levelDetails;
  final String imagePath;

  const LevelCard(
      {super.key,
      required this.levelName,
      required this.levelDetails,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;

    return SizedBox(
      height: deviceHeight * 0.8,
      width: deviceWidth * 1,
      child: Card(
        color: Colors.lightGreen[50],
        key: key,
        margin: EdgeInsets.all(deviceWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: deviceHeight * 0.4,
              width: deviceWidth * 0.8,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    levelName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.15,
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  Text(
                    levelDetails,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: deviceWidth * 0.05,
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameDetailScreen(),
                      ));
                },
                child: Text(
                  "Play",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: deviceWidth * 0.15,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
