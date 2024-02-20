import 'dart:async';

import 'package:add_to_google_wallet/widgets/add_to_google_wallet_button.dart';
import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarCard extends StatefulWidget {
  final double emissionPerKm, price;
  final String imagePath;
  // 1 means gas car and 2 electric car
  final int carType;

  const CarCard(
      {super.key,
      required this.emissionPerKm,
      required this.price,
      required this.carType,
      required this.imagePath});

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  late Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var deviceHeight = deviceSize.height;
    var deviceWidth = deviceSize.width;
    debugPrint("CarType: ${widget.carType} ${HomeScreen.carSelected}");

    showSnackBar(BuildContext context, String text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }

    return SizedBox(
      height: deviceHeight * 0.85,
      width: deviceWidth * 1,
      child: Card(
        color: const Color.fromARGB(255, 233, 239, 227),
        margin: EdgeInsets.all(deviceWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagePath,
              height:
                  widget.carType == 1 ? deviceHeight * 0.2 : deviceHeight * 0.4,
              // height:deviceHeight*0.4,
              width: deviceWidth * 0.9,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    widget.carType == 1
                        ? AppLocalizations.of(context)!.gascar
                        : AppLocalizations.of(context)!.electricar,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.09,
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.emission}: ${widget.emissionPerKm}  g/KM",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: deviceWidth * 0.08,
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.price}: ${widget.price == 0 ? AppLocalizations.of(context)!.free : "${widget.price} \$"}",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: deviceWidth * 0.08,
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: widget.carType != HomeScreen.carSelected
                    ? () async {
                        setState(() {
                          HomeScreen.carSelected = widget.carType;
                          SharedPreferences.getInstance().then((value) {
                            value.setInt("carSelected", widget.carType);
                          });
                        });
                      }
                    : null,
                child: Text(
                  AppLocalizations.of(context)!.choose,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: deviceWidth * 0.10,
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            widget.carType == 2
                ? widget.carType == HomeScreen.carSelected
                    ? AddToGoogleWalletButton(
                        pass: electricPass,
                        onSuccess: () => showSnackBar(context, "Success"),
                        onCanceled: () =>
                            showSnackBar(context, "Action Cancelled"),
                        onError: (Object error) =>
                            showSnackBar(context, error.toString()),
                        // locale: const Locale("ja"),
                      )
                    : const SizedBox()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

final String passId = const Uuid().v4();
String passClass = "BCR2DN4T7XVJJQQ7";
String passClass2 = "ElectricCar";
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
              "language": "en-US",
              "value": "Electric Car"
            }
          },
          "subheader": {
            "defaultValue": {
              "language": "en-US",
              "value": "Owner"
            }
          },
          "header": {
            "defaultValue": {
              "language": "en-US",
              "value": "Abrham Daniel2"
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
                "id": "car_type",
                "header": "Car Type",
                "body": "Electric"
              },
              {
                "id": "emission",
                "header": "Emission",
                "body": "0.5 g/km"
              }
            ]
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
              }, "contentDescription": {
              "defaultValue": {
                "language": "en-US",
                "value": "$passId"
              }
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
                "id": "car_type",
                "header": "Car Type",
                "body": "Electric"
              },
              {
                "id": "emission",
                "header": "Emission",
                "body": "0.5 g/km"
              }
            ]
          }
        ]
      }
    }
""";

final String pass2 = """
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
          "hexBackgroundColor": "#40516d",
          "logo": {
            "sourceUri": {
              "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/pass_google_logo.jpg"
            }
          },
          "cardTitle": {
            "defaultValue": {
              "language": "en-US",
              "value": "Electric Car"
            }
          },
          "subheader": {
            "defaultValue": {
              "language": "en-US",
              "value": "Owner"
            }
          },
          "header": {
            "defaultValue": {
              "language": "en-US",
              "value": "Abrham Daniel"
            }
          }, "subheader": {
            "defaultValue": {
              "language": "en-US",
              "value": "Owner"
            }
          },
          "header": {
            "defaultValue": {
              "language": "en-US",
              "value": "Abrham Daniel"
            }
          },
          "barcode": {
            "type": "QR_CODE",
            "value": "$passId"
          },
          "textModulesData": [
            {
              "id": "car_type",
              "header": "Car Type",
              "body": "Electric"
            },
            {
              "id": "emission",
              "header": "Emission",
              "body": "0.5 g/km"
            }
          ]
        }
      ]
    }
  }
  """;

final String electricPass = """
  {
    "iss": "$issuerEmail",
    "aud": "google",
    "typ": "savetowallet",
    "origins": [],
    "payload": {
      "genericObjects": [
        {
          "id": "$issuerId.$passId",
          "classId": "$issuerId.$passClass2",
          "logo": {
            "sourceUri": {
              "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/pass_google_logo.jpg"
            }
          },
          "cardTitle": {
            "defaultValue": {
              "language": "en-US",
              "value": "Electric Car"
            }
          },
          "subheader": {
            "defaultValue": {
              "language": "en-US",
              "value": "Owner"
            }
          },
          "header": {
            "defaultValue": {
              "language": "en-US",
              "value": "Abrham Daniel"
            }
          },
          "textModulesData": [
            {
              "id": "car_type",
              "header": "Car Type",
              "body": "Electric"
            },
            {
              "id": "emission",
              "header": "Emission",
              "body": "0.5 g/km"
            }
          ],
          "barcode": {
            "type": "QR_CODE",
            "value": "https://barcode.tec-it.com/barcode.ashx?data=You+own+an+Electric+Car&code=MobileQRCode&eclevel=L",
            "alternateText": "Game Website"
          },
          "hexBackgroundColor": "#40516d",
          "heroImage": {
            "sourceUri": {
              "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/google-io-hero-demo-only.jpg"
            }
          }
        }
      ]
    }
  }
  """;
