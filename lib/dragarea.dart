import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vector_math/vector_math_64.dart' as vector;

class CustomPainterDraggable extends StatefulWidget {
  @override
  _CustomPainterDraggableState createState() => _CustomPainterDraggableState();
}

class _CustomPainterDraggableState extends State<CustomPainterDraggable> {
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
        new Positioned(
          left: 0.0,
          top: 0.0,
          child: new Container(
            width: MediaQuery.of(context).size.width / 10,
            height: MediaQuery.of(context).size.height,
            color: Colors.green,
          ),
        ),
        new Positioned(
          right: 0.0,
          top: 0.0,
          child: new Container(
            width: MediaQuery.of(context).size.width / 10,
            height: MediaQuery.of(context).size.height,
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text('Size'),
                  ),
                  Slider(
                    value: _size,
                    min: 50,
                    max: 500,
                    onChanged: (value) {
                      setState(() {
                        _size = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildy(BuildContext context) {
    return GestureDetector(
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
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          //painter: RectanglePainter(Rect.fromLTWH(xPos, yPos, width, height)),
          painter: ImageEditor(_image, xPos, yPos),
          child: Container(),
        ),
      ),
    );
  }

  @override
  Widget buildx(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
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
                    transform: new Matrix4.diagonal3(new vector.Vector3(
                        _size / 100, _size / 100, _size / 100)),
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Size'),
            ),
            Slider(
              value: _size,
              min: 50,
              max: 500,
              onChanged: (value) {
                setState(() {
                  _size = value;
                });
              },
            ),
          ],
        ),
      ),
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

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect);
  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(rect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
