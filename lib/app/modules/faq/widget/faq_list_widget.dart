import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';

import '../faq_model.dart';
import 'faq_tile.dart';

class FAQListWidget extends StatelessWidget {
  final FAQModel faqModel;
  final bool shrinkWrap;
  const FAQListWidget(
      {Key? key, required this.faqModel, this.shrinkWrap = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: faqModel.faqs.length,
      separatorBuilder: (context, index) => verticalSpacer(12),
      itemBuilder: (context, index) => FAQTile(
        question: faqModel.faqs.elementAt(index).question,
        answer: faqModel.faqs.elementAt(index).answer,
        index: index + 1,
        isExpanded: index == 0,
        attribute: faqModel.attribute,
      ),
    );
  }
}
