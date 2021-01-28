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
  Color act = Colors.blue;
  Color inact = Colors.grey[400];
  Color btn1cl = Colors.grey[400];
  Color btn2cl = Colors.grey[400];
  Color btn3cl = Colors.grey[400];
  var xPos = 0.0;
  var yPos = 0.0;
  final width = 439.0;
  final height = 535.0;
  bool _dragging = false;
  double _size = 100;
  ui.Image _image;

  List<String> eyebrownlib = [
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Netscape-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Brain-2-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/No-Drop-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Santa-onSled-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/File-Copy-2-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Two-FingersDrag-2-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Motorcycle-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Monitor-phone-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Synchronize-2-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Synchronize-2-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/File-Copy-2-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Two-FingersDrag-2-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/No-Drop-icon.png',
  ];
  List<String> lipslib = [
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Air-Balloon-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Alien-2-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Ambulance-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Angel-Smiley-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Apple-Bite-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Add-UserStar-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Add-Cart-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Aim-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Ambulance-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Angel-Smiley-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Apple-Bite-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Add-UserStar-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Add-Cart-icon.png',
    'https://icons.iconarchive.com/icons/iconsmind/outline/128/Aim-icon.png',
  ];
  List<Widget> _resource = [];
  List<Widget> _resourceeye = [];
  List<Widget> _resourcelip = [];

  @override
  void initState() {
    _loadImage();
  }

  _loadImage() async {
    List<Widget> library1 = [];
    List<Widget> library2 = [];
    ByteData bd = await rootBundle.load("assets/resource/face.jpg");
    final Uint8List bytes = Uint8List.view(bd.buffer);
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;

    eyebrownlib.forEach((image) {
      library1.add(Expanded(
        child: Image.network(image),
      ));
    });

    lipslib.forEach((image) {
      library2.add(
        Image.network(image),
      );
    });

    setState(() {
      _image = image;
      _resourceeye = library1;
      _resourcelip = library2;
    });
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
        //color: Colors.green,
        child: new Center(
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlineButton(
                  onPressed: () {
                    setState(() {
                      _resource = _resourceeye;
                      btn1cl = act;
                      btn2cl = inact;
                    });
                  },
                  shape: new CircleBorder(),
                  borderSide: BorderSide(color: btn1cl),
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.pink[300],
                    size: 50.0,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 15),
                OutlineButton(
                  onPressed: () {
                    setState(() {
                      _resource = _resourcelip;
                      btn2cl = act;
                      btn1cl = inact;
                    });
                  },
                  shape: new CircleBorder(),
                  borderSide: BorderSide(color: btn2cl),
                  child: Icon(
                    Icons.child_care,
                    color: Colors.pink[300],
                    size: 50.0,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 15),
                OutlineButton(
                  onPressed: () {
                    if (btn3cl == inact)
                      setState(() {
                        btn3cl = act;
                      });
                    else
                      setState(() {
                        btn3cl = inact;
                      });
                  },
                  shape: new CircleBorder(),
                  borderSide: BorderSide(color: btn3cl),
                  child: Icon(
                    Icons.face_retouching_natural,
                    color: Colors.pink[300],
                    size: 50.0,
                  ),
                ),
              ],
            ),
          ),
        ),
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
        color: Colors.red,
        child: new Center(
          child: Card(
            //elevation: 0,
            //color: Colors.transparent,
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

  Widget nepTune(BuildContext context) {
    return new Positioned(
      left: MediaQuery.of(context).size.width / 10,
      bottom: 0.0,
      child: new Container(
        width: MediaQuery.of(context).size.width * 4 / 5,
        height: MediaQuery.of(context).size.width / 10,
        color: Colors.blue,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _resource,
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
        nepTune(context),
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
