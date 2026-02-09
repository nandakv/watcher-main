import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/navigation_drawer/navigation_drawer_view.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/modules/profile/profile_logic.dart';
import 'package:privo/res.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AfterLayoutMixin {
  final logic = Get.find<ProfileLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onBackPressed,
      child: Scaffold(
        key: logic.homePageScaffoldKey,
        drawer: const NavigationDrawerPage(
          rowIndex: 2,
          key: Key("profile_screen"),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "My Account",
            style: appBarTextStyle,
          ),
          elevation: 4,
          shadowColor: const Color(0xFF3B3B3E1A),
          titleSpacing: -2,
          leading: InkWell(
            child: SvgPicture.asset(Res.hamburger),
            onTap: () {
              logic.openDrawer();
            },
          ),
        ),
        body: GetBuilder<ProfileLogic>(builder: (logic) {
          return logic.isLoading
              ? const Center(
                  child: RotationTransitionWidget(
                      loadingState: LoadingState.progressLoader),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 45, horizontal: 45),
                  child: Column(
                    children: [
                      avatarImage(),
                      userNameWidget(),
                      textFieldWidget(
                          "Mobile Number", "+91" + logic.phone, true),
                      const SizedBox(
                        height: 25,
                      ),
                      textFieldWidget("Email", logic.email, false),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  Widget textFieldWidget(String label, String value, bool verifyStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle(),
        ),
        const SizedBox(
          height: 9,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            value.contains("+91")
                ? Text(
                    logic.phone.isEmpty
                        ? "-"
                        : value.replaceRange(0, 9, "*********"),
                    style: _valueStyle(),
                  )
                : Text(
                    logic.email.isEmpty ? "-" : value,
                    style: _valueStyle(),
                  ),
            verifyStatus == true ? validTextWidget() : Container(),
          ],
        ),
        const Divider(
          color: Color(0xFF1C478D),
          thickness: 0.5,
        ),
      ],
    );
  }

  Widget avatarImage() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1C478D), width: 1),
          borderRadius: BorderRadius.circular(58),
        ),
        child: SvgPicture.asset(
          Res.profileUser,
          height: 106,
          width: 106,
          color: const Color(0xff707070),
        ),
      ),
    );
  }

  Widget userNameWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 12,
        ),
        Flexible(
            child: Text(
          "Name (as per PAN)",
          style: labelStyle(),
        )),
        Flexible(
            child: Text(
          logic.userName.isNotEmpty ? logic.userName : "-",
          style: commonTextStyle(24, const Color(0xFF004097)),
        )),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget validTextWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min, // <-- important
      children: [
        const Icon(Icons.circle_rounded, size: 10, color: Color(0xFF32B353)),
        const SizedBox(width: 4),
        // add a small gap
        Text(
          'Verified',
          style: commonTextStyle(10, const Color(0xFF32B353)),
        ),
        // second element
      ],
    );
  }

  TextStyle _valueStyle() {
    return const TextStyle(
        fontSize: 14, color: Color(0xFF404040), fontWeight: FontWeight.normal);
  }

  TextStyle labelStyle() {
    return const TextStyle(
        fontSize: 10, fontWeight: FontWeight.normal, color: Color(0xFF707070));
  }

  TextStyle commonTextStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, fontWeight: FontWeight.normal, color: color);
  }

  TextStyle get appBarTextStyle => GoogleFonts.poppins(
        fontSize: 14,
        color: const Color(0xFF161742),
        letterSpacing: 0.11,
        fontWeight: FontWeight.w500,
      );

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }
}
