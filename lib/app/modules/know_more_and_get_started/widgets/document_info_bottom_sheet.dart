import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/document_info_bottom_sheet_model.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/document_info_tile.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/document_info_tile_with_image.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class DocumentInfoBottomSheet extends StatefulWidget {
  final DocumentInfoModel documentInfoBottomSheetModel;
  const DocumentInfoBottomSheet(
      {Key? key, required this.documentInfoBottomSheetModel})
      : super(key: key);

  @override
  State<DocumentInfoBottomSheet> createState() =>
      _DocumentInfoBottomSheetState();
}

class _DocumentInfoBottomSheetState extends State<DocumentInfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _titleBar(),
            _documentInfoWithImageWidget(),
            _documentInfoWidget(),
          ],
        ),
      ),
    );
  }

  Widget _documentInfoWithImageWidget() {
    return Column(
      children: widget.documentInfoBottomSheetModel.documentInfoWithImageList
          .map((e) => DocumentInfoTileWithImage(docInfo: e))
          .toList(),
    );
  }

  Widget _documentInfoWidget() {
    return Column(
        children: widget.documentInfoBottomSheetModel.documentInfoList
            .map((e) => DocumentInfoTile(docInfo: e))
            .toList());
  }

  Widget _titleBar() {
    return Row(
      children: [
        SvgPicture.asset(Res.documentIcon),
        horizontalSpacer(6),
        Text(
          widget.documentInfoBottomSheetModel.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: darkBlueColor,
            fontSize: 12,
            height: 1.5,
          ),
        )
      ],
    );
  }
}
