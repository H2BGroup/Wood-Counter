import 'dart:io';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/home.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context)!.settings.arguments as File;
    double result = 0;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('WoodCounter', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(image),
            Text('Podaj długość stosu'),
            Text('$result'),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: Text('Powrót do ekranu głównego')),
          ],
        ),
      ),
    );
  }
}
