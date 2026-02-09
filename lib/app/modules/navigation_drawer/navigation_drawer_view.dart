import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';

import '../../common_widgets/my_account_widget_in_drawer/my_account_widget_in_drawer.dart';
import 'navigation_drawer_logic.dart';

class NavigationDrawerPage extends StatefulWidget {
  final int rowIndex;

  const NavigationDrawerPage({Key? key, required this.rowIndex})
      : super(key: key);

  @override
  State<NavigationDrawerPage> createState() => _NavigationDrawerPageState();
}

class _NavigationDrawerPageState extends State<NavigationDrawerPage> {
  final logic = Get.put(NavigationDrawerLogic());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: widget.key,
      clipBehavior: Clip.none,
      width: 290.w,
      child: Container(
        decoration: const BoxDecoration(
          color: whiteTextColor,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const SVGIcon(
                      icon: Res.crossMarkIcon,
                      size: SVGIconSize.medium,
                    ),
                  ),
                ),
              ),
              verticalSpacer(16.h),
              const MyAccountWidgetInDrawer(),
              verticalSpacer(25.h),
              _topListItems(),
              const Spacer(),
              const Divider(
                thickness: 1,
                color: lightGrayColor,
              ),
              _bottomListItems(),
              verticalSpacer(8.h)
            ],
          ),
        ),
      ),
    );
  }

  Widget _topListItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        children: [
          _buildListItem(
              title: "Home",
              textStyle: AppTextStyles.bodyMMedium(color: darkBlueColor),
              onTap: () => logic.onHomePressed(widget.rowIndex),
              index: 1,
              icon: Res.homeDrawer),
          _buildListItem(
              title: "Knowledge Base",
              textStyle: AppTextStyles.bodyMMedium(color: darkBlueColor),
              onTap: () => logic.onKnowledgeBasePressed(widget.rowIndex),
              index: 3,
              icon: Res.knowledgeBaseDrawer),
          _buildListItem(
              title: "Help & Support",
              textStyle: AppTextStyles.bodyMMedium(color: darkBlueColor),
              onTap: () => logic.onHelpAndSupportPressed(widget.rowIndex),
              index: 4,
              icon: Res.hsupportDrawer),
          FutureBuilder<bool>(
              future: logic.shouldEnableReferral(),
              builder: (snapshot, state) {
                if (state.connectionState == ConnectionState.done &&
                    state.data != null &&
                    state.data == true) {
                  return _buildListItem(
                    title: "Refer a friend",
                    index: 5,
                    enableIcon: true,
                    isDense: false,
                    textStyle: AppTextStyles.bodyMMedium(color: darkBlueColor),
                    icon: Res.rfriendDrawer,
                    onTap: () {
                      logic.onReferaFriendPressed(widget.rowIndex);
                    },
                  );
                }
                return const SizedBox();
              }),
          _buildListItem(
              title: "Logout",
              textStyle: AppTextStyles.bodyMMedium(color: darkBlueColor),
              onTap: () {
                logic.onLogoutPressed();
              },
              icon: Res.logoutDrawer),
        ],
      ),
    );
  }

  Widget _bottomListItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: logic.onTermsOfUseClicked,
            child: RichText(
              text: TextSpan(
                text: "Terms of Use ",
                style: AppTextStyles.bodyMRegular(color: skyBlueColor),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: SvgPicture.asset(
                      Res.topRightBlueArrowSVG,
                      fit: BoxFit.fitHeight,
                      height: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _versionWidget(),
        ],
      ),
    );
  }

  _buildListItem({
    bool isDense = true,
    bool enableIcon = false,
    required String title,
    required TextStyle textStyle,
    required GestureTapCallback onTap,
    String? icon,
    int index = 0,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: (widget.rowIndex == index)
            ? BoxDecoration(
                color: primarySubtleColor,
                borderRadius: BorderRadius.circular(8),
              )
            : const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: SVGIcon(
                    icon: icon,
                    size: SVGIconSize.medium,
                  ),
                ),
              Text.rich(
                TextSpan(
                  style: textStyle, // Default text style for the entire span
                  children: [
                    TextSpan(text: title),
                    if (enableIcon)
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 8.0), // Spacing from text
                          child: SVGIcon(
                              size: SVGIconSize.small, icon: Res.sparkleDrawer),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _versionWidget() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const SizedBox();
        }
        return _buildListItem(
          title:
              "App v${snapshot.data!.version} + ${snapshot.data!.buildNumber}",
          textStyle: TextStyle(
            color: grey500,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
          isDense: true,
          onTap: () {},
        );
      },
    );
  }
}
