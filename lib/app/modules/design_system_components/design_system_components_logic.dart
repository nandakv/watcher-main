import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/common_widgets/privo_text_editing_controller.dart';
import 'package:privo/app/theme/app_colors.dart';

enum BottomSheetType {
  simple,
  singleButton,
  twoButtons,
  twoButtonsInLine,
  iconWithInlineButtons,
  iconWithSingleButton,
  dropdown,
  dropdownScroll
}

class DesignSystemComponentsLogic extends GetxController {
  final List<DesignColorModel> blueColors = [
    DesignColorModel(title: "100", color: blue100),
    DesignColorModel(title: "200", color: blue200),
    DesignColorModel(title: "300", color: blue300),
    DesignColorModel(title: "400", color: blue400),
    DesignColorModel(title: "500", color: blue500),
    DesignColorModel(
        title: "600",
        color: blue600,
        fillColor: MaterialStateProperty.all(const Color(0xFFE8F6FD))),
    DesignColorModel(title: "700", color: blue700),
    DesignColorModel(title: "800", color: blue800),
    DesignColorModel(title: "900", color: blue900),
    DesignColorModel(title: "1000", color: blue1000),
    DesignColorModel(title: "1100", color: blue1100),
    DesignColorModel(
        title: "1200",
        color: blue1200,
        fillColor: MaterialStateProperty.all(const Color(0xFFE8F6FD))),
    DesignColorModel(title: "1300", color: blue1300),
    DesignColorModel(title: "1400", color: blue1400),
    DesignColorModel(title: "1500", color: blue1500),
    DesignColorModel(
        title: "1600",
        color: blue1600,
        fillColor: MaterialStateProperty.all(const Color(0xFFE8F6FD))),
    DesignColorModel(title: "1700", color: blue1700),
  ];

  final List<DesignColorModel> greenColors = [
    DesignColorModel(title: "100", color: green100),
    DesignColorModel(title: "200", color: green200),
    DesignColorModel(title: "300", color: green300),
    DesignColorModel(title: "400", color: green400),
    DesignColorModel(
        title: "500",
        color: green500,
        fillColor: MaterialStateProperty.all(const Color(0xFFD6F0DD))),
    DesignColorModel(title: "600", color: green600),
    DesignColorModel(title: "700", color: green700),
    DesignColorModel(title: "800", color: green800),
  ];

  final List<DesignColorModel> yellowColors = [
    DesignColorModel(title: "100", color: secondaryYellow100),
    DesignColorModel(title: "200", color: secondaryYellow200),
    DesignColorModel(title: "300", color: secondaryYellow300),
    DesignColorModel(title: "400", color: secondaryYellow400),
    DesignColorModel(
        title: "500",
        color: secondaryYellow500,
        fillColor: MaterialStateProperty.all(secondaryYellow100)),
    DesignColorModel(title: "600", color: secondaryYellow600),
    DesignColorModel(title: "700", color: secondaryYellow700),
    DesignColorModel(
        title: "800",
        color: secondaryYellow800,
        fillColor: MaterialStateProperty.all(secondaryYellow100)),
    DesignColorModel(title: "900", color: secondaryYellow900),
    DesignColorModel(title: "1000", color: secondaryYellow1000),
    DesignColorModel(title: "1100", color: secondaryYellow1100),
  ];

  final List<DesignColorModel> redColors = [
    DesignColorModel(title: "100", color: red100),
    DesignColorModel(title: "200", color: red200),
    DesignColorModel(title: "300", color: red300),
    DesignColorModel(title: "400", color: red400),
    DesignColorModel(title: "500", color: red500),
    DesignColorModel(title: "600", color: red600),
    DesignColorModel(
        title: "700",
        color: red700,
        fillColor: MaterialStateProperty.all(red100)),
    DesignColorModel(title: "800", color: red800),
    DesignColorModel(title: "900", color: red900),
    DesignColorModel(title: "1000", color: red1000),
    DesignColorModel(title: "1100", color: red1100),
  ];

  late final PrivoTextEditingController textInputController1 =
      PrivoTextEditingController();
  late final PrivoTextEditingController textInputController2 =
      PrivoTextEditingController();
  late final PrivoTextEditingController textInputController3 =
      PrivoTextEditingController();
  late final PrivoTextEditingController textInputController4 =
      PrivoTextEditingController();
  late final TextEditingController textAreaController = TextEditingController();
  late final TextEditingController dropDownController = TextEditingController();
  late final TextEditingController searchController = TextEditingController();

  late final String BUSINESS_ENTITY_TYPE_ID = "BUSINESS_ENTITY_TYPE_ID";
  late final String DROPDOWN_FIELD_ID = "DROPDOWN_FIELD_ID";
  late final String TEXT_AREA_ID = "TEXT_AREA_ID";
  late final String SLIDER_ID = "SLIDER_ID";
  late final String SWITCH_ID = "SWITCH_ID";
  late final String CHECKBOX_ID = "CHECKBOX_ID";
  late final String RADIO_BUTTON_ID = "RADIO_BUTTON_ID";

  String _radioGroupValue = "Radio Tile 1";

  String get radioGroupValue => _radioGroupValue;

  set radioGroupValue(String value) {
    _radioGroupValue = value;
    update([RADIO_BUTTON_ID]);
  }

  bool _checkboxValue = false;

  bool get checkboxValue => _checkboxValue;

  set checkboxValue(bool value) {
    _checkboxValue = value;
    update([CHECKBOX_ID]);
  }

  bool _switchValue = false;

  bool get switchValue => _switchValue;

  set switchValue(bool value) {
    _switchValue = value;
    update([SWITCH_ID]);
  }

  double _sliderValue = 100;

  double get sliderValue => _sliderValue;

  set sliderValue(double value) {
    _sliderValue = value;
    update([SLIDER_ID]);
  }

  int? _businessEntitySelectedIndex;

  int? get businessEntitySelectedIndex => _businessEntitySelectedIndex;

  set businessEntitySelectedIndex(int? value) {
    _businessEntitySelectedIndex = value;
    update([BUSINESS_ENTITY_TYPE_ID]);
  }

  onSearchBarTextCleared() {
    searchController.clear();
  }

  onDatePickerTapped(BuildContext context) async {
    await showDatePicker(
        context: context,
        builder: (context, widget) {
          return DatePickerDialog(
              helpText: "Select your DOB",
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate: DateTime(2023, 8, 17),
              firstDate: DateTime(1924, 1, 1),
              lastDate: DateTime.now());
        },
        locale: const Locale('en', 'IN'),
        initialDate: DateTime(2023, 8, 17),
        firstDate: DateTime(1890, 1, 1),
        lastDate: DateTime.now());
  }

  final List<DesignColorModel> greyColors = [
    DesignColorModel(title: "100", color: grey100),
    DesignColorModel(title: "200", color: grey200),
    DesignColorModel(
        title: "300",
        color: grey300,
        fillColor: MaterialStateProperty.all(grey100)),
    DesignColorModel(title: "400", color: grey400),
    DesignColorModel(title: "500", color: grey500),
    DesignColorModel(title: "600", color: grey600),
    DesignColorModel(
        title: "700",
        color: grey700,
        fillColor: MaterialStateProperty.all(grey100)),
    DesignColorModel(title: "800", color: grey800),
    DesignColorModel(
        title: "900",
        color: grey900,
        fillColor: MaterialStateProperty.all(grey100)),
    DesignColorModel(title: "1000", color: grey1000),
    DesignColorModel(title: "1100", color: grey1100),
    DesignColorModel(title: "1200", color: grey1200),
  ];

  final List<DesignColorModel> pinkColors = [
    DesignColorModel(title: "100", color: pink100),
    DesignColorModel(title: "200", color: pink200),
    DesignColorModel(title: "300", color: pink300),
    DesignColorModel(
        title: "400",
        color: pink400,
        fillColor: MaterialStateProperty.all(pink100)),
    DesignColorModel(title: "500", color: pink500),
    DesignColorModel(title: "600", color: pink600),
    DesignColorModel(title: "700", color: pink700),
  ];

  List<String> radioValues() {
    return [
      "Option 1",
      "Option 2",
      "Option 3",
      "Option 4",
      "Option 5",
      "Option 6",
      "Option 7",
      "Option 8",
      "Option 9",
      "Option 10",
    ];
  }
}

class DesignColorModel {
  final String title;
  final Color color;
  final MaterialStateProperty<Color?>? fillColor;

  DesignColorModel({required this.title, required this.color, this.fillColor});
}
