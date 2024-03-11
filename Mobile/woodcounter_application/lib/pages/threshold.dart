import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:woodcounter_application/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/select_plate.dart';
import 'package:woodcounter_application/pages/stack_length.dart';

class SetThreshold extends StatefulWidget {
  const SetThreshold({super.key});

  @override
  State<SetThreshold> createState() => _SetThresholdState();
}

class _SetThresholdState extends State<SetThreshold> {
  double _threshold = 20;
  late Offset pozycja;


  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context)!.settings.arguments as File;
    final Size windowSize = MediaQueryData.fromWindow(ui.window).size;
    late Offset screenOffset =
        Offset(windowSize.width / 2, windowSize.height / 2);
    pozycja = screenOffset;
    ui.Image photo;



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
            Text('Dostosuj zakres pomiaru'),
            FloodFillImage(
                imageProvider: FileImage(image),
                fillColor: Colors.amber,
                avoidColor: [Colors.transparent],
                tolerance: _threshold.toInt(),
                width: MediaQuery.of(context).size.width.toInt(),
                ),
            Slider(
              value: _threshold,
              max: 100,
              label: _threshold.round().toString(),
              onChanged: (double value) {
                setState(
                  () {
                    _threshold = value;
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectPlate(),
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
                          builder: (context) => const StackLength(),
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
