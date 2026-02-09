import 'package:flutter/material.dart';
import 'package:privo/app/modules/faq/faq_utility.dart';
import 'package:privo/app/modules/faq/widget/faq_list_widget.dart';

import '../on_boarding/model/privo_app_bar_model.dart';
import '../on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import 'faq_model.dart';
import 'widget/faq_tile.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key, required this.faqModel}) : super(key: key);
  final FAQModel faqModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            PrivoAppBar(
              model: PrivoAppBarModel(
                title: "",
                progress: 0,
                isAppBarVisible: true,
                isTitleVisible: false,
                appBarText: "Frequently Asked Questions",
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32.0, right: 32, left: 32, bottom: 15),
                  child: FAQListWidget(
                    faqModel: faqModel,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
