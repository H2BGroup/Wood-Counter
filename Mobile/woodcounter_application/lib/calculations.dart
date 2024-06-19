import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woodcounter_application/morphological_operations.dart';
import 'package:woodcounter_application/queuelinear_floodfiller.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:path/path.dart';

const plateWidthInMM = 27;
const plateHeightInMM = 43;
const plateAreaInMM = plateHeightInMM * plateWidthInMM;

double calculateStackVolume(int stackArea, int plateArea, double stackLength, double plateScale) {
  int fullStackArea = stackArea + plateArea;
  double rate = plateAreaInMM * plateScale / plateArea;

  return (fullStackArea * rate * stackLength * 1000) / 1000000000;
}

List<bool> addMasks(List<bool> first, List<bool> second) {
  for (int i = 0; i < first.length; i++) {
    first[i] = first[i] || second[i];
  }
  return first;
}

Future<List<bool>?> floodFill(File image, Map<Offset, double> points) async {
  var decodedImage = await decodeImageFromList(image.readAsBytesSync());
  ByteData byteData =
      (await decodedImage.toByteData(format: ui.ImageByteFormat.png))!;
  var bytes = byteData.buffer.asUint8List();
  img.Image decoded = img.decodeImage(bytes)!;
  Color fillColor = Colors.amber.withOpacity(0.9);

  List<bool> finalMask = List.generate(
      decodedImage.height * decodedImage.width, (int index) => false);

  await Future.forEach(points.entries, (MapEntry<Offset, double> p) async {
    print(finalMask);
    print(finalMask.length);
    var filler = QueueLinearFloodFiller(
        decoded,
        img.getColor(
            fillColor.red, fillColor.green, fillColor.blue, fillColor.alpha));
    int pX = p.key.dx.toInt();
    int pY = p.key.dy.toInt();

    print(p.key);
    print('X: $pX');
    print('Y: $pY');

    int touchColor = filler.image!.getPixelSafe(pX, pY);

    filler.setTargetColor(touchColor);
    filler.setTolerance(p.value.toInt());
    var newMask = await filler.floodFill(pX, pY);
    print(newMask);
    print(newMask!.length);
    finalMask = addMasks(finalMask, newMask!);
  });

  //opening
  finalMask = erosion(finalMask, decodedImage.height, decodedImage.width);
  finalMask = dilation(finalMask, decodedImage.height, decodedImage.width);

  //closing
  finalMask = dilation(finalMask, decodedImage.height, decodedImage.width);
  finalMask = erosion(finalMask, decodedImage.height, decodedImage.width);

  if(foundation.kDebugMode){
    for(int h=0; h<decodedImage.height; h++){
      for(int w=0; w<decodedImage.width; w++){
        if(finalMask[h*decodedImage.width + w]){
          decoded.setPixelRgba(w, h, 0, 0, 0);
        }
        else{
          decoded.setPixelRgba(w, h, 255, 255, 255);
        }
      }
    }
    var maskBytes = Uint8List.fromList(img.encodePng(decoded));
    File maskFile = await File("/storage/emulated/0/Download/"+basenameWithoutExtension(image.path)+(points.length == 1 ? "PlateMask" : "WoodMask")+".png");
    maskFile.writeAsBytes(maskBytes);
    print(maskFile.path);
  }

  return finalMask;
  //return (await filler.floodFill(pX, pY))!.where((object) => object == true).length;
}

Offset scalePointToBiggerRes(
    int bigImageHeight, int smallImageHeight, Offset position) {
  double scale = bigImageHeight / smallImageHeight;
  print(scale);
  print(position);
  print(position * scale);
  Offset scaledPosition = Offset(
      (position.dx.floorToDouble() * scale).floorToDouble(),
      (position.dy.floorToDouble() * scale).floorToDouble());
  print(scaledPosition);
  return scaledPosition;
}

double calculateError(int plateArea) {
  double x = sqrt(plateArea / (plateWidthInMM / plateHeightInMM));
  double y = plateWidthInMM / plateHeightInMM * x;

  print("Plate Area: $plateArea");
  print("X: $x");
  print("Y: $y");

  double dn1 = (x - 1) * (y - 1) - plateArea;
  double dn2 = (x + 1) * (y + 1) - plateArea;

  double dV1 = (dn1 / (plateArea + dn1)).abs();
  double dV2 = (dn2 / (plateArea + dn2)).abs();

  print("dV1: $dV1");
  print("dV2: $dV2");

  if (dV1 > dV2) {
    return dV1 * 100;
  } else {
    return dV2 * 100;
  }
}
