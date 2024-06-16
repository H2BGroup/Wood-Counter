import 'dart:io';

import 'package:woodcounter_application/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/stack_length.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:woodcounter_application/calculations.dart';

class SetThreshold extends StatefulWidget {
  SetThreshold({super.key, required this.image, required this.platePosition, required this.plateScale});

  final File image;
  final Offset platePosition;
  final double plateScale;

  @override
  State<SetThreshold> createState() => _SetThresholdState();
}

class _SetThresholdState extends State<SetThreshold> {
  double _threshold = 20;
  int stackArea = 0;
  int smallImageHeight = 0;
  Offset? woodPosition;
  final GlobalKey<FloodFillImageState> _floodFillImageKey = GlobalKey();
  Map<Offset, double> woodPoints = new Map<Offset, double>();

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(translation.appTitle,
            style: TextStyle(fontWeight: FontWeight.w900, foreground: Paint() ..color = Colors.white, letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 8, 130, 42),
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translation.selectThreshold,
            style: TextStyle(fontWeight: FontWeight.bold, foreground: Paint() ..color = Colors.white, fontSize: 22)),
            FloodFillImage(
              key: _floodFillImageKey,
              imageProvider: FileImage(widget.image),
              fillColor: Colors.amber,
              avoidColor: [Colors.transparent],
              tolerance: _threshold.toInt(),
              keepMasks: true,
              onFloodFillEnd: (image, maskSize) => setState(() {
                stackArea = maskSize;
                smallImageHeight = image.height;
              }),
              onFloodFillStart: (position, image) => setState(() {
                woodPosition = position;
                woodPoints[position] = _threshold;
              }),
            ),
            Slider(
              value: _threshold,
              max: 100,
              divisions: 100,
              label: _threshold.round().toString(),
              activeColor: Colors.green[900],
              onChanged: (double value) {
                setState(
                  () {
                    _threshold = value;
                  },
                );
              },
              onChangeEnd: (value) {
                final FloodFillImageState? floodFillImageState =
                    _floodFillImageKey.currentState;
                if (floodFillImageState != null) {
                  floodFillImageState.update();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(translation.returnButton, style: TextStyle(foreground: Paint() ..color = Color.fromARGB(255, 8, 130, 42), fontWeight: FontWeight.w900, fontSize: 18))),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        woodPoints.clear();
                        final FloodFillImageState? floodFillImageState =
                            _floodFillImageKey.currentState;
                        if (floodFillImageState != null) {
                          floodFillImageState.clearSelection();
                          stackArea = 0;
                        }
                      });
                    },
                    child: Text(translation.clearSelection, style: TextStyle(foreground: Paint() ..color = Color.fromARGB(255, 8, 130, 42), fontWeight: FontWeight.w900, fontSize: 18))),
                ElevatedButton(
                    onPressed: stackArea != 0
                        ? () async {
                            var bigImage = await decodeImageFromList(
                                widget.image.readAsBytesSync());
                            Map<Offset, double> scaledWoodPoints =
                                Map<Offset, double>();
                            woodPoints.forEach((key, value) {
                              Offset scaledWoodPoint = scalePointToBiggerRes(
                                  bigImage.height, smallImageHeight, key);
                              scaledWoodPoints[scaledWoodPoint] = value;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StackLength(
                                    image: widget.image,
                                    platePosition: widget.platePosition,
                                    points: scaledWoodPoints,
                                    plateScale: widget.plateScale),
                              ),
                            );
                          }
                        : null,
                    child: Text(translation.nextButton, style: TextStyle(foreground: Paint() ..color = Color.fromARGB(255, 8, 130, 42), fontWeight: FontWeight.w900, fontSize: 18))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
