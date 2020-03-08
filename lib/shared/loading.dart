import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff117864),
      child: Center(
          child: SpinKitChasingDots(
        color: const Color(0xff48C9B0),
        size: 50.0,
      )),
    );
  }
}
