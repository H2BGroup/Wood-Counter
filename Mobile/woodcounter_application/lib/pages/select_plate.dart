import 'dart:io';

import 'package:flutter/services.dart';
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
  bool differentPlateScale = false;
  final myController = TextEditingController();
  RegExp _numberRegex = RegExp(r'^\d*\.?\d*$');
  final GlobalKey<FloodFillImageState> _floodFillImageKey = GlobalKey();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

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
            Text(translation.selectPlate,
            style: TextStyle(fontWeight: FontWeight.bold, foreground: Paint() ..color = Colors.white, fontSize: 22)),
                        Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Checkbox(value: differentPlateScale, onChanged: (newValue){
                  setState(() {
                    differentPlateScale = newValue!;
                    myController.text = "";
                  });
                }),
                SizedBox(
                    width: 240.0,
                    child: 
                    TextField(
                    enabled: differentPlateScale,
                    style: TextStyle(fontWeight: FontWeight.w500, foreground: Paint() ..color = Colors.white, fontSize: 12),                 
                    keyboardType: TextInputType.number,
                    controller: myController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(_numberRegex)
                    ],
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 8, 67, 7), width: 4.0), borderRadius: BorderRadius.all(Radius.circular(15.0))),                   
                      hintText: translation.alternativePlateScale,
                      hintStyle: TextStyle(fontWeight: FontWeight.w500, foreground: Paint() ..color = const Color.fromARGB(200, 255, 255, 255), fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                  )
                  )
              ],
            ),
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
                    child: Text(translation.returnButton, style: TextStyle(foreground: Paint() ..color = Color.fromARGB(255, 8, 130, 42), fontWeight: FontWeight.w900, fontSize: 18))),
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
                                    platePosition: scaledPlatePosition,
                                    plateScale: differentPlateScale ? double.parse(myController.text) : 1.0),
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
