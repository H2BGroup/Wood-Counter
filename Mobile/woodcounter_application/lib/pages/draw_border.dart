import 'dart:io';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/select_image.dart';
import 'package:woodcounter_application/pages/select_plate.dart';

class DrawBorder extends StatefulWidget {
  const DrawBorder({super.key});

  @override
  State<DrawBorder> createState() => _DrawBorderState();
}

class _DrawBorderState extends State<DrawBorder> {
  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context)!.settings.arguments as File;

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
            Text('Obrysuj stos'),
            Image.file(image),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectImage()),
                      );
                    },
                    child: Text('Cofnij')),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectPlate(),
                          settings: RouteSettings(
                            arguments: image,
                          ),
                        ),
                      );
                }, child: Text('Dalej')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
