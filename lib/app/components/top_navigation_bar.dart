import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import '../../res.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({
    super.key,
    this.onBackPressed,
    this.onInfoPressed,
    this.title,
    this.enableShadow = true,
    this.trailing,
    this.secondaryWidget,
  });

  final Function()? onBackPressed;
  final Function()? onInfoPressed;
  final String? title;
  final bool enableShadow;
  final Widget? trailing;
  final Widget? secondaryWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: enableShadow ? Border(
          bottom: BorderSide(
            width: 0.6.r,
            color: lightGrayColor,
          )
        ) : null,
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 16.w, 16.h),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if(onBackPressed !=null){
                onBackPressed?.call();
              }else {
                Get.back();
              }
            },
            child: SvgPicture.asset(Res.appBarBackIconSvg),
          ),
          if (title != null) ...[
            SizedBox(
              width: 16.w,
            ),
            Text(title!,style: AppTextStyles.headingSMedium(color: appBarTitleColor),)
          ],
          if(secondaryWidget != null)...[
            HorizontalSpacer(10.w),
            secondaryWidget!,
          ],
          if (onInfoPressed != null) ...[
            const Spacer(),
            InkWell(
              onTap: onInfoPressed,
              child: SvgPicture.asset(Res.appBarInfoIconSvg),
            ),
          ],
          if(trailing != null)...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}
