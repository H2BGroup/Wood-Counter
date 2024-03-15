import 'dart:io';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/select_plate.dart';

class DrawBorder extends StatefulWidget {
  const DrawBorder({super.key, required this.image});

  final File image;

  @override
  State<DrawBorder> createState() => _DrawBorderState();
}

class _DrawBorderState extends State<DrawBorder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('WoodCounter', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Obrysuj stos'),
            Image.file(widget.image),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cofnij')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SelectPlate(image: widget.image),
                        ),
                      );
                    },
                    child: const Text('Dalej')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
