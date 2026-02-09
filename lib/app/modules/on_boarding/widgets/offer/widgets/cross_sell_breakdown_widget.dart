import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/gradient_button.dart';
import '../../../../../common_widgets/rich_text_widget.dart';
import '../../../../../firebase/analytics.dart';
import '../../../../../models/pre_approval_offer_model.dart';
import '../../../../../utils/web_engage_constant.dart';
import 'offer_table_Model.dart';
import 'offer_table_item_widget.dart';

enum RenderType { bottom, section }

class CrossSellBreakDownWidget extends StatelessWidget {
  const CrossSellBreakDownWidget(
      {Key? key,
      this.productBenefitList,
      this.clausesList,
      required this.title,
      this.detailsList,
      this.knowMoreClicked = false,
      this.renderType = RenderType.bottom,
      this.offerServiceType = OfferServiceType.insurance})
      : super(key: key);

  final List<String>? productBenefitList;
  final List<Clauses>? clausesList;
  final String title;
  final List<OfferTableModel>? detailsList;
  final bool knowMoreClicked;
  final String bullets = '\u2022';
  final RenderType renderType;
  final OfferServiceType offerServiceType;

  @override
  Widget build(BuildContext context) {
    return knowMoreClicked && productBenefitList != null
        ? _productBenefitsWidget(policyStatus: true)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _computeRenderType(renderType, offerServiceType),
            ],
          );
  }

  Widget _computeRenderType(
      RenderType widgetType, OfferServiceType offerServiceType) {
    switch (widgetType) {
      case RenderType.bottom:
        return onInsuranceCheckedBottomSheet();
      case RenderType.section:
        return showSectionWidget(offerServiceType);
    }
  }

  Widget onInsuranceCheckedBottomSheet() {
    return BottomSheetWidget(
      enableCloseIconButton: false,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Get.back(result: false),
              child: const Icon(
                Icons.clear_rounded,
                color: Color(0xFF161742),
                size: 15,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            title,
            style: _titleTextStyle(),
            textAlign: TextAlign.left,
          ),
          if (detailsList != null) insuranceDetailsWidget(),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          if (clausesList != null) clauseWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(
              // horizontal: 30,
              vertical: 10,
            ),
            child: !knowMoreClicked
                ? GradientButton(
                    title: "Agree and Confirm",
                    onPressed: () {
                      AppAnalytics.trackWebEngageEventWithAttribute(
                          eventName: WebEngageConstants.agreeConfirmClicked);
                      Get.back(result: true);
                    },
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }

  Widget showSectionWidget(OfferServiceType offerServiceType) {
    return BottomSheetWidget(
      enableCloseIconButton: false,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _computeSectionOfferTypeWidget(offerServiceType),
          if (clausesList != null) clauseWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(
              // horizontal: 30,
              vertical: 10,
            ),
            child: !knowMoreClicked
                ? GradientButton(
                    title: "Agree and Confirm",
                    onPressed: () {
                      AppAnalytics.trackWebEngageEventWithAttribute(
                          eventName: WebEngageConstants.agreeConfirmClicked);
                      Get.back(result: true);
                    },
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }

  Widget _computeSectionOfferTypeWidget(OfferServiceType offerServiceType){
    switch(offerServiceType){
      case OfferServiceType.insurance:
      case OfferServiceType.healthcare:
        return _insuranceOrHeathCareWidget();
      case OfferServiceType.insuranceHealthcare:
      return _insuranceAndHeathCareWidget();
      case OfferServiceType.none:
        return const SizedBox();
    }
 }

  Column _insuranceOrHeathCareWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: _titleTextStyle(),
          textAlign: TextAlign.left,
        ),
        if (detailsList != null) insuranceDetailsWidget(),
        const Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  Column _insuranceAndHeathCareWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
            title,
            style: _titleTextStyle(),
            textAlign: TextAlign.left,
          ),
        if (detailsList != null) insuranceDetailsWidget(),
      ],
    );
  }

  Widget _productBenefitsWidget({bool policyStatus = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: computeBorderRadius(policyStatus: policyStatus),
        color: policyStatus ? Colors.white : const Color(0xFF161742),
      ),
      margin: policyStatus
          ? const EdgeInsets.all(8)
          : const EdgeInsets.only(
              top: 8,
              left: 8,
              right: 8,
            ),
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(result: false),
              icon: Icon(
                Icons.clear_rounded,
                color: policyStatus ? const Color(0xFF161742) : Colors.white,
                size: 15,
              ),
            ),
          ),
          Text(
            'Product benefits',
            style: _bottomSheetTextStyle(policyStatus: policyStatus),
          ),
          const SizedBox(
            height: 10,
          ),
          _productBenefitsListWidget(policyStatus: policyStatus)
        ],
      ),
    );
  }

  BorderRadius computeBorderRadius({bool policyStatus = false}) {
    return policyStatus
        ? BorderRadius.circular(8)
        : const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          );
  }

  Widget _productBenefitsListWidget({bool policyStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 20),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: productBenefitList!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: policyStatus
                        ? const Color(0xff1D478E)
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    productBenefitList![index],
                    style:
                        _bottomSheetParaTextStyle(policyStatus: policyStatus),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget insuranceDetailsWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: detailsList!.length,
      itemBuilder: (BuildContext context, int index) {
        return OfferTableItemWidget(
          offerTableModel: detailsList![index],
          uplInsurance: true,
        );
      },
    );
  }

  Widget clauseWidget(
      {Function? onTandCEventCallback, Function? onKnowMoreEventCallback}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: clausesList!.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                clausesList![index].title,
                style: _titleTextStyle(fontSize: 10),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            RichTextWidget(
              infoList: clausesList![index].info,
            )
          ],
        );
      },
    );
  }

  ///text styles
  TextStyle _bottomSheetTextStyle({bool policyStatus = false}) {
    return TextStyle(
      color: policyStatus ? const Color(0xff1D478E) : const Color(0xff5BC4F0),
      fontSize: policyStatus ? 14 : 16,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _bottomSheetParaTextStyle({bool policyStatus = false}) {
    return TextStyle(
      color: policyStatus ? const Color(0xff1D478E) : Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle _titleTextStyle({double fontSize = 14}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: primaryDarkColor,
    );
  }
}
