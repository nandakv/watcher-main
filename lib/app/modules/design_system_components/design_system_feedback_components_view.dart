import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/design_system_components/design_system_components_logic.dart';
import '../../../components/loader.dart';
import '../../../res.dart';
import '../../common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import '../../common_widgets/bottom_sheet_widget.dart';
import '../../common_widgets/vertical_spacer.dart';
import '../../theme/app_colors.dart';

class DesignSystemFeedBackView extends StatelessWidget {
  DesignSystemFeedBackView({super.key});

  final logic = Get.find<DesignSystemComponentsLogic>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {},
              child: Text(
                "SNACKBAR & TOAST",
                style: _bodySRegular(),
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 32, top: 64, bottom: 82, right: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LOADERS",
                  style: _bodySRegular(),
                ),
                const VerticalSpacer(34),
                Row(
                  children: [
                    Loader(progressVariants: LoaderSize.xs),
                    Loader(progressVariants: LoaderSize.s),
                    Loader(progressVariants: LoaderSize.m),
                    Loader(progressVariants: LoaderSize.l),
                    Loader(progressVariants: LoaderSize.xl)
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Text(
              "MODAL WINDOW",
              style: _bodySRegular(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildGradientButton(bottomSheetType: BottomSheetType.simple),
                buildGradientButton(
                    bottomSheetType: BottomSheetType.singleButton),
                buildGradientButton(
                    bottomSheetType: BottomSheetType.twoButtons),
                buildGradientButton(
                    bottomSheetType: BottomSheetType.twoButtonsInLine),
                buildGradientButton(
                    bottomSheetType: BottomSheetType.iconWithInlineButtons),
                buildGradientButton(
                    bottomSheetType: BottomSheetType.iconWithSingleButton),
                // buildGradientButton(bottomSheetType: BottomSheetType.dropdown),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GradientButton buildGradientButton(
      {required BottomSheetType bottomSheetType}) {
    return GradientButton(
      onPressed: () => _bottomSheetWidget(bottomSheetType: bottomSheetType),
      title: _bottomSheetButtonName(buttonTitle: bottomSheetType),
      titleTextStyle: _buttonTextStyle(),
    );
  }

  _bottomSheetWidget({required BottomSheetType bottomSheetType}) {
    switch (bottomSheetType) {
      case BottomSheetType.simple:
        _simpleBottomSheetWidget();
        break;
      case BottomSheetType.singleButton:
        _singleButtonBottomSheetWidget();
        break;
      case BottomSheetType.twoButtons:
        _twoButtonsBottomSheet();
        break;
      case BottomSheetType.twoButtonsInLine:
        _twoButtonsInLineBottomSheetWidget();
        break;
      case BottomSheetType.iconWithInlineButtons:
        _twoButtonsInLineBottomSheetWidget(icon: Res.businessCenter);
        break;
      case BottomSheetType.iconWithSingleButton:
        _twoButtonsInLineBottomSheetWidget(
            icon: Res.businessCenter, bottomSheetType: bottomSheetType);
        break;
      case BottomSheetType.dropdown:
        _dropDownBottomSheet();
        break;
      case BottomSheetType.dropdownScroll:
        // TODO: Handle this case.
        break;
    }
  }

  String _bottomSheetButtonName({required BottomSheetType buttonTitle}) {
    switch (buttonTitle) {
      case BottomSheetType.simple:
        return "Simple bottomSheet";
      case BottomSheetType.singleButton:
        return "Single button bottomSheet";
      case BottomSheetType.twoButtons:
        return "Two button bottomSheet";
      case BottomSheetType.twoButtonsInLine:
        return "Two Button Inline BottomSheet";
      case BottomSheetType.iconWithInlineButtons:
        return "Icon with inline buttons";
      case BottomSheetType.iconWithSingleButton:
        return "Icon with single button";
      case BottomSheetType.dropdown:
        return "dropdown bottomSheet";
      case BottomSheetType.dropdownScroll:
        return "Two button bottomSheet";
    }
  }

  TextStyle _bodySRegular() {
    return const TextStyle(
      fontSize: 12,
      color: darkBlueColor,
      fontWeight: FontWeight.w400,
    );
  }

  Widget _ctaButton() {
    return GradientButton(
      titleTextStyle: _buttonTextStyle(),
      onPressed: () {},
      title: "Button",
    );
  }

  Widget _titleWidget() {
    return Text(
      "Title",
      style: TextStyle(
        fontSize: 16,
        fontFamily : "Poppins",
        fontWeight: FontWeight.w500,
        height: 22 / 16,
        color: appBarTitleColor,
      ),
    );
  }

  Widget _messageTextWidget() {
    return const Text(
      "A dialog is a type of modal window that appears in",
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          letterSpacing: 0,
          height: 16 / 12,
          color: secondaryDarkColor),
    );
  }

  Future _simpleBottomSheetWidget() {
    return Get.bottomSheet(BottomSheetWidget(
      childPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      enableCloseIconButton: true,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleWidget(),
            verticalSpacer(12),
            _messageTextWidget(),
            verticalSpacer(32),
          ],
        ),
      ),
    ));
  }

  Future _singleButtonBottomSheetWidget() {
    return Get.bottomSheet(BottomSheetWidget(
      childPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      enableCloseIconButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(),
          verticalSpacer(12),
          _messageTextWidget(),
          verticalSpacer(24),
          _ctaButton(),
        ],
      ),
    ));
  }

  Future _twoButtonsBottomSheet() {
    return Get.bottomSheet(BottomSheetWidget(
      childPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      enableCloseIconButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(),
          verticalSpacer(12),
          _messageTextWidget(),
          verticalSpacer(24),
          _ctaButton(),
          Center(
            child: TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text(
                "Button",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 22 / 16,
                  color: appBarTitleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future _twoButtonsInLineBottomSheetWidget(
      {String? icon, BottomSheetType? bottomSheetType}) {
    return Get.bottomSheet(BottomSheetWidget(
      childPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      enableCloseIconButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 13),
              child: SvgPicture.asset(icon),
            ),
            const VerticalSpacer(25),
          ],
          _titleWidget(),
          verticalSpacer(12),
          _messageTextWidget(),
          verticalSpacer(24),
          bottomSheetType == BottomSheetType.iconWithSingleButton
              ? _ctaButton()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _ctaButton()),
                      const SizedBox(width: 16),
                      Expanded(child: _mediumButton("Button"))
                    ],
                  ),
                ),
        ],
      ),
    ));
  }


  //subtitle and scroll bar dropdown later in next build
  _dropDownBottomSheet() async {
    await Get.bottomSheet(
      Wrap(
        children: [
          BottomSheetRadioButtonWidget(
            title: "Title",
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 22 / 16,
              color: appBarTitleColor,
            ),
            radioValues: logic.radioValues(),
            isScrollBarVisible: false,
            isCloseIconEnabled: true,
          )
        ],
      ),
      enableDrag: true,
      isDismissible: true,
    );
  }

  _mediumButton(String title) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: const Color(0xFF161742).withOpacity(1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
          child: Center(
            child: Text(
              title,
              style: _subTitleTextStyle(),
            ),
          ),
        ),
      ),
    );
  }

  _buttonTextStyle() {
    return const TextStyle(
      fontSize: 16,
      color: whiteTextColor,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _subTitleTextStyle() {
    return const TextStyle(
        fontSize: 16,
        height: 22 / 16,
        fontWeight: FontWeight.w600,
        color: navyBlueColor);
  }
}
