import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/components/button.dart';

enum DockedButtonState {
  disabled(isButtonDisabled: true),
  loading(isLoading: true),
  enabled(consentColor: darkBlueColor);

  const DockedButtonState(
      {this.isLoading = false,
      this.isButtonDisabled = false,
      this.consentColor = grey500});
  final Color consentColor;
  final bool isLoading;
  final bool isButtonDisabled;
}

class DockedButton extends StatelessWidget {
  final String consentText;
  final bool consentValue;
  final bool showCheckBox;
  final Function()? onConsentChecked;
  final Function()? onConsentUnChecked;
  final Function() onPressed;
  final DockedButtonState buttonState;
  const DockedButton({
    super.key,
    required this.consentText,
    required this.consentValue,
    this.showCheckBox = true,
    this.onConsentChecked,
    required this.onPressed,
    this.onConsentUnChecked,
    required this.buttonState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _consentWidget(),
        const VerticalSpacer(12),
        _buttonWidget(),
      ],
    );
  }

  Widget _buttonWidget() {
    return Button(
      buttonSize: ButtonSize.large,
      buttonType: ButtonType.primary,
      title: "Button",
      onPressed: onPressed,
      isLoading: buttonState.isLoading,
      enabled: !buttonState.isButtonDisabled,
    );
  }

  _consentWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCheckBox) _checkboxWidget(),
        const HorizontalSpacer(4),
        Flexible(child: _consentTextWidget())
      ],
    );
  }

  Widget _consentTextWidget() {
    return Text(
      consentText,
      style: TextStyle(
        color: buttonState.consentColor,
        fontSize: 10,
        height: 14 / 10,
      ),
    );
  }

  Widget _checkboxWidget() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: 16,
        height: 16,
        child: Checkbox(
          activeColor: buttonState.consentColor,
          value: consentValue,
          onChanged: (bool? value) {
            if (value != null) {
              (value ? onConsentChecked : onConsentUnChecked)?.call();
            }
          },
        ),
      ),
    );
  }
}
