import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/document_info_bottom_sheet_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class DocumentsYouNeedWidget extends StatelessWidget {
  DocumentsYouNeedWidget({Key? key}) : super(key: key);

  final KnowMoreGetStartedLogic logic = Get.find<KnowMoreGetStartedLogic>();

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      borderRadius: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logic.documentInfoList.length,
            separatorBuilder: (context, index) => verticalSpacer(20),
            itemBuilder: (BuildContext context, int index) {
              return _documentsRequiredTile(logic.documentInfoList[index]);
            }),
      ),
    );
  }

  Widget _titleWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: darkBlueColor,
      ),
    );
  }

  Widget _infoIcon(DocumentInfoModel documentInfoModel) {
    return InkWell(
      onTap: () => logic.onDocumentsInfoTap(documentInfoModel),
      child: SvgPicture.asset(
        Res.infoIconSVG,
        width: 16,
        height: 16,
        colorFilter: const ColorFilter.mode(darkBlueColor, BlendMode.srcIn),
      ),
    );
  }

  Widget _documentsRequiredTile(DocumentInfoModel documentInfoModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(Res.documentIcon),
            horizontalSpacer(6),
            _titleWidget(documentInfoModel.title),
            horizontalSpacer(6),
            _infoIcon(documentInfoModel)
          ],
        ),
        verticalSpacer(12),
        _requiredDocsListWidget(documentInfoModel.requiredDocs),
      ],
    );
  }

  Widget _requiredDocsListWidget(List<String> requiredDocs) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: requiredDocs.length,
        itemBuilder: (BuildContext context, int index) {
          return _docRequiredTile(requiredDocs[index]);
        });
  }

  Widget _docRequiredTile(String docName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
      child: Text(
        "•  $docName",
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 10,
          color: primaryDarkColor,
        ),
      ),
    );
  }
}
