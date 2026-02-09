import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/golden_badge.dart';
import 'package:privo/app/common_widgets/square_tile_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import '../../../../../common_widgets/info_bulb_widget.dart';
import '../../../../../models/supported_banks_model.dart';
import '../../../../withdrawal_screen/widgets/withdrawal/widgets/arrow_pointer.dart';
import '../offer_upgrade_bank_selection_logic.dart';

class BankStatementUploadOptionSelectionWidget extends StatelessWidget {
  BankStatementUploadOptionSelectionWidget({
    Key? key,
    required this.bankStatementUploadCombination,
  }) : super(key: key);

  final BankStatementUploadCombination bankStatementUploadCombination;

  final logic = Get.find<OfferUpgradeBankSelectionLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        GetBuilder<OfferUpgradeBankSelectionLogic>(
          id: logic.BANK_SELECTION_WIDGET_ID,
          builder: (logic) {
            return Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _computeUploadOptionWidgets(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.5),
                      child: InfoBulbWidget(
                        text: _computeInfoText(),
                        border: Border.all(
                          color: const Color(0xff229ACE),
                          width: 0.6,
                        ),
                      ),
                    ),
                    Align(
                      alignment: _computeArrowPainterLocation(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: CustomPaint(
                          painter: ArrowPainter(
                            color: lightBlueColor,
                            border: Border.all(
                              color: const Color(0xff229ACE),
                              width: 0.6,
                            ),
                          ),
                          child: const SizedBox(
                            width: 16, // Adjust the size as needed
                            height: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Alignment _computeArrowPainterLocation() {
    switch (logic.selectedBankStatementUploadOption) {
      case BankStatementUploadOption.aa:
        return Alignment.centerLeft;
      case BankStatementUploadOption.netBanking:
        switch (bankStatementUploadCombination) {
          case BankStatementUploadCombination.all:
          case BankStatementUploadCombination.aaNB:
            return Alignment.center;
          default:
            return Alignment.centerLeft;
        }
      case BankStatementUploadOption.uploadPDF:
        switch (bankStatementUploadCombination) {
          case BankStatementUploadCombination.all:
            return Alignment.centerRight;
          case BankStatementUploadCombination.up:
            return Alignment.centerLeft;
          default:
            return Alignment.center;
        }
    }
  }

  String _computeInfoText() {
    switch (logic.selectedBankStatementUploadOption) {
      case BankStatementUploadOption.aa:
        return "Bank account details will be retrieved using OTP verification on your primary mobile number ";
      case BankStatementUploadOption.netBanking:
        return "Account statement will be analysed through your Net Banking.";
      case BankStatementUploadOption.uploadPDF:
        return "Simply upload the 6-month bank statement from your primary bank.";
    }
  }

  List<Widget> _computeUploadOptionWidgets() {
    switch (bankStatementUploadCombination) {
      case BankStatementUploadCombination.aa:
        return [
          _tileWidget(BankStatementUploadOption.aa),
          const SizedBox(
            width: 15,
          ),
          ..._buildEmptySpace(2),
        ];
      case BankStatementUploadCombination.nb:
        return [
          _tileWidget(BankStatementUploadOption.netBanking),
          const SizedBox(
            width: 15,
          ),
          ..._buildEmptySpace(2),
        ];
      case BankStatementUploadCombination.up:
        return [
          _tileWidget(BankStatementUploadOption.uploadPDF),
          const SizedBox(
            width: 15,
          ),
          ..._buildEmptySpace(2),
        ];
      case BankStatementUploadCombination.aaNB:
        return [
          _tileWidget(
            BankStatementUploadOption.aa,
            isRecommended: true,
          ),
          const SizedBox(
            width: 15,
          ),
          _tileWidget(BankStatementUploadOption.netBanking),
          ..._buildEmptySpace(1),
        ];
      case BankStatementUploadCombination.aaUP:
        return [
          _tileWidget(
            BankStatementUploadOption.aa,
            isRecommended: true,
          ),
          const SizedBox(
            width: 15,
          ),
          _tileWidget(BankStatementUploadOption.uploadPDF),
          ..._buildEmptySpace(1),
        ];
      case BankStatementUploadCombination.nbUP:
        return [
          _tileWidget(
            BankStatementUploadOption.netBanking,
            isRecommended: true,
          ),
          const SizedBox(
            width: 15,
          ),
          _tileWidget(BankStatementUploadOption.uploadPDF),
          ..._buildEmptySpace(1),
        ];
      case BankStatementUploadCombination.all:
        return [
          _tileWidget(
            BankStatementUploadOption.aa,
            isRecommended: true,
          ),
          const SizedBox(
            width: 15,
          ),
          _tileWidget(BankStatementUploadOption.netBanking),
          const SizedBox(
            width: 15,
          ),
          _tileWidget(BankStatementUploadOption.uploadPDF),
        ];
    }
  }

  List<Widget> _buildEmptySpace(int count) {
    return List.generate(count, (index) => const Spacer());
  }

  SquareTileWidget _tileWidget(
    BankStatementUploadOption bankStatementUploadOption, {
    bool isRecommended = false,
  }) {
    return SquareTileWidget(
      isRecommended: isRecommended,
      onTap: () => logic.onTapBankStatementType(bankStatementUploadOption),
      isSelected:
          logic.selectedBankStatementUploadOption == bankStatementUploadOption,
      title: _computeBankStatementTitle(bankStatementUploadOption),
      icon: _computeIcon(bankStatementUploadOption),
    );
  }

  String _computeBankStatementTitle(
      BankStatementUploadOption bankStatementUploadOption) {
    Map<BankStatementUploadOption, String> titleMap = {
      BankStatementUploadOption.aa: "Mobile OTP",
      BankStatementUploadOption.netBanking: "Net Banking",
      BankStatementUploadOption.uploadPDF: "Upload PDF",
    };
    return titleMap[bankStatementUploadOption] ?? "Mobile OTP";
  }

  String _computeIcon(BankStatementUploadOption bankStatementUploadOption) {
    Map<BankStatementUploadOption, String> titleMap = {
      BankStatementUploadOption.aa: Res.mobile_otp_svg,
      BankStatementUploadOption.netBanking: Res.bank_svg,
      BankStatementUploadOption.uploadPDF: Res.upload_pdf_svg,
    };
    return titleMap[bankStatementUploadOption] ?? Res.mobile_otp_svg;
  }
}
