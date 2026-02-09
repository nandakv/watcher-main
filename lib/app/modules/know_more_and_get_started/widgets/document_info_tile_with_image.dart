import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/document_info_bottom_sheet_model.dart';
import 'package:privo/app/theme/app_colors.dart';

class DocumentInfoTileWithImage extends StatelessWidget {
  final DocumentTypeInfoModelWithImage docInfo;
  const DocumentInfoTileWithImage({Key? key, required this.docInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subtitleWidget(docInfo.title),
          verticalSpacer(16),
          SvgPicture.asset(docInfo.imagePath),
          verticalSpacer(12),
          Text(
            docInfo.info,
            style: const TextStyle(
                fontSize: 12, height: 1.4, color: darkBlueColor),
          )
        ],
      ),
    );
  }

  Widget _subtitleWidget(String subtitle) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 12, color: navyBlueColor),
    );
  }
}
