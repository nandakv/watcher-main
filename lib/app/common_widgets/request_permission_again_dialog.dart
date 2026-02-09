import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/app_button.dart';

class RequestPermissionAgainDialog extends StatelessWidget {
  RequestPermissionAgainDialog({Key? key,required this.onRequestAgainClicked,required this.label}) : super(key: key);

  Function() onRequestAgainClicked;
  String label;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "$label Permission is Mandatory",
      ),
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
      content: Text(
        "We need $label Permission to run the core functionalities of the app",
      ),
      contentTextStyle: GoogleFonts.montserrat(
        color: Colors.black,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppButton(
            onPressed: onRequestAgainClicked,
            title: "REQUEST AGAIN",
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
