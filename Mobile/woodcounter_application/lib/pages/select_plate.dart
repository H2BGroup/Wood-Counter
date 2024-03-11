import 'dart:io';

import 'package:woodcounter_application/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/draw_border.dart';
import 'package:woodcounter_application/pages/threshold.dart';

class SelectPlate extends StatefulWidget {
  const SelectPlate({super.key});

  @override
  State<SelectPlate> createState() => _SelectPlateState();
}

class _SelectPlateState extends State<SelectPlate> {
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
            Text('Zaznacz tabliczkę'),
            FloodFillImage(
              imageProvider: FileImage(image),
              fillColor: Colors.amber.withOpacity(0.9),
              avoidColor: [Colors.transparent],
              tolerance: 50,
              width: MediaQuery.of(context).size.width.toInt(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DrawBorder(),
                          settings: RouteSettings(
                            arguments: image,
                          ),
                        ),
                      );
                    },
                    child: Text('Cofnij')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetThreshold(),
                          settings: RouteSettings(
                            arguments: image,
                          ),
                        ),
                      );
                    },
                    child: Text('Dalej')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
