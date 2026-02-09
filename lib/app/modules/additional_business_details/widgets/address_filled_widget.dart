import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/additional_business_details/widgets/address_with_proof_text_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AddressFilledWidget extends StatelessWidget {
  final Function()? onEditTapped;
  final List<AddressWithProofWidget> addressList;
  final bool showIcon;
  const AddressFilledWidget(
      {Key? key,
      required this.onEditTapped,
      required this.addressList,
      this.showIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      borderRadius: 8,
      color: lightSkyBlueColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _addressListWidget(),
            ),
            const HorizontalSpacer(8),
            if (showIcon) _editIcon(),
          ],
        ),
      ),
    );
  }

  Widget _addressListWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(addressList.length, (index) {
        final isLast = index == addressList.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 24.0),
          child: addressList[index],
        );
      }),
    );
  }

  Widget _editIcon() {
    return InkWell(
      onTap: onEditTapped,
      child: SvgPicture.asset(Res.editIcon),
    );
  }
}
