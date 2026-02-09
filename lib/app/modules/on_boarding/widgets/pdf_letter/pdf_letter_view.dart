import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/app_button.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../services/privo_pdf_service/privo_pdf_widget_logic.dart';
import '../../../../services/privo_pdf_service/privo_pdf_widget_view.dart';
import 'pdf_letter_logic.dart';

class PDFLetterPage extends StatefulWidget {
  const PDFLetterPage({Key? key, required this.pdfLetterType})
      : super(key: key);

  final PDFLetterType pdfLetterType;

  @override
  State<PDFLetterPage> createState() => _PDFLetterPageState();
}

class _PDFLetterPageState extends State<PDFLetterPage> with AfterLayoutMixin {
  final logic = Get.find<PDFLetterLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GetBuilder<PDFLetterLogic>(
        builder: (logic) {
          return logic.isPageLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpacer(30),
                    logic.computeLoanProductLineAgreementOffer(),
                    Expanded(
                      child: PrivoPDFWidget(
                        fileName: logic.fileName,
                        url: logic.pdfDownloadURL,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GetBuilder<PrivoPDFLogic>(
                      builder: (appPDFLogic) {
                        return GradientButton(
                          onPressed: logic.onContinuePressed,
                          isLoading: logic.isButtonLoading,
                          title: _computeButtonTitle(),
                          enabled: appPDFLogic.privoPDFState ==
                              PrivoPDFState.success,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.getLetterType(pdfLetterType: widget.pdfLetterType);
    logic.onAfterFirstLayout();
  }

  String _computeButtonTitle() {
    switch (widget.pdfLetterType) {
      case PDFLetterType.sanctionLetter:
        return "Continue";
      case PDFLetterType.lineAgreement:
        return "Accept";
    }
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.14,
      color: darkBlueColor,
    );
  }
}
