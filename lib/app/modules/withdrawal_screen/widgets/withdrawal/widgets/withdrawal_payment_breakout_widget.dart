import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/arrow_pointer.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/withdrawal_info_pop_up.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/components/skeletons/skeletons.dart';
import 'package:privo/res.dart';

class WithdrawalPaymentBreakOutWidget extends StatelessWidget {
  WithdrawalPaymentBreakOutWidget({Key? key}) : super(key: key);

  final logic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawalLogic>(
      id: logic.withdrawalPaymentContainerId,
      builder: (logic) {
        return _onPaymentDetailsLoaded(context, logic);
      },
    );
  }

  Widget _onPaymentDetailsLoaded(BuildContext context, WithdrawalLogic logic) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: _paymentContainerDecoration(),
      child: Column(
        children: [
          // _paymentBorder(),
          _showOfferAppliedWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
            child: _breakDownItems(),
          ),
        ],
      ),
    );
  }

  Row _selectedTenurePointer(WithdrawalLogic logic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Visibility(
          visible: logic.selectedTenureType == TenureType.defaultTenure,
          child: CustomPaint(
            painter: ArrowPainter(),
            child: const SizedBox(
              width: 16, // Adjust the size as needed
              height: 8,
            ),
          ),
        ),
        Visibility(
          visible: logic.selectedTenureType == TenureType.recommendedTenure ||
              logic.selectedTenureType == TenureType.customTenure,
          child: CustomPaint(
            painter: ArrowPainter(),
            child: const SizedBox(
              width: 16, // Adjust the size as needed
              height: 8,
            ),
          ),
        ),
        Visibility(
          visible: false,
          child: CustomPaint(
            painter: ArrowPainter(),
            child: const SizedBox(
              width: 16, // Adjust the size as needed
              height: 8,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _paymentContainerDecoration() {
    return BoxDecoration(
      color: const Color(0xFFFFF3EB),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Container _paymentBorder() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161742),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: logic.loanAmountSliderValue <= 1000
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Res.info_icon),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'This option is available for amounts less than 1K',
                    style: TextStyle(
                      color: offWhiteColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            )
          : const SizedBox(
              height: 10,
              width: double.infinity,
            ),
    );
  }

  Widget _breakDownItems() {
    List<WithdrawalBreakDownData> withdrawalBreakDownDataList =
        logic.parseWithdrawalBreakDownDataList();
    return ListView.builder(
      itemCount: withdrawalBreakDownDataList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (withdrawalBreakDownDataList[index].showDivider) ...[
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 0.4,
                color: Color(0xFF707070),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
            textRowItem(withdrawalBreakDownDataList[index]),
          ],
        );
      },
    );
  }

  bool isDiscountedProcessingFee(WithdrawalLogic logic) {
    return logic.withdrawalCalculationModel?.discountedProcessingFee != null
        ? true
        : false;
  }

  Widget textRowItem(WithdrawalBreakDownData withdrawalBreakDownData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    withdrawalBreakDownData.title,
                    style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.29,
                        fontWeight: withdrawalBreakDownData.isHighlighted
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: withdrawalBreakDownData.isHighlighted
                            ? const Color(0xff404040)
                            : const Color(0xff888686)),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                withdrawalBreakDownData.infoText.isNotEmpty
                    ? WithdrawalInfoPopUp(
                        bodyText: withdrawalBreakDownData.infoText,
                        title: withdrawalBreakDownData.title,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          withdrawalBreakDownData.value == null
              ? const Expanded(
                  flex: 1,
                  child: SkeletonItem(
                    child: SkeletonLine(),
                  ))
              : Text(
                  withdrawalBreakDownData.value!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    decoration:
                        withdrawalBreakDownData.isDiscountedProcessingFee
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                    letterSpacing: 0.22,
                    fontWeight: FontWeight.w600,
                    color: withdrawalBreakDownData.isHighlighted
                        ? const Color(0xff404040)
                        : const Color(0xff676565),
                  ),
                ),
          withdrawalBreakDownData.value == null &&
                  withdrawalBreakDownData.isDiscountedProcessingFee
              ? _showDiscountedProcessingFee(withdrawalBreakDownData.value!)
              : const SizedBox(),
        ],
      ),
    );
  }

  Padding _showDiscountedProcessingFee(String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 11),
      child: Text(
        value,
        // isPercentage
        //     ? value + logic.percentageSymbol
        //     : logic.rupeeSymbol +
        //         AppFunctions()
        //             .parseIntoCommaFormat(_getDiscountedProcesingFee()),
        style: GoogleFonts.poppins(
          fontSize: 14,
          letterSpacing: 0.22,
          fontWeight: FontWeight.w600,
          color: const Color(0xff32B353),
        ),
      ),
    );
  }

  bool _isDiscountValid() {
    if (logic.withdrawalCalculationModel != null &&
        logic.withdrawalCalculationModel!.processingFee !=
            logic.withdrawalCalculationModel!.discountedProcessingFee) {
      return true;
    }
    return false;
  }

  _showOfferAppliedWidget() {
    if (logic.withdrawalCalculationModel != null &&
        logic.withdrawalCalculationModel!.discountedProcessingFee != null &&
        _isDiscountValid()) {
      return InkWell(
        onTap: () {
          showOfferInfoPopUp();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 243, 235, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: _appliedOffer()),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color.fromRGBO(112, 112, 112, 1),
                size: 16,
              )
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Column _appliedOffer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: const [
            Icon(
              Icons.check_circle,
              color: Color.fromRGBO(50, 179, 83, 1),
              size: 10,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              "Offer Applied",
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 0.19,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(50, 179, 83, 1),
              ),
            )
          ],
        ),
        Flexible(
          child: Text(
            _fetchPromoDescriptionText(),
            style: const TextStyle(fontSize: 11, letterSpacing: 0.18),
          ),
        )
      ],
    );
  }

  _fetchPromoDescriptionText() {
    if (logic.withdrawalCalculationModel != null &&
        logic.withdrawalCalculationModel!.promoDesc != null) {
      return logic.withdrawalCalculationModel!.promoDesc;
    }
  }

  showOfferInfoPopUp() {
    var _context = Get.context;
    if (_context != null) {
      return showDialog(
        context: _context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      _closeButton(),
                      _showPromoDetails(),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }

  Padding _showPromoDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Text(
            _fetchPromoTitleText(),
            textAlign: TextAlign.center,
            style: _offerDetailsHeaderTextStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            _fetchPromoSubText(),
            textAlign: TextAlign.center,
            style: _offerDetailSubTitleTextStyle,
          ),
          const SizedBox(
            height: 34,
          ),
        ],
      ),
    );
  }

  Padding _closeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.clear_rounded,
            color: appBarTitleColor,
          ),
        ),
      ),
    );
  }

  TextStyle get _offerDetailsHeaderTextStyle {
    return GoogleFonts.poppins(
        fontSize: 24,
        letterSpacing: 0.38,
        color: const Color(0xFF161742),
        fontWeight: FontWeight.bold);
  }

  TextStyle get _offerDetailSubTitleTextStyle {
    return const TextStyle(
        fontSize: 10,
        height: 1.8,
        letterSpacing: 0.16,
        color: Color.fromRGBO(29, 71, 142, 1));
  }

  _fetchPromoTitleText() {
    if (logic.withdrawalCalculationModel != null &&
        logic.withdrawalCalculationModel!.promoName != null) {
      return logic.withdrawalCalculationModel!.promoName;
    }
  }

  _fetchPromoSubText() {
    if (logic.withdrawalCalculationModel != null &&
        logic.withdrawalCalculationModel!.promoSubText != null) {
      return logic.withdrawalCalculationModel!.promoSubText;
    }
  }
}
