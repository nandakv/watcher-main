import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/res.dart';

import 'info_message_widget.dart';

class HomeScreenTopWidget extends StatelessWidget {
  const HomeScreenTopWidget(
      {Key? key,
      required this.widget,
      required this.infoText,
      required this.showHamburger,
      this.infoTextWidget,
      this.scaffoldKey,
      this.infoPadding = EdgeInsets.zero,
      this.background,
      this.infoIcon = Res.info_bulb,
      this.onHamburgerPressed})
      : super(key: key);

  final Widget widget;
  final Widget? infoTextWidget;
  final String infoText;
  final String infoIcon;
  final EdgeInsets infoPadding;
  final bool showHamburger;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? background;
  final Function? onHamburgerPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Positioned.fill(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff151742),
                  Color(0xff1C468B),
                  Color(0xff1C478D),
                ],
                stops: [0.0, 0.63, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        // Plain gradient with code
        ..._computeBackground(),
        SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHamburger)
                InkWell(
                  child: SvgPicture.asset(
                    Res.hamburger,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (scaffoldKey != null) {
                      if (onHamburgerPressed != null) {
                        onHamburgerPressed!();
                      } else {
                        scaffoldKey!.currentState!.openDrawer();
                      }
                    }
                  },
                ),
              widget,
              infoTextWidget ?? const SizedBox(),
              if (infoText.isNotEmpty)
                InfoMessageWidget(
                  infoMessage: infoText,
                  infoIcon: infoIcon,
                  infoTextPadding: infoPadding,
                )
            ],
          ),
        ),
      ],
    );
  }

  _computeBackground() {
    if (background != null) {
      return _computeBackgroundImage();
    } else {
      return [const SizedBox()];
    }
  }

  _computeBackgroundImage() {
    if (background != null && background!.isEmpty) {
      return [
        Positioned(
          left: -Get.width * 0.45,
          top: -Get.height * 0.20,
          child: Align(
            alignment: Alignment.centerLeft,
            child:
                SvgPicture.asset(Res.pattern_complete, fit: BoxFit.scaleDown),
          ),
        ),
        Positioned(
            right: -Get.width * 0.93,
            bottom: -Get.width * 0.25,
            child: Align(
                alignment: Alignment.centerLeft,
                child:
                    SvgPicture.asset(Res.pattern_complete, fit: BoxFit.cover))),
      ];
    } else if (background != null) {
      return [
        Positioned.fill(child: SvgPicture.asset(background!, fit: BoxFit.fill))
      ];
    }
  }
}
