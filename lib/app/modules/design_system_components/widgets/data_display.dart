import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/faq/widget/faq_tile.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/components/badges/cs_badge.dart';

class DataDisplay extends StatelessWidget {
  const DataDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpacer(38),
          const Text(
            "BADGES",
            style: TextStyle(
                color: blue1200, fontSize: 12, fontWeight: FontWeight.w400),
          ),
          ..._badges(),
          const VerticalSpacer(56),
          const Text(
            "ACCORDIAN",
            style: TextStyle(
                color: blue1200, fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const VerticalSpacer(16),
          const FAQTile(question: "Accordion title", answer: "")
        ],
      ),
    );
  }

  List<Widget> _badges() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CSBadge(text: "Refresh Available").special(),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CSBadge(text: "Refresh Available").positive(),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CSBadge(text: "Refresh Available").negative(),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CSBadge(text: "Refresh Available").neutral(),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CSBadge(text: "Refresh Available").primary(),
      ),
    ];
  }
}
