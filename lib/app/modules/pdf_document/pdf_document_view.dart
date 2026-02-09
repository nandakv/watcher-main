import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/services/privo_pdf_service/privo_pdf_widget_view.dart';

import '../../theme/app_colors.dart';
import 'pdf_document_logic.dart';

class PDFDocumentView extends StatelessWidget {
  final logic = Get.put(PDFDocumentLogic());

  PDFDocumentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Back',
          style: TextStyle(
            color: loanTextColor,
            fontSize: 16,
            letterSpacing: 0.53,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<PDFDocumentLogic>(builder: (logic) {
            return !logic.isLoading
                ? logic.url == null
                    ? const SizedBox.shrink()
                    : Expanded(
                        child: PrivoPDFWidget(
                          url: logic.url!,
                          fileName: logic.arguments['fileName'],
                        ),
                      )
                : const Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: RotationTransitionWidget(
                        loadingState: LoadingState.progressLoader,
                      ))
                    ],
                  );
          }),
        ],
      ),
    );
  }
}
