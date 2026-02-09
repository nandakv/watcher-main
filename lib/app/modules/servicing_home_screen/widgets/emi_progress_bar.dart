import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/theme/app_colors.dart'; // Assuming your color constants are here

class EmiProgressIndicator extends StatefulWidget {
  final int totalEmi;
  final int paidEmi;
  final int skippedEmi;

  const EmiProgressIndicator({
    Key? key,
    required this.totalEmi,
    required this.paidEmi,
    required this.skippedEmi,
  }) : super(key: key);

  @override
  State<EmiProgressIndicator> createState() => _EmiProgressIndicatorState();
}

class _EmiProgressIndicatorState extends State<EmiProgressIndicator>
    with AfterLayoutMixin {
  double width = 0;
  final _containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _containerKey,
      width: double.infinity,
      height: 20.h,
      decoration: _emiProgressDecoration(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Stack(
            children: [
              _pendingEmiBar(),
              _paidEmiBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paidEmiBar() {
    if (widget.paidEmi != 0) {
      return Container(
        width: computeProgressWidth(
            emis: widget.paidEmi, totalEmis: widget.totalEmi),
        height: 18.h,
        decoration: _emiProgressDecoration(color: green500),
      );
    }
    return const SizedBox();
  }

  Widget _pendingEmiBar() {
    if (widget.skippedEmi != 0) {
      return Container(
        width: computeProgressWidth(
            emis: _pendingEmiProgress(), totalEmis: widget.totalEmi),
        height: 18.h,
        decoration: _emiProgressDecoration(color: red700),
      );
    }
    return const SizedBox();
  }

  int _pendingEmiProgress() => widget.skippedEmi + widget.paidEmi;

  double computeProgressWidth({
    required int totalEmis,
    required int emis,
  }) {
    if (width == 0 || totalEmis == 0) return 0;

    final progress = emis / totalEmis;
    return progress * width;
  }

  BoxDecoration _emiProgressDecoration({Color color = grey300}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // Once the first layout is complete, get the width of the container
    // and trigger a rebuild with setState to apply the calculated width.
    if (_containerKey.currentContext != null) {
      setState(() {
        width = _containerKey.currentContext!.size!.width;
      });
    }
  }
}