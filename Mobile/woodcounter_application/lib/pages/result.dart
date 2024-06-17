import 'dart:io';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Result extends StatelessWidget {
  const Result({super.key, required this.image, required this.stackVolume, required this.error});

  final File image;
  final double stackVolume;
  final double error;

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(translation.appTitle, 
        style: TextStyle(fontWeight: FontWeight.w900, foreground: Paint() ..color = Colors.white, letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 130, 42),
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(image),
            Text(translation.stackVolume, style: TextStyle(fontWeight: FontWeight.bold, foreground: Paint() ..color = Colors.white, fontSize: 16)),
            RichText(text: TextSpan(
            children: 
            [TextSpan(text: stackVolume.toStringAsFixed(2) + " m"),
            TextSpan(text: "3", style: TextStyle(fontFeatures: [FontFeature.superscripts()])),
            ], 
            style: TextStyle(fontWeight: FontWeight.bold, foreground: Paint() ..color = Colors.white, fontSize: 16)),
            ), 
            Text(translation.error, style: TextStyle(fontWeight: FontWeight.bold, foreground: Paint() ..color = Colors.white, fontSize: 16)),
            RichText(text: TextSpan(
            children:[
              TextSpan(text: "${(stackVolume-(stackVolume*error/100)).toStringAsFixed(2)} - ${(stackVolume+(stackVolume*error/100)).toStringAsFixed(2)} m"),
              TextSpan(text: "3", style: TextStyle(fontFeatures: [FontFeature.superscripts()])),
              TextSpan(text: " (${error.toStringAsFixed(2)}%)")
            ],
            style: TextStyle(fontWeight: FontWeight.bold, foreground: Paint() ..color = Colors.white, fontSize: 16))
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: Text(translation.returnToHomePage, style: TextStyle(foreground: Paint() ..color = Color.fromARGB(255, 8, 130, 42), fontWeight: FontWeight.w900, fontSize: 18))),
          ],
        ),
      ),
    );
  }
}
