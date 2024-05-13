import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:woodcounter_application/morphological_operations.dart';

import 'queuelinear_floodfiller.dart';
import 'package:woodcounter_application/calculations.dart';

class FloodFillPainter extends CustomPainter {
  QueueLinearFloodFiller? _filler;
  double? _width;
  double? _height;
  bool? _isFillActive;
  List<Color>? _avoidColor;

  ValueNotifier<String>? notifier;
  ui.Image image;
  Color fillColor;
  Function(Offset, ui.Image)? onFloodFillStart;
  Function(ui.Image, int)? onFloodFillEnd;
  Function? onInitialize;
  Function? onRepainted;
  Offset? lastPosition;
  bool? clicked = false;
  List<bool>? mask;
  Map<Offset, List<bool>> prevMasks = Map<Offset, List<bool>>();
  bool keepMasks;

  FloodFillPainter(
      {required this.image,
      required this.fillColor,
      this.notifier,
      this.onFloodFillStart,
      this.onFloodFillEnd,
      this.onInitialize,
      this.lastPosition,
      this.clicked,
      this.mask,
      this.keepMasks = false})
      : super(repaint: notifier) {
    _initFloodFiller();
  }

  void _initFloodFiller() async {
    ByteData byteData =
        (await image.toByteData(format: ui.ImageByteFormat.png))!;
    var bytes = byteData.buffer.asUint8List();
    img.Image decoded = img.decodeImage(bytes)!;
    clicked = false;
    _filler = QueueLinearFloodFiller(
        decoded,
        img.getColor(
            fillColor.red, fillColor.green, fillColor.blue, fillColor.alpha));
    onInitialize!();
  }

  void setSize(Size size) {
    _width = size.width;
    _height = size.height;
    _filler?.resize(size);
  }

  void setFillColor(Color color) {
    _filler?.setFillColor(
        img.getColor(color.red, color.green, color.blue, color.alpha));
  }

  void setIsFillActive(bool isActive) {
    _isFillActive = isActive;
  }

  void setAvoidColor(List<Color>? color) {
    if (color != null) _avoidColor = color;
  }

  void setTolerance(int? tolerance) {
    if (tolerance != null) _filler?.setTolerance(tolerance);
  }

  bool _checkAvoidColor(int touchColor) {
    if (_avoidColor == null) return false;

    return _avoidColor!.any((element) => _isAvoidColor(element, touchColor));
  }

  bool _isAvoidColor(Color avoidColor, int touchColor) {
    int touchR = img.getRed(touchColor);
    int touchG = img.getGreen(touchColor);
    int touchB = img.getBlue(touchColor);
    int touchA = img.getAlpha(touchColor);

    int red = avoidColor.red;
    int green = avoidColor.green;
    int blue = avoidColor.blue;
    int alpha = avoidColor.alpha;

    return red >= (touchR - 100) &&
        red <= (touchR + 100) &&
        green >= (touchG - 100) &&
        green <= (touchG + 100) &&
        blue >= (touchB - 100) &&
        blue <= (touchB + 100) &&
        alpha >= (touchA - 100) &&
        alpha <= (touchA + 100);
  }

  void fill(Offset position) async {
    int pX;
    int pY;

    pX = position.dx.toInt();
    pY = position.dy.toInt();

    print('X: $pX');
    print('Y: $pY');
    if (_filler == null) return;

    if (pX < 0 || pY < 0) return;

    int touchColor = _filler!.image!.getPixelSafe(pX, pY);
    if (_checkAvoidColor(touchColor)) return;
    if (onFloodFillStart != null) onFloodFillStart!(position, image);

    _filler?.setTargetColor(touchColor);
    await _filler!.floodFill(pX, pY);

    ui.decodeImageFromPixels(
      _filler!.image!.getBytes(),
      _filler!.image!.width,
      _filler!.image!.height,
      ui.PixelFormat.rgba8888,
      (output) async {
        image = output;
        mask = _filler?.getPixelsChecked();
        if(keepMasks){
          prevMasks[position] = mask!;
        }
        notifier!.value = position.toString() + touchColor.toString();
        if (onFloodFillEnd != null)
          onFloodFillEnd!(
              output, mask!.where((object) => object == true).length);
      },
    );
  }

  @override
  bool? hitTest(Offset position) {
    if (_isFillActive!) {
      fill(position);
      clicked = true;
      lastPosition = position;
    }
    return super.hitTest(position);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    //canvas.drawImage(image, Offset(0,0), Paint());
    double w = _width ?? image.width.toDouble();
    double h = _height ?? image.height.toDouble();
    paintImage(
        image,
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w, height: h),
        canvas,
        Paint(),
        BoxFit.fill);

    if (mask != null) {
      List<bool> maskToDraw = mask!;
      if(keepMasks){
        prevMasks.forEach((key, value) {
          maskToDraw = addMasks(maskToDraw, value);
        });
      }

      //opening
      maskToDraw = erosion(maskToDraw, h.toInt(), w.toInt());
      maskToDraw = dilation(maskToDraw, h.toInt(), w.toInt());
      
      //closing
      maskToDraw = dilation(maskToDraw, h.toInt(), w.toInt());
      maskToDraw = erosion(maskToDraw, h.toInt(), w.toInt());

      for (int x = 0; x < w; x++) {
        for (int y = 0; y < h; y++) {
          if (maskToDraw[x.toInt() + y.toInt() * w.toInt()]) {
            canvas.drawRect(
              Rect.fromLTWH(
                x.toDouble(),
                y.toDouble(),
                1,
                1,
              ),
              paint,
            );
          }
        }
      }
    }
  }

  void paintImage(
      ui.Image image, Rect outputRect, Canvas canvas, Paint paint, BoxFit fit) {
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(fit, imageSize, outputRect.size);
    final Rect inputSubrect =
        Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect =
        Alignment.center.inscribe(sizes.destination, outputRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
  }

  @override
  bool shouldRepaint(FloodFillPainter oldDelegate) {
    return true;
  }

  void clearSelection(){
    prevMasks.clear();
    mask = null;
  }
}
