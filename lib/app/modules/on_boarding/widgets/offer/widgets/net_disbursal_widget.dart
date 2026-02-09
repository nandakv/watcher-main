import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';

class NetDisbursalWidget extends StatelessWidget {
  NetDisbursalWidget({super.key,this.border,this.removeAddOns = false,this.title = "Net Disbursal Amount"});
  BoxBorder? border;
  bool removeAddOns;
  String title;

  final offerLogic = Get.find<OfferLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightSkyBlueColor,
        border: border ?? Border.all(
          color: borderSkyBlueColor,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: netDisbursalWidget(),
    );
  }

  Widget netDisbursalWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text(
            title,
            style: TextStyle(
              color: primaryDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          GetBuilder<OfferLogic>(
            id: offerLogic.NET_DISBURSAL_ID,
            builder: (logic) {
              return Text(
                AppFunctions.getIOFOAmount(logic.fetchNetDisbursalAmount(removeAddons: removeAddOns)),
                style: _insuranceValueTextStyle,
              );
            },
          ),
        ],
      ),
    );
  }

  TextStyle get _insuranceValueTextStyle {
    return const TextStyle(
      color: primaryDarkColor,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }
}
