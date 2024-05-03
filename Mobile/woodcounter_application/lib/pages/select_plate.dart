import 'dart:io';

import 'package:woodcounter_application/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/threshold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:woodcounter_application/calculations.dart';

class SelectPlate extends StatefulWidget {
  const SelectPlate({super.key, required this.image});

  final File image;

  @override
  State<SelectPlate> createState() => _SelectPlateState();
}

class _SelectPlateState extends State<SelectPlate> {
  int plateArea = 0;
  int smallImageHeight = 0;
  Offset? platePosition;
  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(translation.appTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translation.selectPlate),
            FloodFillImage(
              imageProvider: FileImage(widget.image),
              fillColor: Colors.amber.withOpacity(0.9),
              avoidColor: [Colors.transparent],
              tolerance: 50,
              onFloodFillEnd: (image, maskSize) => setState(() {
                plateArea = maskSize;
                print(plateArea);
                smallImageHeight = image.height;
              }),
              onFloodFillStart: (position, image) => setState(() {
                platePosition = position;
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(translation.returnButton)),
                ElevatedButton(
                    onPressed: plateArea != 0
                        ? () async {
                            var bigImage = await decodeImageFromList(widget.image.readAsBytesSync());
                            Offset scaledPlatePosition = scalePointToBiggerRes(bigImage.height, smallImageHeight, platePosition!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SetThreshold(
                                    image: widget.image,
                                    platePosition: scaledPlatePosition),
                              ),
                            );
                          }
                        : null,
                    child: Text(translation.nextButton)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
