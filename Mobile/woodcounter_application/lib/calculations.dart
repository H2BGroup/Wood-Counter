import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woodcounter_application/queuelinear_floodfiller.dart';

const plateAreaInMM = 1161;

double calculateStackVolume(int stackArea, int plateArea, double stackLength)
{
  int fullStackArea = stackArea + plateArea;
  double rate = plateAreaInMM / plateArea;

  return (fullStackArea * rate * stackLength * 1000) / 1000000000;
}

Future<int?> floodFillCountPixels(File image, Offset startPoint, double threshold) async{
  var decodedImage = await decodeImageFromList(image.readAsBytesSync());
  ByteData byteData = (await decodedImage.toByteData(format: ui.ImageByteFormat.png))!;
  var bytes = byteData.buffer.asUint8List();
  img.Image decoded = img.decodeImage(bytes)!;
  Color fillColor = Colors.amber.withOpacity(0.9);
  var filler = QueueLinearFloodFiller(
      decoded,
      img.getColor(
          fillColor.red, fillColor.green, fillColor.blue, fillColor.alpha));
  int pX = startPoint.dx.toInt();
  int pY = startPoint.dy.toInt();

  print(startPoint);
  print('X: $pX');
  print('Y: $pY');

  int touchColor = filler.image!.getPixelSafe(pX, pY);

  filler.setTargetColor(touchColor);
  filler.setTolerance(threshold.toInt());
  return (await filler.floodFill(pX, pY))!.where((object) => object == true).length;
}
