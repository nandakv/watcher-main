import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';

class PermissionItem extends StatelessWidget {
  final String iconPath;
  final String permissionTitle;
  final bool isMandatory;
  final String description;

  const PermissionItem(
      {Key? key,
      required this.iconPath,
      required this.permissionTitle,
      required this.isMandatory,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(iconPath,height: 30,width: 30,),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                permissionTitle,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.11,
                  color: darkBlueColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  letterSpacing: 0.16,
                  color: secondaryDarkColor,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
