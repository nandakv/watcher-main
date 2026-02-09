import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

class TextAreaWidget extends StatefulWidget {
  final String tag;
  final String label;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final TextEditingController textController;
  final String hintText;
  final String helpText;
  final Function(String)? onChanged;
  const TextAreaWidget({
    super.key,
    required this.label,
    required this.tag,
    this.minLines = 3,
    this.maxLines = 5,
    this.maxLength = 250,
    required this.textController,
    this.hintText = "Type here",
    this.helpText = "",
    this.onChanged,
  });

  @override
  State<TextAreaWidget> createState() => _TextAreaWidgetState();
}

class _TextAreaWidgetState extends State<TextAreaWidget> {
  late final TextAreaLogic logic;

  @override
  void initState() {
    super.initState();
    logic = Get.put(TextAreaLogic());
    Get.log("${widget.tag} initState");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelWidget(),
        const VerticalSpacer(6),
        _textInputArea(),
        const VerticalSpacer(6),
        _counterRowWidget(),
      ],
    );
  }

  Widget _textInputArea() {
    return TextFormField(
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      controller: widget.textController,
      onChanged: (val) {
        widget.onChanged?.call(val);
        logic.onChanged();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF161742),
            width: 0.6,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: grey500,
          fontSize: 14,
          height: 20 / 14,
        ),
        counterText: "",
        isDense: true,
        contentPadding: const EdgeInsets.all(16),
      ),
      style: _textInputStyle(),
    );
  }

  Widget _counterRowWidget() {
    return Row(
      children: [
        Text(widget.helpText, style: _helpTextStyle()),
        const Spacer(),
        _counterTextWidget(),
      ],
    );
  }

  Widget _counterTextWidget() {
    return GetBuilder<TextAreaLogic>(
      id: logic.HELP_TEXT_ID,
      builder: (logic) {
        return Text(
          "${widget.textController.text.length}/${widget.maxLength}",
          style: _helpTextStyle(),
        );
      },
    );
  }

  TextStyle _helpTextStyle() {
    return const TextStyle(
      fontSize: 10,
      height: 1.4,
      color: secondaryDarkColor,
    );
  }

  TextStyle _textInputStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14,
      height: 20 / 14,
    );
  }

  Widget _labelWidget() {
    return Text(
      widget.label,
      style: const TextStyle(
        color: secondaryDarkColor,
        fontSize: 12,
        height: 16 / 12,
      ),
    );
  }
}

class TextAreaLogic extends GetxController {
  late final String HELP_TEXT_ID = "help_text";

  void onChanged() {
    update([HELP_TEXT_ID]);
  }
}
