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

List<bool> addMasks(List<bool> first, List<bool> second){
  for(int i=0; i<first.length; i++){
    first[i] = first[i] || second[i];
  }
  return first;
}

Future<int?> floodFillCountPixels(File image, Map<Offset, double> points) async{
  var decodedImage = await decodeImageFromList(image.readAsBytesSync());
  ByteData byteData = (await decodedImage.toByteData(format: ui.ImageByteFormat.png))!;
  var bytes = byteData.buffer.asUint8List();
  img.Image decoded = img.decodeImage(bytes)!;
  Color fillColor = Colors.amber.withOpacity(0.9);

  List<bool> finalMask = List.generate(decodedImage.height*decodedImage.width, (int index) => false);

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
  
  return finalMask.where((object) => object == true).length;
  //return (await filler.floodFill(pX, pY))!.where((object) => object == true).length;
}
