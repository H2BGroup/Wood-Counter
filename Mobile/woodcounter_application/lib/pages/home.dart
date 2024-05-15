import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/main.dart';
import 'package:woodcounter_application/pages/select_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const backgroundColor = Color.fromARGB(255, 8, 130, 42);

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
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1)),
            Text(translation.subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: 2)),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectImage()),
                );
              },
              child: Text(translation.startButton,
                  style: TextStyle(foreground: Paint() ..color = backgroundColor, fontSize: 40, fontWeight: FontWeight.bold)),
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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),

        backgroundColor: backgroundColor,
        elevation: 0,
        onTap: (i) => {
          MyApp.setLocale(context, Locale(locales[i]))
        },
      ),
    );
  }
}
