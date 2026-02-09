import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.enableLabel = true,
    this.title = "",
    this.icon = "",
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.enabled = true,
    this.isObscureText = false,
    this.toggleObscure,
    required this.onChanged,
    required this.labelText,
    this.validator,
    this.errorText,
    this.onTap,
    this.inputFormatters,
    this.maxLength,
    this.readOnly = false,
    this.prefixIcon,
    this.counterText,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  final bool enableLabel;
  final String? title;
  final String? icon;
  final String? prefixIcon;
  final String? counterText;
  final bool? readOnly;
  final int? maxLength;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String hintText;
  final bool isPassword;
  final bool enabled;
  final GestureTapCallback? onTap;
  final bool isObscureText;
  final Function()? toggleObscure;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;
  final String labelText;
  final TextCapitalization textCapitalization;

  final String? errorText;
  // final RichText? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      readOnly: readOnly ?? false,
      onTap: onTap,
      enabled: enabled,
      obscureText: isObscureText,
      onChanged: (value) => onChanged(value),
      obscuringCharacter: "*",
      validator: validator,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmitted,
      scrollPadding: const EdgeInsets.only(bottom: 60),
      inputFormatters:
      inputFormatters ?? [if (!isPassword) NoLeadingSpaceFormatter()],
      textAlignVertical: TextAlignVertical.center,
      decoration: textFieldInputDecoration(),
    );
  }

  InputDecoration textFieldInputDecoration(){
    return InputDecoration(
      hintText: hintText,
      errorStyle: const TextStyle(
          color: Color(0xffE35959), fontSize: 11, letterSpacing: 0.08),
      counterText: counterText,
      labelText: labelText,
      errorText: errorText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: const TextStyle(
        color: activeButtonColor
      ),
      alignLabelWithHint: true,
      filled: true,
      fillColor: const Color(0xFFF0F4F9),
      border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10)),
      suffixIcon: isPassword
          ? InkWell(
        child: Icon(
          !isObscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
        onTap: toggleObscure,
      )
          : null,
    );
  }
}