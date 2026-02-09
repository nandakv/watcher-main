import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../res.dart';

class AuthLoadingWidget extends StatelessWidget {
  const AuthLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: SvgPicture.asset(Res.privo_logo,height: 60,)),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: Get.width * 0.4,
                  child: const LinearProgressIndicator(
                    minHeight: 2,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Please Wait...")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
