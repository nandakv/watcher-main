import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/document_type_list_model.dart';
import 'package:privo/app/modules/additional_business_details/model/address_details.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AddressWithProofWidget extends StatelessWidget {
  final String title;
  final AddressDetails address;
  final List<TaggedDoc> taggedDocs;
  final double titleFontSize;
  final double addressFontSize;
  const AddressWithProofWidget({
    Key? key,
    required this.title,
    required this.address,
    this.titleFontSize = 12,
    this.addressFontSize = 10,
    required this.taggedDocs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: primaryDarkColor,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const VerticalSpacer(8),
        Text(
          address.toString(),
          style: TextStyle(
            color: secondaryDarkColor,
            fontSize: addressFontSize,
            height: 1.7,
            fontWeight: FontWeight.w500,
          ),
        ),
        const VerticalSpacer(8),
        _attachedFilesWidget(),
      ],
    );
  }

  Widget _attachedFilesWidget() {
    return Column(
      children: taggedDocs.map((file) => _attachedFileTile(file)).toList(),
    );
  }

  Widget _attachedFileTile(TaggedDoc file) {
    return Row(
      children: [
        SvgPicture.asset(Res.attachFileIcon),
        const HorizontalSpacer(7),
        Expanded(
          child: Text(
            file.fileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: primaryDarkColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
