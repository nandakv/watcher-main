import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res.dart';
import 'blue_background.dart';

class PasswordSuccessWidget extends StatelessWidget {
  const PasswordSuccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlueBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Res.password_success,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Your password has been reset successfully!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
