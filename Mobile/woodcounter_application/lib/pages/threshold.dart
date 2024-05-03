import 'dart:io';

import 'package:woodcounter_application/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/stack_length.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:woodcounter_application/calculations.dart';

class SetThreshold extends StatefulWidget {
  SetThreshold({super.key, required this.image, required this.platePosition});

  final File image;
  final Offset platePosition;

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
    Widget xd = FloodFillImage(
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
    );

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
            Text(translation.selectThreshold),
            xd,
            Slider(
              value: _threshold,
              max: 100,
              divisions: 100,
              label: _threshold.round().toString(),
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
            Column(
              children: woodPoints != null ? woodPoints.entries.map((e) => Text(e.key.dx.toStringAsFixed(2) + " " + e.key.dy.toStringAsFixed(2) + " "+ e.value.toString())).toList() : []
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(translation.returnButton)),
                ElevatedButton(onPressed: (){        
                      setState(() {
                        woodPoints.clear();
                        final FloodFillImageState? floodFillImageState = _floodFillImageKey.currentState;
                        if (floodFillImageState != null) {
                          floodFillImageState.clearSelection();
                        }
                      });
                    }, child: Text(translation.clearSelection)),
                ElevatedButton(
                    onPressed: stackArea != 0
                        ? () async {
                            var bigImage = await decodeImageFromList(widget.image.readAsBytesSync());
                            Map<Offset, double> scaledWoodPoints = Map<Offset, double>();
                            woodPoints.forEach((key, value) {
                              Offset scaledWoodPoint = scalePointToBiggerRes(bigImage.height, smallImageHeight, key);
                              scaledWoodPoints[scaledWoodPoint] = value;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StackLength(
                                    image: widget.image,
                                    platePosition: widget.platePosition,
                                    points: scaledWoodPoints),
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
