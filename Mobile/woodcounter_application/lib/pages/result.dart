import 'dart:io';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/home.dart';

class Result extends StatelessWidget {
  const Result({super.key, required this.image, required this.stackVolume});

  final File image;
  final double stackVolume;

  @override
  Widget build(BuildContext context) {
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
            Text('Objętość stosu'),
            Text(stackVolume.toStringAsFixed(2)),
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
