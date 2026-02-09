import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_logic.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/res.dart';

import '../../theme/app_colors.dart';

class BottomSheetRadioButtonWidget extends StatefulWidget {
  BottomSheetRadioButtonWidget({
    Key? key,
    required this.title,
    required this.radioValues,
    this.titleTextStyle = const TextStyle(
      color: Color(0xff1D478E),
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    this.initialValue = "",
    this.enableOtherTextField = false,
    this.ctaButtonsBuilder,
    this.onWillPop,
    this.isCloseIconEnabled = false,
    this.isScrollBarVisible = false,
    this.childPadding,
  }) : super(key: key);

  final String title;
  final TextStyle titleTextStyle;
  List<String> radioValues;
  final String initialValue;
  final bool enableOtherTextField;
  final List<Widget> Function(BottomSheetRadioButtonLogic)? ctaButtonsBuilder;
  final bool Function(bool)? onWillPop;
  final bool isCloseIconEnabled;
  final bool isScrollBarVisible;
  final EdgeInsets? childPadding;

  @override
  State<BottomSheetRadioButtonWidget> createState() =>
      _BottomSheetRadioButtonWidgetState();
}

class _BottomSheetRadioButtonWidgetState
    extends State<BottomSheetRadioButtonWidget> with AfterLayoutMixin {
  final BottomSheetRadioButtonLogic logic =
      Get.put(BottomSheetRadioButtonLogic());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop(),
      child: GetBuilder<BottomSheetRadioButtonLogic>(
        id: logic.RADIO_LIST_WIDGET_ID,
        builder: (logic) {
          return logic.showSuccessWidget
              ? _successWidget()
              : _radioListWidget();
        },
      ),
    );
  }

  bool _canPop() {
    if (widget.onWillPop == null) return true;
    return widget.onWillPop!(logic.showSuccessWidget);
  }

  _listWidgetWithButton() {
    return SizedBox(
      height: Get.height * 0.45,
      child: Column(
        children: [
          Expanded(
            child: _titleAndListView(),
          ),
          if (logic.ctaButtons.isNotEmpty) ...[
            const SizedBox(
              height: 10,
            ),
            Column(
              children: logic.ctaButtons,
            )
          ]
        ],
      ),
    );
  }

  Widget _radioListWidget() {
    return BottomSheetWidget(
      childPadding: widget.childPadding != null
          ? widget.childPadding!
          : const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      enableCloseIconButton: widget.isCloseIconEnabled,
      child: logic.ctaButtons.isNotEmpty
          ? _listWidgetWithButton()
          : _titleAndListView(),
    );
  }

  Column _titleAndListView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.title,
          style: widget.titleTextStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        if (logic.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          _computeRadioListView(),
        if (logic.isOtherValueSelected) _otherTextField(),
      ],
    );
  }

  Widget _successWidget() {
    return BottomSheetWidget(
      onCloseClicked: logic.onSuccessWidgetCloseClicked,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Res.success_icon),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Thank you for you feedback!",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: darkBlueColor,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  TextFormField _otherTextField() {
    return TextFormField(
      maxLines: 5,
      maxLength: 250,
      controller: logic.otherTextFieldController,
      autofocus: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFF161742),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: "Type here",
          hintStyle: const TextStyle(
              color: Color(0xffE2E2E2),
              fontSize: 10,
              fontWeight: FontWeight.w400),
          isDense: true,
          contentPadding: const EdgeInsets.all(15)),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Flexible _computeRadioListView() {
    return widget.isScrollBarVisible
        ? radioListViewWithScrollBar()
        : radioListViewWithoutScrollBar();
  }

  Flexible radioListViewWithScrollBar() {
    return Flexible(
      child: RawScrollbar(
        thickness: 5,
        thumbVisibility: true,
        mainAxisMargin: 10.0,
        thumbColor: lightGrayColor,
        radius: const Radius.circular(40),
        child: _radioListView(),
      ),
    );
  }

  Flexible radioListViewWithoutScrollBar() {
    return Flexible(
      child: _radioListView(),
    );
  }

  SingleChildScrollView _radioListView() {
    return SingleChildScrollView(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.radioValues.length,
        itemBuilder: (context, index) {
          return RadioTheme(
            data: _radioButtonTheme(),
            child: ListTileTheme(
              data: _listTileThemeData(),
              child: RadioListTile<String>(
                value: widget.radioValues[index],
                toggleable: true,
                groupValue: logic.selectedGroupValue,
                onChanged: (value) => logic.onChangeRadioGroup(
                  value,
                  logic.ctaButtons.isNotEmpty,
                  widget.enableOtherTextField,
                ),
                title: Text(
                  widget.radioValues[index],
                  style: _listTileTitleTextStyle(),
                ),
                contentPadding: EdgeInsets.zero,
                dense: false,
              ),
            ),
          );
        },
      ),
    );
  }

  TextStyle _listTileTitleTextStyle() => const TextStyle(
        color: Color(0xff404040),
        fontWeight: FontWeight.w500,
      );

  ListTileThemeData _listTileThemeData() {
    return const ListTileThemeData(
      visualDensity: VisualDensity(
        horizontal: 0,
        vertical: -3,
      ),
    );
  }

  RadioThemeData _radioButtonTheme() {
    return RadioThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xff404040)),
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout(
      widget.initialValue,
      widget.radioValues,
      widget.enableOtherTextField,
      widget.ctaButtonsBuilder,
    );
  }
}
