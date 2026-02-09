import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/personal_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/widgets/personal_details_dob_field/personal_details_dob_field_logic.dart';

import '../../../../../../../res.dart';
import '../../../../../../common_widgets/vertical_spacer.dart';
import '../dob_widget.dart';

class PersonalDetailsDOBField extends StatefulWidget {
  final Function(String) onChange;
  final bool isEnabled;
  const PersonalDetailsDOBField({Key? key, required this.onChange,this.isEnabled = false})
      : super(key: key);

  @override
  State<PersonalDetailsDOBField> createState() =>
      _PersonalDetailsDOBFieldState();
}

class _PersonalDetailsDOBFieldState extends State<PersonalDetailsDOBField>
    with AfterLayoutMixin {
  final logic = Get.find<PersonalDetailsDOBFieldLogic>();

  @override
  void dispose() {
    super.dispose();
    logic.clearFields();
  }

  Widget _cakeIconWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SvgPicture.asset(Res.pdDob),
    );
  }

  Widget _dobLabelText({required double fontSize}) {
    return RichText(
      text: TextSpan(
        text: "Date Of Birth (DD / MM / YYYY)",
        style: TextStyle(
          fontFamily: 'Figtree',
          fontSize: fontSize,
          letterSpacing: 0.18,
          color: const Color(0xFF707070),
        ),
      ),
    );
  }

  Widget _dobCalenderSelectionWidget(BuildContext context) {
    return InkWell(
      onTap: () async {
        Get.focusScope?.unfocus();
        await _showDatePicker(context);
        logic.dobValidator();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
        ),
      ),
    );
  }

  Widget _dobWidget() {
    return SizedBox(
      width: double.infinity,
      child: DobWidget(
        dobFocusManager: logic.dobManager,
        onChange: () {
          logic.dobValidator();

          /// If there is any error in DOB then will send the date as empty
          if (logic.isDobError) {
            widget.onChange("");
          } else {
            widget.onChange(logic.dobManager.dobString);
          }
        },
      ),
    );
  }

  Widget _dobTextFormFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dobLabelText(fontSize: 10),
        verticalSpacer(4),
        _dobWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isEnabled,
      child: GetBuilder<PersonalDetailsDOBFieldLogic>(builder: (logic) {
        return Row(
          children: [
            _cakeIconWidget(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap:  logic.onDOBTextClick,
                          child: Focus(
                            focusNode: logic.dobFieldFocusNode,
                            child: Container(
                              color: Colors.transparent,
                              child: GetBuilder<PersonalDetailsDOBFieldLogic>(
                                  id: logic.DOB_INPUT_FIELD,
                                  builder: (logic) {
                                    if (logic.dobFocused) {
                                      return _dobTextFormFieldWidget();
                                    }
                                    return _dobLableWidget();
                                  }),
                            ),
                          ),
                        ),
                      ),
                      _dobCalenderSelectionWidget(context),
                    ],
                  ),
                  _dobDividerErrorInfoWidget(context),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _dobLableWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: _dobLabelText(fontSize: 14),
    );
  }

  Widget _dobDividerErrorInfoWidget(BuildContext context) {
    return GetBuilder<PersonalDetailsDOBFieldLogic>(
        id: logic.DOB_INFO_ERROR_TEXT,
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dobDivider(),
              verticalSpacer(6),
              logic.isDobError ? _dobErrorText() : _dobInfoText()
            ],
          );
        });
  }

  Divider _dobDivider() {
    return Divider(
      height: 2,
      thickness: logic.dobBorderFocused ? 2 : 1,
      color: logic.computeDOBBorderColor(),
    );
  }

  Text _dobErrorText() {
    return Text(logic.dobError,
        style: const TextStyle(fontSize: 12, color: Color(0xffb00020)));
  }

  Text _dobInfoText() {
    return Text(logic.dobDateValidator(),
        style: const TextStyle(fontSize: 10, color: Color(0xFF32B353)));
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? datetime = await showDatePicker(
        context: context,
        builder: (context, widget) {
          return DatePickerDialog(
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialCalendarMode: DatePickerMode.year,
              initialDate: logic.initialDateForPicker,
              firstDate: DateTime(1924, 1, 1),
              lastDate: DateTime.now());
        },
        locale: const Locale('en', 'IN'),
        fieldHintText: 'dd/mm/yyyy',
        errorInvalidText: "Not adult",
        initialDate: logic.initialDateForPicker,
        firstDate: DateTime(1890, 1, 1),
        lastDate: DateTime.now());
    if (datetime != null) {
      logic.updateDateFromCalenderPicker(datetime);
      logic.dobFocused = true;
      widget.onChange(logic.dobManager.dobString);
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }
}
