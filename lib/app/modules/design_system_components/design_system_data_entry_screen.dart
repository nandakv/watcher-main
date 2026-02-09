import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/horizontal_option_chooser_widget/horizontal_option_chooser_widget_view.dart';
import 'package:privo/app/common_widgets/horizontal_option_chooser_widget/horizontal_option_item.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/common_widgets/slider_rect_thumb_shape.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/design_system_components/design_system_components_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/components/button.dart';
import 'package:privo/components/checkbox_tile.dart';
import 'package:privo/components/docked_button.dart';
import 'package:privo/components/pill_button.dart';
import 'package:privo/components/radio_tile.dart';
import 'package:privo/components/search_bar_widget.dart';
import 'package:privo/components/text_area_widget.dart';
import 'package:privo/components/switch_widget.dart';
import 'package:privo/res.dart';

class DesignSystemDataEntryScreen extends StatelessWidget {
  DesignSystemDataEntryScreen({super.key});

  final logic = Get.find<DesignSystemComponentsLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 38),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._textInputWidgets(),
            const VerticalSpacer(56),
            ..._textAreaWidgets(),
            const VerticalSpacer(56),
            ..._checkBoxWidgets(),
            const VerticalSpacer(56),
            ..._radioButtonWidgets(),
            const VerticalSpacer(56),
            ..._sliderWidget(),
            const VerticalSpacer(56),
            ..._toggleWidgets(),
            const VerticalSpacer(56),
            ..._dropDownWidgets(),
            const VerticalSpacer(56),
            ..._searchWidgets(),
            const VerticalSpacer(56),
            ..._selectionWidgets(),
            const VerticalSpacer(56),
            ..._buttonsWidgets(),
            const VerticalSpacer(56),
            ..._pillButtonWidgets(),
            const VerticalSpacer(56),
            ..._dockedButtonWidgets(),
            const VerticalSpacer(56),
            ..._datePickerWidgets(context),
          ],
        ),
      ),
    );
  }

  Widget _businessEntitySection() {
    return GetBuilder<DesignSystemComponentsLogic>(
      id: logic.BUSINESS_ENTITY_TYPE_ID,
      builder: (logic) {
        return HorizontalOptionChooserWidget(
          mainAxisAlignment: MainAxisAlignment.start,
          items: [
            HorizontalOptionItem(
              title: "option here",
              icon: Res.soleProprietorIconSVG,
            ),
            HorizontalOptionItem(
              title: "option here",
              icon: Res.partnerShipIconSVG,
            ),
            HorizontalOptionItem(
              title: "option here",
              icon: Res.llpIconSVG,
            ),
          ],
          onTap: (value) => logic.businessEntitySelectedIndex = value,
          currentIndex: logic.businessEntitySelectedIndex,
        );
      },
    );
  }

  Widget _sectionHeader(String sectionName) {
    return Text(
      sectionName,
      style: const TextStyle(
        color: darkBlueColor,
        fontSize: 12,
        height: 16 / 12,
      ),
    );
  }

  Widget _sectionSubHeader(String subSectionName) {
    return Text(
      subSectionName,
      style: const TextStyle(
        color: primaryDarkColor,
        fontSize: 12,
        height: 16 / 12,
      ),
    );
  }

  Widget _textFieldSuffixWidget() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFF1C478D),
        borderRadius: BorderRadius.circular(25),
      ),
      child: SvgPicture.asset(
        Res.calenderImg,
        fit: BoxFit.scaleDown,
      ),
    );
  }

  Widget _textInputField1() {
    return PrivoTextFormField(
      id: "DESIGN_SYSTEM_TEXT_FIELD_1",
      controller: logic.textInputController1,
      prefixSVGIcon: Res.pdDob,
      bottomInfoText: "Name as per Aadhaar",
      decoration: textFieldDecoration(
          label: "Name", suffixIcon: _textFieldSuffixWidget()),
    );
  }

  Widget _textInputField2() {
    return PrivoTextFormField(
      id: "DESIGN_SYSTEM_TEXT_FIELD_2",
      controller: logic.textInputController2,
      prefixSVGIcon: Res.pdDob,
      enabled: false,
      bottomInfoText: "Name as per Aadhaar",
      decoration: textFieldDecoration(
          label: "Name", suffixIcon: _textFieldSuffixWidget()),
    );
  }

  Widget _textInputField3() {
    return PrivoTextFormField(
      id: "DESIGN_SYSTEM_TEXT_FIELD_3",
      controller: logic.textInputController3,
      bottomInfoText: "Name as per Aadhaar",
      decoration: textFieldDecoration(
          label: "Name", suffixIcon: _textFieldSuffixWidget()),
    );
  }

  Widget _textInputField4() {
    return PrivoTextFormField(
      id: "DESIGN_SYSTEM_TEXT_FIELD_4",
      controller: logic.textInputController4,
      decoration: textFieldDecoration(label: "Name"),
    );
  }

  List<Widget> _textInputWidgets() {
    return [
      _sectionHeader("TEXT INPUT"),
      const VerticalSpacer(16),
      _textInputField1(),
      const VerticalSpacer(40),
      _textInputField2(),
      const VerticalSpacer(40),
      _textInputField3(),
      const VerticalSpacer(40),
      _textInputField4(),
    ];
  }

  List<Widget> _textAreaWidgets() {
    return [
      _sectionHeader("TEXT AREA"),
      const VerticalSpacer(16),
      TextAreaWidget(
        tag: logic.TEXT_AREA_ID,
        maxLength: 100,
        label: "Label",
        textController: logic.textAreaController,
        helpText: "Help text content",
      ),
    ];
  }

  List<Widget> _checkBoxWidgets() {
    return [
      _sectionHeader("CHECKBOX"),
      const VerticalSpacer(16),
      _enabledCheckBox(),
      const VerticalSpacer(16),
      _disabledCheckBox(),
    ];
  }

  Widget _disabledCheckBox() {
    return const CheckBoxTile(
      checkBoxState: CheckBoxState.disabled,
      checkBoxValue: true,
      label: "Label",
    );
  }

  Widget _enabledCheckBox() {
    return GetBuilder<DesignSystemComponentsLogic>(
      id: logic.CHECKBOX_ID,
      builder: (logic) {
        return CheckBoxTile(
          checkBoxValue: logic.checkboxValue,
          label: "Label",
          onChecked: () => logic.checkboxValue = true,
          onUnChecked: () => logic.checkboxValue = false,
        );
      },
    );
  }

  List<Widget> _radioButtonWidgets() {
    return [
      _sectionHeader("RADIO BUTTON"),
      const VerticalSpacer(16),
      GetBuilder<DesignSystemComponentsLogic>(
        id: logic.RADIO_BUTTON_ID,
        builder: (context) {
          return RadioTile<String>(
            label: "Option",
            groupValue: logic.radioGroupValue,
            value: "Radio Tile 1",
            onChange: (val) => logic.radioGroupValue = val ?? "",
          );
        },
      ),
      const VerticalSpacer(16),
      RadioTile<String>(
        radioTileState: RadioTileState.disabled,
        label: "Option",
        groupValue: logic.radioGroupValue,
        value: "Radio Tile 2",
        onChange: (val) => logic.radioGroupValue = val ?? "",
      )
    ];
  }

  List<Widget> _sliderWidget() {
    return [
      _sectionHeader("SLIDER"),
      const VerticalSpacer(16),
      _loanAmountSlider(),
    ];
  }

  Widget _loanAmountSlider() {
    return SliderTheme(
      data: _loanAmountSliderThemeData(),
      child: GetBuilder<DesignSystemComponentsLogic>(
        id: logic.SLIDER_ID,
        builder: (logic) {
          return Slider(
            value: logic.sliderValue,
            onChangeEnd: (value) => logic.sliderValue = value,
            onChanged: (val) => logic.sliderValue = val,
            min: 0,
            max: 1000,
            divisions: 10,
          );
        },
      ),
    );
  }

  SliderThemeData _loanAmountSliderThemeData() {
    return SliderThemeData(
      trackHeight: 1,
      activeTrackColor: navyBlueColor,
      activeTickMarkColor: navyBlueColor,
      inactiveTrackColor: offWhiteColor,
      inactiveTickMarkColor: offWhiteColor,
      disabledActiveTrackColor: navyBlueColor,
      disabledActiveTickMarkColor: navyBlueColor,
      disabledInactiveTrackColor: offWhiteColor,
      thumbColor: darkBlueColor.withOpacity(1),
      thumbShape: const SliderRectThumbShape(
        thumbHeight: 12,
        thumbWidth: 20,
        borderRadius: 8,
        fillColor: navyBlueColor,
        borderColor: Colors.transparent,
      ),
      tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 1),
      overlayShape: SliderComponentShape.noThumb,
    );
  }

  List<Widget> _toggleWidgets() {
    return [
      _sectionHeader("TOGGLE"),
      const VerticalSpacer(16),
      GetBuilder<DesignSystemComponentsLogic>(
        id: logic.SWITCH_ID,
        builder: (logic) {
          return _switchWidget();
        },
      ),
    ];
  }

  Widget _switchWidget() {
    return Column(
      children: [
        SwitchWidget(
          value: logic.switchValue,
          onChanged: (val) => logic.switchValue = val,
        ),
        SwitchWidget(
          switchType: SwitchType.disabled,
          value: logic.switchValue,
          onChanged: (val) => logic.switchValue = val,
        )
      ],
    );
  }

  List<Widget> _dropDownWidgets() {
    return [
      _sectionHeader("DROP DOWN"),
      const VerticalSpacer(16),
      _dropDownWidget(),
    ];
  }

  Widget _dropDownWidget() {
    return PrivoTextFormField(
      bottomInfoText: "Supporting Text",
      id: logic.DROPDOWN_FIELD_ID,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: true,
      controller: logic.dropDownController,
      readOnly: true,
      dropDownTitle: 'Label',
      values: const [
        "Value 1",
        "Value 2",
        "Value 3",
        "Value 4",
        "Value 5",
      ],
      prefixSVGIcon: Res.pdDob,
      type: PrivoTextFormFieldType.dropDown,
      decoration: textFieldDecoration(
        label: "Label",
      ),
    );
  }

  List<Widget> _searchWidgets() {
    return [
      _sectionHeader("SEARCH"),
      const VerticalSpacer(16),
      _searchTextField(),
    ];
  }

  Widget _searchTextField() {
    return SearchBarWidget(
      onChange: (_) {},
      onClearClicked: logic.onSearchBarTextCleared,
      searchController: logic.searchController,
      helpText: "Help text here",
    );
  }

  List<Widget> _selectionWidgets() {
    return [
      _sectionHeader("SELECTION"),
      const VerticalSpacer(16),
      _sectionSubHeader("Business Entity"),
      const VerticalSpacer(16),
      _businessEntitySection(),
    ];
  }

  Widget _buttonWidget({
    required ButtonSize buttonSize,
    required ButtonType buttonType,
    bool enabled = true,
    bool isLoading = false,
  }) {
    return Button(
      title: "Button",
      buttonSize: buttonSize,
      buttonType: buttonType,
      enabled: enabled,
      isLoading: isLoading,
    );
  }

  List<Widget> _allButtonVarients(
      {required ButtonSize buttonSize, required ButtonType buttonType}) {
    return [
      _buttonWidget(
        buttonSize: buttonSize,
        buttonType: buttonType,
      ),
      const VerticalSpacer(16),
      _buttonWidget(
        buttonSize: buttonSize,
        buttonType: buttonType,
        enabled: false,
      ),
      const VerticalSpacer(16),
      _buttonWidget(
        buttonSize: buttonSize,
        buttonType: buttonType,
        isLoading: true,
      ),
    ];
  }

  List<Widget> _allSizeAllVarientsButtonWidget(
      {required ButtonType buttonType}) {
    return [
      ..._allButtonVarients(
        buttonSize: ButtonSize.small,
        buttonType: buttonType,
      ),
      const VerticalSpacer(16),
      ..._allButtonVarients(
        buttonSize: ButtonSize.medium,
        buttonType: buttonType,
      ),
      const VerticalSpacer(16),
      ..._allButtonVarients(
        buttonSize: ButtonSize.large,
        buttonType: buttonType,
      ),
    ];
  }

  List<Widget> _buttonsWidgets() {
    return [
      _sectionHeader("BUTTONS"),
      const VerticalSpacer(16),
      _sectionHeader("FILLED"),
      const VerticalSpacer(16),
      ..._allSizeAllVarientsButtonWidget(buttonType: ButtonType.primary),
      const VerticalSpacer(32),
      _sectionHeader("OUTLINE"),
      const VerticalSpacer(16),
      ..._allSizeAllVarientsButtonWidget(buttonType: ButtonType.secondary),
      const VerticalSpacer(32),
      _sectionHeader("GHOST"),
      const VerticalSpacer(16),
      ..._allSizeAllVarientsButtonWidget(buttonType: ButtonType.tertiary),
      const VerticalSpacer(16),
    ];
  }

  Widget _pillButton({required PillButtonIconPosition iconPosition}) {
    return PillButton(
      text: "Button",
      onTap: () {},
      icon: SvgPicture.asset(Res.download),
      iconPosition: iconPosition,
    );
  }

  List<Widget> _pillButtonWidgets() {
    return [
      _sectionHeader("PILL BUTTONS"),
      const VerticalSpacer(16),
      _pillButton(iconPosition: PillButtonIconPosition.left),
      const VerticalSpacer(16),
      _pillButton(iconPosition: PillButtonIconPosition.right),
    ];
  }

  Widget _dockedButton(
      {required DockedButtonState buttonState, required String consentText}) {
    return DockedButton(
      buttonState: buttonState,
      consentText: consentText,
      consentValue: true,
      onPressed: () {},
    );
  }

  List<Widget> _dockedButtonAllStateWidgets(String consentText) {
    return [
      _dockedButton(
          buttonState: DockedButtonState.enabled, consentText: consentText),
      const VerticalSpacer(16),
      _dockedButton(
          buttonState: DockedButtonState.disabled, consentText: consentText),
      const VerticalSpacer(16),
      _dockedButton(
          buttonState: DockedButtonState.loading, consentText: consentText),
    ];
  }

  List<Widget> _dockedButtonWidgets() {
    return [
      _sectionHeader("DOCKED BUTTON"),
      const VerticalSpacer(16),
      ..._dockedButtonAllStateWidgets(
          "This component has text in multiple lines\nmore than two lines"),
      const VerticalSpacer(16),
      ..._dockedButtonAllStateWidgets("This component has text in single line")
    ];
  }

  List<Widget> _datePickerWidgets(BuildContext context) {
    return [
      InkWell(
          onTap: () => logic.onDatePickerTapped(context),
          child: _sectionHeader("DATE PICKER")),
      const VerticalSpacer(16),
    ];
  }
}
