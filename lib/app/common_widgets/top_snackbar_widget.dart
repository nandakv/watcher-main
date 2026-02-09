import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../res.dart';

showTopSnackBar(String message) {
  Get.showSnackbar(
    GetSnackBar(
      messageText: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          SvgPicture.asset(
            Res.information_svg,
            height: 12,
            color: const Color(0xff161742),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xff161742),
                fontSize: 10,
                letterSpacing: 0.16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xffFFF3EB),
    ),
  );
}
