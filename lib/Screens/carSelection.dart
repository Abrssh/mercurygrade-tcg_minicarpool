import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mini_carpoolgame/Screens/car_card.dart';

class CarSelectionScreen extends StatelessWidget {
  const CarSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;

    List<CarCard> carCards = [];
    carCards.add(const CarCard(
        emissionPerKm: 1,
        price: 0,
        carType: 1,
        imagePath: "assets/images/UI Assets/pl3j_xpfm_210723.jpg"));

    carCards.add(const CarCard(
        emissionPerKm: 0.5,
        price: 1,
        carType: 2,
        imagePath: "assets/images/UI Assets/519123-PIULME-178.jpg"));

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Select Level"),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.selectcar,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: deviceWidth * 0.08),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: carCards,
            ),
          ),
        ],
      ),
    );
  }
}
