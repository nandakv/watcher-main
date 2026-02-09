import 'package:flutter/material.dart';

class AppBarBottomDivider extends StatelessWidget {
  const AppBarBottomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      thickness: 0.6,
      color: Color(0xFFE2E2E2),
    );
  }
}
