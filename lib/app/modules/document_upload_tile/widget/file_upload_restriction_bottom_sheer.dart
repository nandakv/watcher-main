import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';

class FileUploadRestrictionBottomSheet extends StatelessWidget {
  final Function() onRetry;
  final String message;
  const FileUploadRestrictionBottomSheet(
      {Key? key, required this.onRetry, required this.message})
      : super(key: key);

  Widget _messageWidget() {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
        height: 1.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: Column(
        children: [
          _messageWidget(),
          verticalSpacer(20),
          _ctaButton(),
          verticalSpacer(24),
        ],
      ),
    );
  }

  Widget _ctaButton() {
    return InkWell(
      onTap: () {
        Get.back();
        onRetry();
      },
      child: Container(
        decoration: BoxDecoration(
          color: darkBlueColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: darkBlueColor,
            width: 1,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          child: Text(
            "Retry",
            style: TextStyle(
              color: offWhiteColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
