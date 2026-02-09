import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';

import '../../firebase/analytics.dart';
import '../../utils/web_engage_constant.dart';
import 'privo_pdf_widget_logic.dart';

class PrivoPDFWidget extends StatefulWidget {
  const PrivoPDFWidget({
    Key? key,
    required this.url,
    required this.fileName,
  }) : super(key: key);

  final String url;
  final String fileName;

  @override
  State<PrivoPDFWidget> createState() => _PrivoPDFWidgetState();
}

class _PrivoPDFWidgetState extends State<PrivoPDFWidget> with AfterLayoutMixin {
  final logic = Get.put(PrivoPDFLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivoPDFLogic>(
      builder: (logic) {
        switch (logic.privoPDFState) {
          case PrivoPDFState.loading:
            return const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            );
          case PrivoPDFState.success:
            return PrivoPlatform.platformService.pdfViewWidget(
              onPageChanged: (page, total) => page == 0
                  ? ""
                  : AppAnalytics.trackWebEngageEventWithAttribute(
                      eventName: WebEngageConstants.lineAgreementScrolled),
              filePath: logic.pdfPath,
            );
        }
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.downloadPDF(
      url: widget.url,
      fileName: widget.fileName,
    );
  }
}
