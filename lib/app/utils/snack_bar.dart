import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static Future errorBar({
    required String title,
    required String message,
  }) async {
    await Get.showSnackbar(GetBar(
      duration: const Duration(seconds: 2),
      titleText: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.red[100]!,
      margin: const EdgeInsets.all(12),
      snackPosition: SnackPosition.TOP,
    ));
  }

  static successBar({
    required String title,
    required String message,
  }) async {
    Fluttertoast.showToast(
        msg: "$title\n$message",
        backgroundColor: Colors.green[100],
        textColor: Colors.black);
  }
}
