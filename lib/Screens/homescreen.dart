import 'package:add_to_google_wallet/widgets/add_to_google_wallet_button.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/levelselectionscreen.dart';
import 'package:mini_carpoolgame/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mini_carpoolgame/main.dart';
import 'package:uuid/uuid.dart';

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

    showSnackBar(BuildContext context, String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

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
              const SizedBox(
                height: 10,
              ),
              AddToGoogleWalletButton(
                pass: _examplePass,
                onSuccess: () => showSnackBar(context, "Success"),
                onCanceled: () => showSnackBar(context, "Action Cancelled"),
                onError: (Object error) =>
                    showSnackBar(context, error.toString()),
                // locale: const Locale("ja"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

final String passId = const Uuid().v4();
String passClass = "BCR2DN4T7XVJJQQ7";
const String issuerId = "3388000000022319113";
String issuerEmail = "abrsshwork@gmail.com";
final String pass = """ 
    {
      "iss": "$issuerEmail",
      "aud": "google",
      "typ": "savetowallet",
      "origins": [],
      "payload": {
        "genericObjects": [
          {
            {
              "id": "3388000000022319113.00022319113",
              "classId": "3388000000022319113.BCR2DN4T7XVJJQQ7",
              "logo": {
                "sourceUri": {
                  "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/pass_google_logo.jpg"
                },
                "contentDescription": {
                  "defaultValue": {
                    "language": "en-US",
                    "value": "LOGO_IMAGE_DESCRIPTION"
                  }
                }
              },
              "cardTitle": {
                "defaultValue": {
                  "language": "en-US",
                  "value": "Mini Carpool User"
                }
              },
              "subheader": {
                "defaultValue": {
                  "language": "en-US",
                  "value": "User"
                }
              },
              "header": {
                "defaultValue": {
                  "language": "en-US",
                  "value": "Abraham Daniel"
                }
              },
              "textModulesData": [
                {
                  "id": "level",
                  "header": "Level",
                  "body": "3"
                },
                {
                  "id": "car_type",
                  "header": "Car Type",
                  "body": "Electric"
                },
                {
                  "id": "emission_per_km",
                  "header": "Emission per Km",
                  "body": "0.5g/km"
                }
              ],
            }
          }
        ]
      }
    }
""";

final String _examplePass = """ 
    {
      "iss": "$issuerEmail",
      "aud": "google",
      "typ": "savetowallet",
      "origins": [],
      "payload": {
        "genericObjects": [
          {
            "id": "$issuerId.$passId",
            "classId": "$issuerId.$passClass",
            "genericType": "GENERIC_TYPE_UNSPECIFIED",
            "hexBackgroundColor": "#4285f4",
            "logo": {
              "sourceUri": {
                "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/pass_google_logo.jpg"
              }
            },
            "cardTitle": {
              "defaultValue": {
                "language": "en",
                "value": "Google I/O '22 [DEMO ONLY]"
              }
            },
            "subheader": {
              "defaultValue": {
                "language": "en",
                "value": "Attendee"
              }
            },
            "header": {
              "defaultValue": {
                "language": "en",
                "value": "Alex McJacobs"
              }
            },
            "barcode": {
              "type": "QR_CODE",
              "value": "$passId"
            },
            "heroImage": {
              "sourceUri": {
                "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/google-io-hero-demo-only.jpg"
              }
            },
            "textModulesData": [
              {
                "header": "POINTS",
                "body": "1234",
                "id": "points"
              }
            ]
          }
        ]
      }
    }
""";
