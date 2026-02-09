import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import 'privo_text_form_field_logic.dart';

enum PrivoTextFormFieldType { formField, dropDown }

class PrivoTextFormField extends StatefulWidget {
  final String id;
  final AutovalidateMode autovalidateMode;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final int? maxLength;
  final bool? enabled;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;
  final void Function()? onTap;
  final bool? enableInteractiveSelection;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final String? prefixSVGIcon;
  final PrivoTextFormFieldType type;
  final String? bottomInfoImage;
  final String? bottomInfoText;
  final List<String> values;
  final String dropDownTitle;

  PrivoTextFormField({
    Key? key,
    required this.id,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    required this.controller,
    this.validator,
    this.decoration,
    this.focusNode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.maxLength,
    this.enabled,
    this.keyboardType,
    this.onFieldSubmitted,
    this.style = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryDarkColor,
      fontFamily: 'Figtree',
    ),
    this.labelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: secondaryDarkColor,
      fontFamily: 'Figtree',
    ),
    this.minLines,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.enableInteractiveSelection,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.prefixSVGIcon,
    this.values = const [],
    this.dropDownTitle = "",
    this.type = PrivoTextFormFieldType.formField,
    this.bottomInfoImage,
    this.bottomInfoText,
  }) : super(key: key) {
    if (type == PrivoTextFormFieldType.dropDown) {
      assert(values.isNotEmpty,
          'Values should not be empty when type is dropdown');

      assert(dropDownTitle.isNotEmpty,
          'dropDownTitle should not be empty when type is dropdown');
    }
  }

  @override
  State<PrivoTextFormField> createState() => _PrivoTextFormFieldState();
}

class _PrivoTextFormFieldState extends State<PrivoTextFormField> {
  late final logic;

  @override
  Widget build(BuildContext context) {
    Get.log("${widget.id} build");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.prefixSVGIcon != null) ...[
          _prefixIcon(),
          horizontalSpacer(10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (String? value) {
                  String? validationResponse = widget.validator?.call(value);
                  if (validationResponse != null &&
                      validationResponse.isNotEmpty) {
                    logic.isError = true;
                    return validationResponse;
                  }
                  logic.isError = false;
                  return null;
                },
                obscureText: widget.obscureText,
                obscuringCharacter: widget.obscuringCharacter,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                readOnly: (widget.type == PrivoTextFormFieldType.dropDown) ||
                    widget.readOnly,
                onTap: onTextFieldTapped,
                enableInteractiveSelection: widget.enableInteractiveSelection,
                autovalidateMode: widget.autovalidateMode,
                controller: widget.controller,
                enabled: widget.enabled,
                onFieldSubmitted: widget.onFieldSubmitted,
                keyboardType: widget.keyboardType,
                maxLength: widget.maxLength,
                style: widget.style,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                textInputAction: widget.textInputAction,
                textAlign: widget.textAlign,
                textAlignVertical: TextAlignVertical.top,
                decoration: widget.decoration?.copyWith(
                    labelStyle: widget.labelStyle,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIcon: _buildSuffixIcon(),
                    alignLabelWithHint: true),
                onChanged: widget.onChanged,
                inputFormatters: widget.inputFormatters,
                textCapitalization: widget.textCapitalization,
              ),
              if (widget.bottomInfoText != null) _bottomInfoText(),
              if (widget.bottomInfoImage != null) _bottomInfoImage(),
            ],
          ),
        ),
      ],
    );
  }

  onTextFieldTapped() async {
    if (widget.type == PrivoTextFormFieldType.dropDown) {
      var result = await Get.bottomSheet(
        BottomSheetRadioButtonWidget(
          title: widget.dropDownTitle,
          radioValues: widget.values,
          initialValue: widget.controller.text,
        ),
      );
      if (result != null) {
        widget.controller.text = result;
        widget.onChanged?.call(result);
      }
    } else {
      widget.onTap?.call();
    }
  }

  Widget _prefixIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: SvgPicture.asset(
        widget.prefixSVGIcon!,
        height: 24,
        width: 24,
      ),
    );
  }

  Widget _bottomInfoText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        widget.bottomInfoText!,
        style: const TextStyle(
          fontSize: 10,
          height: 1.4,
          color: secondaryDarkColor,
        ),
      ),
    );
  }

  Widget _bottomInfoImage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: lightGrayColor.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: SvgPicture.asset(
        widget.bottomInfoImage!,
      ),
    );
  }

  GetBuilder<PrivoTextFormFieldLogic> _buildSuffixIcon() {
    return GetBuilder<PrivoTextFormFieldLogic>(
      tag: widget.id,
      builder: (logic) {
        return logic.isError
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SvgPicture.asset(Res.textFieldErrorIcon),
              )
            : widget.type == PrivoTextFormFieldType.dropDown
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 14,
                    ),
                    child: SvgPicture.asset(
                      Res.dropDownTFSvg,
                      width: 12,
                    ),
                  )
                : (widget.decoration?.suffixIcon ?? const SizedBox());
      },
    );
  }

  @override
  void dispose() {
    logic.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    logic = Get.put(PrivoTextFormFieldLogic(), tag: widget.id);
    Get.log("${widget.id} initState");
  }
}
