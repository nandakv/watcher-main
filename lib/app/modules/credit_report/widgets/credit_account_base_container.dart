import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

class CreditAccountBaseContainer extends StatelessWidget {
  final Widget? child;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  const CreditAccountBaseContainer(
      {super.key, this.child, this.decoration, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _containerDecoration(),
      padding: padding,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: child,
    );
  }

  Decoration _containerDecoration() {
    return decoration ??
        ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.6, color: lightGrayColor),
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.white,
          shadows: _overviewShadow(),
        );
  }

  List<BoxShadow> _overviewShadow() {
    return [
      const BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          blurRadius: 4,
          spreadRadius: 0,
          offset: Offset(0, 0))
    ];
  }
}
