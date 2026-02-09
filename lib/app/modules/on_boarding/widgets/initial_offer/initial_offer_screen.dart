import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';
import '../../../../models/home_screen_model.dart';
import '../../../../models/rich_text_model.dart';
import 'initial_offer_logic.dart';

class InitialOfferScreen extends StatefulWidget {
  const InitialOfferScreen({Key? key}) : super(key: key);

  @override
  State<InitialOfferScreen> createState() => _InitialOfferScreenState();
}

class _InitialOfferScreenState extends State<InitialOfferScreen>
    with AfterLayoutMixin {
  final logic = Get.find<InitialOfferLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InitialOfferLogic>(
      builder: (logic) {
        return logic.isPageLoading ? _loadingWidget() : _initialOfferWidget();
      },
    );
  }

  Widget _loadingWidget() {
    // TODO: have scope for adding shimmer
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _offerAmountTextWidget() {
    return RichTextWidget(
      textAlign: TextAlign.center,
      infoList: [
        RichTextModel(
          text: "Well done,\n${logic.initialOfferModel.firstName}!\n",
          textStyle: GoogleFonts.poppins(
            fontSize: 24,
            height: 1.6,
            fontWeight: FontWeight.w600,
            color: navyBlueColor,
          ),
        ),
        RichTextModel(
          text: "You are eligible for\n",
          textStyle: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 14,
            height: 5,
            color: darkBlueColor,
          ),
        ),
        RichTextModel(
          text: "LOAN AMOUNT\n",
          textStyle: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 12,
            height: 2,
            color: navyBlueColor,
          ),
        ),
        RichTextModel(
          text: AppFunctions.getIOFOAmount(logic.initialOfferModel.loanAmount),
          textStyle: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 40,
            height: 1.4,
            color: darkBlueColor,
          ),
        ),
      ],
    );
  }

  Widget _roiAndTenureInfo() {
    return GradientBorderContainer(
      borderRadius: 8,
      color: lightSkyBlueColorShade1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28.0,
          vertical: 12,
        ),
        child: Text(
          "at ${logic.initialOfferModel.roi}% Rate Of Interest\nwith a tenure of ${logic.initialOfferModel.tenure} months",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Figtree',
            fontSize: 14,
            height: 1.9,
            color: navyBlueColor,
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _closeButton(),
        const HorizontalSpacer(10),
      ],
    );
  }

  Widget _closeButton() {
    return IconButton(
      onPressed: Get.back,
      icon: const Icon(Icons.clear_rounded),
    );
  }

  Widget _noteText() {
    return RichTextWidget(infoList: [
      RichTextModel(
        text: "Note: ",
        textStyle: const TextStyle(
          fontFamily: 'Figtree',
          fontSize: 11,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: navyBlueColor,
        ),
      ),
      RichTextModel(
        text: logic.computeNoteText(),
        textStyle: const TextStyle(
          fontFamily: 'Figtree',
          fontSize: 10,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: navyBlueColor,
        ),
      ),
    ]);
  }

  Widget _ctaButton() {
    return GetBuilder<InitialOfferLogic>(
        id: logic.BUTTON_ID,
        builder: (context) {
          return PrivoButton(
            onPressed: logic.onKycProceed,
            isLoading: logic.isButtonLoading,
            title: logic.computeButtonText(),
          );
        });
  }

  Widget _initialOfferWidget() {
    return Container(
      color: const Color(0xFFEFF9FD),
      child: _computeInitialOfferScreen(),
    );
  }

  Widget _computeInitialOfferScreen() {
    switch (logic.lpcCardType) {
      case LPCCardType.loan:
      case LPCCardType.lowngrow:
        return Column(
          children: [
            Expanded(child: _topWidget()),
            _bottomWidget(),
          ],
        );
      case LPCCardType.topUp:
        return _topUpOfferPage();
    }
  }

  Widget _topUpOfferPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _appbar(),
        _topUpOfferBodyWidget(),
        _bottomWidget(),
      ],
    );
  }

  Expanded _topUpOfferBodyWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            RichTextWidget(
              infoList: [
                RichTextModel(
                  text: "Well done, ${logic.initialOfferModel.firstName}!",
                  textStyle: GoogleFonts.poppins(
                    fontSize: 24,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                    color: navyBlueColor,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              Res.topUpInitialOfferSVG,
            ),
            RichTextWidget(
              infoList: [
                RichTextModel(
                  text: "You are eligible for a top up of\n",
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: darkBlueColor,
                  ),
                ),
                RichTextModel(
                  text: AppFunctions.getIOFOAmount(
                      logic.initialOfferModel.loanAmount),
                  textStyle: const TextStyle(
                    fontFamily: 'Figtree',
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                    height: 1.4,
                    color: darkBlueColor,
                  ),
                ),
              ],
            ),
            const VerticalSpacer(20),
            _roiAndTenureInfo(),
          ],
        ),
      ),
    );
  }

  Widget _topWidget() {
    return Stack(
      children: [
        _backgroundImage(),
        Column(
          children: [
            _appbar(),
            Expanded(child: _bodyWidget()),
          ],
        ),
      ],
    );
  }

  Widget _backgroundImage() {
    return SvgPicture.asset(
      Res.initialOfferBg,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          const Spacer(),
          _offerAmountTextWidget(),
          const VerticalSpacer(8),
          _roiAndTenureInfo(),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _bottomWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0, left: 32, right: 32,top: 16),
      child: Column(
        children: [_noteText(), const VerticalSpacer(16), _ctaButton()],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.afterLayout();
  }
}
