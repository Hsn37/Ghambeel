
import'package:flutter/material.dart';
import '../../theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg[darkMode],
      child: const Center(
        child: SpinKitChasingDots(
          color: accent,
          size: 50.0,
        ),
      ),
    );
  }
}