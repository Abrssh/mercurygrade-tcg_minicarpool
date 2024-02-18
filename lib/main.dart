import 'package:flutter/material.dart';
import 'package:mini_carpoolgame/Screens/homescreen.dart';
import 'package:mini_carpoolgame/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    if (state?._locale != null) {
      String? langCode = state!._locale!.languageCode;
      if (langCode == "en") {
        langCode = "ja";
      } else {
        langCode = "en";
      }
      state.setLocale(langCode);
    } else {
      state?.setLocale("en");
    }
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = const Locale("en");
  setLocale(String langCode) {
    setState(() {
      _locale = Locale(langCode);
      // debugPrint("Loc: $_locale");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mini CarPool Game',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        supportedLocales: L10n.all,
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        home: const HomeScreen());
  }
}
