import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class ThreeStepProcessWidget extends StatelessWidget {
  ThreeStepProcessWidget({super.key});

  List<ThreeStepModel> threeStepList = [
    ThreeStepModel(title: "Connect", icon: Res.link),
    ThreeStepModel(title: "Authorise", icon: Res.authorize),
    ThreeStepModel(title: "Manage", icon: Res.manage)
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          threeStepList.length,
          (index) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        threeStepList[index].icon,
                        height: 40, // Adjust icon size as needed
                      ),
                      const SizedBox(height: 4),
                      Text(
                        threeStepList[index].title,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors
                              .blue.shade900, // Replace with `darkBlueColor`
                        ),
                      ),
                    ],
                  ),
                  if (threeStepList.length - 1 != index)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 27,
                        height: 1,
                        alignment: Alignment.center,
                        color: const Color(0xFFE8EDF4),
                      ),
                    )
                ],
              )),
    );
  }
}

class ThreeStepModel {
  String title;
  String icon;

  ThreeStepModel({required this.title, required this.icon});
}
