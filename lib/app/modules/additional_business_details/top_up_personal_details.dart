import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import '../../../components/button.dart';
import '../../../components/radio_tile.dart';
import '../../common_widgets/privo_button.dart';
import 'additional_business_details_logic.dart';
import 'additional_business_details_screen.dart';
import 'model/address_details.dart';
import 'new_address_screen.dart';

class VerifyPersonalDetails extends StatefulWidget {
  VerifyPersonalDetails({super.key});

  @override
  State<VerifyPersonalDetails> createState() => _VerifyPersonalDetailsState();
}

class _VerifyPersonalDetailsState extends State<VerifyPersonalDetails> with AfterLayoutMixin {
  final logic = Get.find<AdditionalBusinessDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<AdditionalBusinessDetailsLogic>(
        builder: (logic) {
          switch (logic.verifyState) {
            case VerifyState.screenLoading:
              return const Center(child: CircularProgressIndicator());
            case VerifyState.verifyPersonalDetails:
              return _topUpPersonalDetailsScreen();
            case VerifyState.additionalBdScreen:
              return const AdditionalBusinessDetailsScreen();
          }
        },
      ),
    );
  }

  SafeArea _topUpPersonalDetailsScreen() {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _body(),
          _reKycContinueButton(),
        ],
      ),
    ));
  }

  _reKycContinueButton() {
    return GetBuilder<AdditionalBusinessDetailsLogic>(
        id: logic.NEW_ADDRESS_BUTTON_ID,
        builder: (logic) {
          return Button(
            buttonSize: ButtonSize.large,
            buttonType: ButtonType.primary,
            title: "Continue",
            enabled: logic.newAddressButtonEnabled,
            onPressed: logic.onReKycButtonPressed,
            isLoading: logic.isNewAddressButtonLoading,
          );
        });
  }

  Expanded _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Business Registered",
              style: AppTextStyles.bodyMMedium(color: primaryDarkColor),
            ),
            VerticalSpacer(8.h),
            addressText(logic.additionalBusinessDetailsModel.correspondingAddress),
            VerticalSpacer(18.h),
            Text(
              "Business Operational",
              style: AppTextStyles.bodyMMedium(color: primaryDarkColor),
            ),
            VerticalSpacer(8.h),
            addressText(
                logic.additionalBusinessDetailsModel.operationalAddress),
            VerticalSpacer(40.h),
            if (logic.additionalBusinessDetailsModel.reKycToBeDone) ...[
              _reKycHeading(),
              VerticalSpacer(16.h),
              _reKycOptions(),
              VerticalSpacer(40.h),
              if (logic.selectedOption == AddressSameOption.no) ...[
                NewAddressScreen(),
              ]
            ],
          ],
        ),
      ),
    );
  }

  GetBuilder<AdditionalBusinessDetailsLogic> _reKycOptions() {
    return GetBuilder<AdditionalBusinessDetailsLogic>(builder: (logic) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RadioTile<AddressSameOption>(
            label: "Yes",
            groupValue: logic.selectedOption!,
            value: AddressSameOption.yes,
            onChange: (AddressSameOption? val) {
              if (val != null) {
                logic.onChangeSelectedYes(val);
              }
            },
          ),
          HorizontalSpacer(32.w),
          RadioTile<AddressSameOption>(
            label: "No",
            groupValue: logic.selectedOption!,
            value: AddressSameOption.no,
            onChange: (AddressSameOption? val) async {
              if (val != null) {
                logic.onChangeSelectedNo(val);
              }
            },
          ),
        ],
      );
    });
  }

  Text _reKycHeading() {
    return Text(
        "Are the above addresses the same as those provided with the original loan?",
        style: AppTextStyles.bodyMMedium(color: grey900));
  }

  Text addressText(AddressDetails? address) {
    return Text(
      address?.toString() ?? "",
      style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    return logic.onAfterLayout();
  }
}
