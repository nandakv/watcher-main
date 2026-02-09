import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../res.dart';
import '../theme/app_colors.dart';

class InfoBulbWidget extends StatelessWidget {
  const InfoBulbWidget(
      {Key? key,
      required this.text,
      this.borderRadius,
      this.border,
      this.child,
        this.padding,
      this.richTextModel})
      : super(key: key);

  final String text;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final Widget? child;
  final EdgeInsets? padding;
  final List<RichTextModel>? richTextModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        color: lightBlueColor,
        border: border,
      ),
      child: Column(
        children: [
          if (child != null) child!,
          Padding(
            padding: padding ?? EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Res.blueBulbSVG,
                  height: 32.h,
                ),
                HorizontalSpacer(
                  15.w,
                ),
                richTextModel != null
                    ? Expanded(child: RichTextWidget(infoList: richTextModel!))
                    : _textWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _textWidget() {
    return Expanded(
      child: Text(
        text,
        style: AppTextStyles.bodyXSRegular(color: navyBlueColor),
      ),
    );
  }
}
