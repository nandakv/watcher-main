import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class DeleteRequestSuccessSheet extends StatelessWidget {
  String reason;
   DeleteRequestSuccessSheet({required this.reason});

   DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              _titleHeader(),
              const Divider(color: Color(0xFFE2E2E2), height: 10),
              _bodyWidget(reason),
              _bottomWidget()
            ],
          ),
        )
      ],
    );
  }

  Row _titleHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _title(),
        _closeButton(),
      ],
    );
  }

  Padding _bodyWidget(String reason) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _textColumnItem('Reason', reason)),
          const SizedBox(
            width: 30,
          ),
          Expanded(child: _textColumnItem('Waiting period', '30 days')),
        ],
      ),
    );
  }

  Container _bottomWidget() {
    return Container(
      decoration: _bottomWidgetDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Text(
        "We're processing your account deletion. You'll receive a confirmation email soon.",
        textAlign: TextAlign.center,
        style: _bottomTextStyle(),
      ),
    );
  }

  TextStyle _bottomTextStyle() {
    return const TextStyle(
        color: offWhiteColor, fontWeight: FontWeight.w400, fontSize: 12);
  }

  BoxDecoration _bottomWidgetDecoration() {
    return const BoxDecoration(
        color: navyBlueColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ));
  }

  Widget _closeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            // AppAnalytics.trackWebEngageEventWithAttribute(
            //     eventName: closedEvent);
            Get.back();
          },
          child: const Icon(
            Icons.clear_rounded,
            color: Color(0xFF161742),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(Res.deleteRequestSuccessFull),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Request submitted',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: darkBlueColor,
                ),
              ),
              Text(
                dateFormat.format(DateTime.now()),
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: darkBlueColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textColumnItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: secondaryDarkColor),
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: primaryDarkColor),
        )
      ],
    );
  }
}
