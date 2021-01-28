import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vector_math/vector_math_64.dart' as vector;

class MyLayout extends StatefulWidget {
  @override
  _MyLayout createState() => _MyLayout();
}

class _MyLayout extends State<MyLayout> {
  var xPos = 0.0;
  var yPos = 0.0;
  final width = 439.0;
  final height = 535.0;
  bool _dragging = false;
  double _size = 100;
  ui.Image _image;

  @override
  void initState() {
    _loadImage();
  }

  _loadImage() async {
    ByteData bd = await rootBundle.load("assets/resource/face.jpg");

    final Uint8List bytes = Uint8List.view(bd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.Image image = (await codec.getNextFrame()).image;

    setState(() => _image = image);
  }

  /// Is the point (x, y) inside the rect?
  bool _insideRect(double x, double y) =>
      x >= xPos && x <= xPos + width && y >= yPos && y <= yPos + height;

  Widget leftTune(BuildContext context) {
    return new Positioned(
      left: 0.0,
      top: 0.0,
      child: new Container(
        width: MediaQuery.of(context).size.width / 10,
        height: MediaQuery.of(context).size.height,
        color: Colors.green,
      ),
    );
  }

  Widget rightTune(BuildContext context) {
    return new Positioned(
      right: 0.0,
      top: 0.0,
      child: new Container(
        width: MediaQuery.of(context).size.width / 10,
        height: MediaQuery.of(context).size.height,
        child: new Center(
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Transform.rotate(
                  angle: 90 * math.pi / 180,
                  child: FlutterSlider(
                    values: [_size],
                    max: 200,
                    min: 50,
                    onDragging: (index, value1, value2) {
                      setState(() {
                        _size = value1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            onPanStart: (details) => _dragging = _insideRect(
              details.globalPosition.dx,
              details.globalPosition.dy,
            ),
            onPanEnd: (details) {
              _dragging = false;
            },
            onPanUpdate: (details) {
              if (_dragging) {
                setState(() {
                  xPos += details.delta.dx;
                  yPos += details.delta.dy;
                });
              }
            },
            child: new Transform(
                transform: new Matrix4.diagonal3(
                    new vector.Vector3(_size / 100, _size / 100, _size / 100)),
                alignment: FractionalOffset.center,
                child: Container(
                  color: Colors.white,
                  child: CustomPaint(
                    //painter: RectanglePainter(Rect.fromLTWH(xPos, yPos, width, height)),
                    painter: ImageEditor(_image, xPos, yPos),
                    child: Container(),
                  ),
                )),
          ),
        ),
        leftTune(context),
        rightTune(context),
      ],
    );
  }
}

class ImageEditor extends CustomPainter {
  ui.Image image;
  double x;
  double y;
  ImageEditor(this.image, this.x, this.y) : super();

  @override
  Future paint(Canvas canvas, Size size) async {
    if (image != null) {
      canvas.drawImage(image, Offset(x, y), Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
