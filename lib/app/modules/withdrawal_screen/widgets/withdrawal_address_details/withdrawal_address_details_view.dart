import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/common_text_fields/correspondence_address_type_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/pincode_field.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/city_state_json.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';
import '../../withdrawal_field_validator.dart';
import 'withdrawal_address_details_logic.dart';

class WithdrawalAddressDetailsView extends StatelessWidget
    with WithdrawalFieldValidator {
  WithdrawalAddressDetailsView({Key? key}) : super(key: key);

  final logic = Get.find<WithdrawalAddressDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName:
                WebEngageConstants.currentAddressScreenBackButtonClicked);
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: logic.addressDetailsFormKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Correspondence address",
                        style: TextStyle(
                          fontSize: 18,
                          color: darkBlueColor,
                          letterSpacing: 0.14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CorrespondenceAddressTypeField(
                            formFieldAttributes: FormFieldAttributes(
                              controller: logic.addressController,
                              isEnabled: !logic.isButtonLoading,
                              onChanged: logic.onAddressTextFieldChanged,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          ///State selector
                          _stateSelector(),
                          const SizedBox(
                            height: 30,
                          ),

                          ///City selector
                          _citySelector(),
                          const SizedBox(
                            height: 30,
                          ),

                          ///Pin code input section
                          PincodeField(
                            formFieldAttributes: FormFieldAttributes(
                              controller: logic.pinCodeController,
                              isEnabled: !logic.isButtonLoading,
                              onChanged: logic.onPinCodeChanged,
                            ),
                            labelText: "Pincode ",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              ///Withdraw button
              Align(
                alignment: Alignment.bottomCenter,
                child: GetBuilder<WithdrawalAddressDetailsLogic>(
                  id: logic.addressButtonId,
                  builder: (logic) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 44),
                      child: GradientButton(
                        onPressed: () {
                          logic.onAddressDetailsContinueTapped();
                        },
                        enabled: logic.configureAddressDetailsButtonColor(),
                        isLoading: logic.isButtonLoading,
                        title: "Withdraw",
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _citySelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset(Res.cityTFIconSVG),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TypeAheadField<String>(
            itemBuilder: (context, itemData) {
              return ListTile(
                title: Text(itemData),
              );
            },
            onSelected: (suggestion) {
              logic.onCitySelected(suggestion);
            },
            suggestionsCallback: (search) {
              return cityStateMap[logic.selectedState]!
                  .where((element) =>
                      element.toLowerCase().contains(search.toLowerCase()))
                  .toList();
            },
            autoFlipDirection: true,
            showOnFocus: true,
            focusNode: logic.cityFocusNode,
            controller: logic.cityTextController,
            hideWithKeyboard: true,
            builder: (context, controller, focusNode) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                enabled: !logic.isButtonLoading,
                onTap: () {
                  onCityFieldTapped();
                },
                inputFormatters: [NoLeadingSpaceFormatter()],
                onFieldSubmitted: (value) {
                  onCitySubmitted();
                },
                onEditingComplete: () {
                  onCitySubmitted();
                },
                onChanged: (value) {
                  logic.selectedCity = value;
                  logic.validateAddressDetails();
                },
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: primaryDarkColor,
                ),
                validator: (value) {
                  return validateCity(value, logic.listOfCities);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: "City",
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 25,
                    color: Color(0xff707070),
                  ),
                  labelStyle: _labelTextStyle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  TextStyle get _labelTextStyle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: secondaryDarkColor,
      );

  TextStyle get _inputTextStyle => const TextStyle(
      fontSize: 14,
      letterSpacing: 0.22,
      color: Color(0xFF404040),
      fontWeight: FontWeight.w400);

  Widget _stateSelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset(Res.stateTFIconSVG),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: GetBuilder<WithdrawalAddressDetailsLogic>(
                id: 'state-selector',
                builder: (logic) {
                  return DropdownButtonFormField<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: validateState,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryDarkColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'State',
                      labelStyle: _labelTextStyle,
                      alignLabelWithHint: true,
                    ),
                    items: logic.listOfStates.map((String value) {
                      return DropdownMenuItem<String>(
                        enabled: value != logic.selectAState,
                        value: value,
                        child: Text(
                          value,
                          style: value != logic.selectAState
                              ? const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'FigTree',
                                  fontWeight: FontWeight.w500,
                                  color: primaryDarkColor)
                              : _labelTextStyle.copyWith(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                    icon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 25,
                        color: Color(0xff707070),
                      ),
                    ),
                    isExpanded: true,
                    isDense: true,
                    value: logic.selectedState == logic.selectAState
                        ? null
                        : logic.selectedState,
                    onChanged: (value) {
                      if (value != null) {
                        logic.onStateSelected(value);
                        AppAnalytics.trackWebEngageEventWithAttribute(
                            eventName: WebEngageConstants.stateSelected);
                      }
                    },
                  );
                }),
          ),
        ),
      ],
    );
  }

  void onCityFieldTapped() {
    logic.isSearchingCity = false;
    logic.update(['state']);
    logic.cityTextController.clear();
    logic.validateAddressDetails();
  }

  void onCitySubmitted() {
    logic.isSearchingCity = true;
    logic.update(['state']);
    logic.validateAddressDetails();
  }

  InputDecoration textFieldInputDecoration({required String hintText}) {
    return InputDecoration(
        counterText: '',
        labelText: hintText,
        errorMaxLines: 3,
        errorStyle: const TextStyle(
          fontSize: 10,
        ),
        helperStyle: const TextStyle(
          fontSize: 10,
        ),
        isDense: true,
        labelStyle: _labelTextStyle);
  }
}
