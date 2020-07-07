import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'dart:math' as math;

class FullScreenImage extends StatefulWidget {
  _FullScreenImageState createState() => _FullScreenImageState();
  final imagePath;
  FullScreenImage({this.imagePath});
}

class _FullScreenImageState extends State<FullScreenImage> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  var yOffset = 400.0;
  var xOffset = 50.0;
  var rotation = 0.0;
  var lastRotation = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            Positioned.fromRect(
              rect: Rect.fromPoints(Offset(xOffset - 125.0, yOffset - 50.0),
                  Offset(xOffset + 400.0, yOffset + 100.0)),
              child: GestureDetector(
                // onPanStart: (DragStartDetails details) {
                //   print(details);
                //   _previousPan = _pan;
                //   setState(() {});
                // },
                // onPanUpdate: (DragUpdateDetails details) {
                //   print(details);
                //   // _pan=_previousPan*details.
                // },
                onScaleStart: (ScaleStartDetails details) {
                  print(details);

                  _previousScale = _scale;
                  setState(() {});
                },
                onScaleUpdate: (ScaleUpdateDetails details) {
                  print(details);
                  rotation += lastRotation - details.rotation;
                  lastRotation = details.rotation;
                  var offset = details.focalPoint;
                  xOffset = offset.dx - 125;
                  yOffset = offset.dy - 125;
                  _scale = _previousScale * details.scale;
                  setState(() {});
                },
                onScaleEnd: (ScaleEndDetails details) {
                  print(details);
                  _previousScale = 1.0;
                  setState(() {});
                },
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale))
                    ..rotateZ(rotation * math.pi / 180.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.imagePath,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
