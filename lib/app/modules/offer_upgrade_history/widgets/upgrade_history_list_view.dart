import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/offer_upgrade_history/offer_upgrade_history_logic.dart';
import '../../on_boarding/model/privo_app_bar_model.dart';
import '../../on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import '../../pdf_document/pdf_document_logic.dart';
import 'upgrade_history_tile.dart';

class UpgradeHistoryListScreen extends StatelessWidget {
  UpgradeHistoryListScreen({Key? key}) : super(key: key);

  final logic = Get.find<OfferUpgradeHistoryLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          PrivoAppBar(
            model: PrivoAppBarModel(
              title: "",
              progress: 0,
              isAppBarVisible: true,
              isTitleVisible: false,
              appBarText: "Upgrade History",
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleText("Latest upgrade"),
                  const SizedBox(
                    height: 16,
                  ),
                  UpgradeHistoryTile(
                    offerSection: logic.finalOffer.offerSection,
                    loanProductCode: logic.loanProductCode,
                    offerDateTime: DateTime.parse(logic.enhanceOfferDateTime),
                    agreementLetterCallback: () => logic.showAgreementLetter(
                        documentType: DocumentType.agreementLetterDownload),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  if (logic.pastOffers.isNotEmpty) ...[
                    _titleText("Past upgrades"),
                    const SizedBox(
                      height: 16,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logic.pastOffers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) => UpgradeHistoryTile(
                        offerSection: logic.pastOffers[index],
                        loanProductCode: logic.loanProductCode,
                        offerDateTime: DateTime.parse(logic.pastOfferDateTime),
                        pastSanctionLetter: () =>
                            logic.docs.sanctionLetter.isNotEmpty
                                ? logic.showAgreementLetter(
                                    documentType: DocumentType.pastOfferLetter,
                                    letterUrl: logic.docs.sanctionLetter)
                                : null,
                        pastAgreementLetter: () =>
                            logic.pastOffers[index].loanAgreement.isNotEmpty
                                ? logic.showAgreementLetter(
                                    documentType: DocumentType.pastOfferLetter,
                                    letterUrl:
                                        logic.pastOffers[index].loanAgreement)
                                : null,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool showSanctionLetter(int index) {
    return logic.pastOffers[index].sanctionLetter.isNotEmpty ? true : false;
  }

  bool showAgreementLetter(int index) {
    return logic.pastOffers[index].loanAgreement.isNotEmpty ? true : false;
  }

  Text _titleText(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xff707070),
      ),
    );
  }
}
