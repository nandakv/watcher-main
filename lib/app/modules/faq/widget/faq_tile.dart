import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/faq/faq_analytics.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../utils/app_text_styles.dart';

class FAQTile extends StatefulWidget {
  final String question;
  final String answer;
  final String attribute;
  final bool isExpandEnabled;
  final int index;
  final bool isExpanded;

  const FAQTile({
    Key? key,
    required this.question,
    required this.answer,
    this.attribute = "x",
    this.isExpanded = false,
    this.isExpandEnabled = true,
    this.index = 1,
  }) : super(key: key);

  @override
  State<FAQTile> createState() => _FAQTileState(isExpanded: isExpanded);
}

class _FAQTileState extends State<FAQTile> with FaqAnalytics {
  bool isExpanded;

  _FAQTileState({required this.isExpanded});

  Widget _question() {
    return Text(
      widget.question,
      style: AppTextStyles.bodyMRegular(color: grey900),
    );
  }

  Widget _arrowButton() {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.isExpandEnabled) {
            logFAQTileClick(widget.index, widget.attribute);
            isExpanded = !isExpanded;
          }
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(microseconds: 350),
        child: isExpanded
            ? const Icon(
                Icons.keyboard_arrow_up,
                color: grey700,
              )
            : const Icon(
                Icons.keyboard_arrow_down,
                color: grey700,
              ),
      ),
    );
  }

  Widget _answer() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: isExpanded || !widget.isExpandEnabled
          ? Container(
              color: skyBlueColor.withOpacity(0.05),
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 16, right: 46, top: 10, bottom: 10),
              child: Text(
                widget.answer,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff004098),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: skyBlueColor.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: _question(),
              ),
              if (widget.isExpandEnabled) _arrowButton()
            ],
          ),
        ),
        _answer(),
      ],
    );
  }
}
