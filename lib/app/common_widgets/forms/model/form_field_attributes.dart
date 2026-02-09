import 'package:privo/app/common_widgets/privo_text_editing_controller.dart';

class FormFieldAttributes {
  final PrivoTextEditingController controller;
  final bool isEnabled;
  final bool isMandatory;
  final Function(String)? onChanged;
  final Function()? onTap;
  final String? labelText;
  final String? errorText;

  FormFieldAttributes({
    required this.controller,
    this.isEnabled = true,
    this.onChanged,
    this.isMandatory = false,
    this.labelText,
    this.onTap,
    this.errorText,
  });
}
