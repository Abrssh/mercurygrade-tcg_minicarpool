import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/levelselectionscreen.dart';
import 'package:mini_carpoolgame/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mini_carpoolgame/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.miniCarpool),
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
                image: AssetImage(Global.backGroundImageloc),
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
                  AppLocalizations.of(context)!.startGame,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: deviceWidth * 0.10),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Flame.device.setPortrait();
                      MyApp.setLocale(context);
                      // debugPrint("Change Lang");
                    });
                  },
                  child: Text(
                    // "Change Language",
                    AppLocalizations.of(context)!.changeLanguage,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: deviceWidth * 0.06),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
