import 'dart:io';

import 'package:woodcounter_application/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/threshold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:woodcounter_application/calculations.dart';

const double magnifierRadius = 50;

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
  Offset dragGesturePosition = Offset.zero;
  bool showMagnifier = false;
  final GlobalKey<FloodFillImageState> _floodFillImageKey = GlobalKey();

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
            Stack(
              children: <Widget>[
                GestureDetector(
                  onPanStart: (DragStartDetails details) {
                    setState(() {
                      showMagnifier = true;
                    });
                  },
                  onPanUpdate: (DragUpdateDetails details) => setState(() {
                    dragGesturePosition = details.localPosition;
                  }),
                  onPanEnd: (DragEndDetails details) {
                    setState(() {
                      showMagnifier = false;
                      final FloodFillImageState? floodFillImageState =
                          _floodFillImageKey.currentState;
                      if (floodFillImageState != null) {
                        floodFillImageState.emulateTap(dragGesturePosition);
                      }
                    });
                  },
                  onTapDown: (TapDownDetails details) {
                    //empty but need to be defined to distinguish tap from drag
                  },
                  onTapUp: (TapUpDetails details) {
                    //empty but need to be defined to distinguish tap from drag
                  },
                  child: FloodFillImage(
                    key: _floodFillImageKey,
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
                ),
                if (showMagnifier)
                  Positioned(
                      left: dragGesturePosition.dx,
                      top: dragGesturePosition.dy,
                      child: RawMagnifier(
                          focalPointOffset:
                              const Offset(-magnifierRadius, -magnifierRadius),
                          decoration: const MagnifierDecoration(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.blue, width: 3))),
                          size: const Size(
                              2 * magnifierRadius, 2 * magnifierRadius),
                          magnificationScale: 3,
                          child: Stack(
                            children: [
                              Positioned(
                                left: magnifierRadius,
                                top: magnifierRadius,
                                child: Container(
                                  width: 1,
                                  height: magnifierRadius,
                                  color: Colors.red, // Kolor krzyżyka
                                ),
                              ),
                              Positioned(
                                top: magnifierRadius,
                                left: magnifierRadius,
                                child: Container(
                                  width: magnifierRadius,
                                  height: 1,
                                  color: Colors.red, // Kolor krzyżyka
                                ),
                              ),
                              Positioned(
                                left: magnifierRadius,
                                child: Container(
                                  width: 1,
                                  height: magnifierRadius,
                                  color: Colors.red, // Kolor krzyżyka
                                ),
                              ),
                              Positioned(
                                top: magnifierRadius,
                                child: Container(
                                  width: magnifierRadius,
                                  height: 1,
                                  color: Colors.red, // Kolor krzyżyka
                                ),
                              ),
                            ],
                          )))
              ],
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
                            var bigImage = await decodeImageFromList(
                                widget.image.readAsBytesSync());
                            Offset scaledPlatePosition = scalePointToBiggerRes(
                                bigImage.height,
                                smallImageHeight,
                                platePosition!);
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
