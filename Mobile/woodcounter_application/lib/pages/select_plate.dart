import 'dart:io';

import 'package:woodcounter_application/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/threshold.dart';

class SelectPlate extends StatefulWidget {
  const SelectPlate({super.key, required this.image});

  final File image;

  @override
  State<SelectPlate> createState() => _SelectPlateState();
}

class _SelectPlateState extends State<SelectPlate> {
  int plateArea = 0;

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
            const Text('Zaznacz tabliczkę'),
            FloodFillImage(
              imageProvider: FileImage(widget.image),
              fillColor: Colors.amber.withOpacity(0.9),
              avoidColor: [Colors.transparent],
              tolerance: 50,
              width: MediaQuery.of(context).size.width.toInt(),
              onFloodFillEnd: (image, p1) => setState(() {
                plateArea = p1;
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cofnij')),
                ElevatedButton(
                    onPressed: plateArea != 0
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SetThreshold(
                                    image: widget.image, plateArea: plateArea),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Dalej')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
