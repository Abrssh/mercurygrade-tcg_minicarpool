import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/levelselectionscreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game App"),
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.account_circle)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/backGroundImage.jpg"),
                fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LevelSelectionScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20)),
                child: Text(
                  "Start Game",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: deviceWidth * 0.10),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "Change Language",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: deviceWidth * 0.06),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
