import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/main.dart';
import 'package:woodcounter_application/pages/select_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;
    var locales = [
      'pl',
      'en'
    ];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/stack.png',
              height: 300,
            ),
            Text(translation.appTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            Text(translation.subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 25)),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectImage()),
                );
              },
              child: Text(translation.startButton,
                  style: TextStyle(foreground: Paint() ..color = Colors.green, fontSize: 40)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/polish.png',
                height: 40,
              ),
              label: 'Polski'),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/british.png',
                height: 40,
              ),
              label: 'English'),
        ],
        backgroundColor: Colors.green,
        elevation: 0,
        onTap: (i) => {
          MyApp.setLocale(context, Locale(locales[i]))
        },
      ),
    );
  }
}
