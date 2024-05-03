import 'dart:io';

import 'package:woodcounter_application/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/stack_length.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;
    Widget xd = FloodFillImage(
      key: _floodFillImageKey,
      imageProvider: FileImage(widget.image),
      fillColor: Colors.amber,
      avoidColor: [Colors.transparent],
      tolerance: _threshold.toInt(),
      onFloodFillEnd: (image, maskSize) => setState(() {
        stackArea = maskSize;
        smallImageHeight = image.height;
      }),
      onFloodFillStart: (position, image) => setState(() {
        woodPosition = position;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(translation.returnButton)),
                ElevatedButton(
                    onPressed: stackArea != 0
                        ? () async {
                            var bigImage = await decodeImageFromList(widget.image.readAsBytesSync());
                            double scale = bigImage.height / smallImageHeight;
                            print(scale);
                            print(woodPosition);
                            print(woodPosition!*scale);
                            Offset scaledWoodPosition = Offset(
                              (woodPosition!.dx.floorToDouble() * scale)
                                  .floorToDouble(),
                              (woodPosition!.dy.floorToDouble() * scale)
                                  .floorToDouble());
                            print(scaledWoodPosition);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StackLength(
                                    image: widget.image,
                                    platePosition: widget.platePosition,
                                    points: {scaledWoodPosition: _threshold}),
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
