import 'package:flutter/material.dart';

class BlueBackground extends StatelessWidget {
  final Widget child;

  const BlueBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff151742),
                Color(0xff1C468B),
                Color(0xff1C478D),
              ],
              stops: [0.0, 0.63, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(top: true, child: child)
      ],
    );
  }
}
