import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en',''),
        Locale('pl', ''),
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.green
      ),
      home: const HomePage(),
    );
  }
}
