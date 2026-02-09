import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/document_info_bottom_sheet_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class DocumentInfoTile extends StatelessWidget {
  final DocumentTypeInfoModel docInfo;
  final bool showDocIcon;
  const DocumentInfoTile({
    Key? key,
    required this.docInfo,
    this.showDocIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(docInfo.title),
          verticalSpacer(16),
          RichTextWidget(
            infoList: [
              RichTextModel(
                  text: "${docInfo.info}\n\n",
                  textStyle:
                      const TextStyle(fontSize: 12, color: darkBlueColor)),
              RichTextModel(
                  text: "Accepted document: ",
                  textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: darkBlueColor)),
              RichTextModel(
                  text: docInfo.acceptedDocs,
                  textStyle:
                      const TextStyle(fontSize: 12, color: darkBlueColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _docIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SvgPicture.asset(Res.documentIcon),
    );
  }

  Widget _titleWidget(String subtitle) {
    return Row(
      children: [
        if (showDocIcon) _docIcon(),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 12, color: navyBlueColor),
        ),
      ],
    );
  }
}
