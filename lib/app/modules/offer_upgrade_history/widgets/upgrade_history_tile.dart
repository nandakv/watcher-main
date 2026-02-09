import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/models/offer_upgrade_history_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../../../common_widgets/document_button.dart';
import '../../../theme/app_colors.dart';

class UpgradeHistoryTile extends StatelessWidget {
  const UpgradeHistoryTile(
      {Key? key,
      required this.offerSection,
      required this.loanProductCode,
      required this.offerDateTime,
      this.agreementLetterCallback,
      this.pastSanctionLetter,
      this.pastAgreementLetter,
  })
      : super(key: key);

  final OfferSection offerSection;
  final LoanProductCode loanProductCode;
  final DateTime offerDateTime;
  final VoidCallback? agreementLetterCallback;
  final VoidCallback? pastSanctionLetter;
  final VoidCallback? pastAgreementLetter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: navyBlueColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: RichText(
            text: TextSpan(
              text: 'Date: ',
              style: _titleStyle,
              children: [
                TextSpan(
                  text: DateFormat('d').format(offerDateTime),
                ),
                WidgetSpan(
                  child: Text(
                    AppFunctions().getDayOfMonthSuffix(offerDateTime.day),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: offWhiteColor,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  alignment: PlaceholderAlignment.top,
                ),
                TextSpan(
                  text: DateFormat(' MMM, yyyy').format(offerDateTime),
                ),
              ],
            ),
          ),
          // child: Text(
          //   "Date: ${_computeOfferDate()}",
          //   style: _titleStyle,
          // ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: offWhiteColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _limitText(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: _offerDetailText(
                      key: "Rate of interest",
                      value: "${offerSection.interest}%",
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: _offerDetailText(
                      key: "Tenure",
                      value: _computeTenureText(),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              _offerDetailText(
                key: "Processing fee",
                value: _computeProcessingFee(),
              ),
              const SizedBox(
                height: 8,
              ),
              if (agreementLetterCallback!=null) ...[
                const SizedBox(
                  height: 8,
                ),
                _documentsWidget(
                  title: "Agreement Letter",
                    letterCallback: agreementLetterCallback!),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (pastAgreementLetter!=null)
                    _documentsWidget(
                      title: "Agreement Letter",
                        letterCallback: pastAgreementLetter!),

                  if (pastSanctionLetter!=null)
                    _documentsWidget(
                        title: "Sanction Letter",
                        letterCallback: pastSanctionLetter!),


                ],
              )
            ],
          ),
        )
      ],
    );
  }

  String _computeTenureText() {
    switch (loanProductCode) {
      case LoanProductCode.unknown:
      case LoanProductCode.upl:
      case LoanProductCode.sbl:
        return "${offerSection.maxTenure} months";
      case LoanProductCode.clp:
        return "${offerSection.minTenure} - ${offerSection.maxTenure} months";
      default:
        return '';
    }
  }

  String _computeProcessingFee() {
    if (loanProductCode == LoanProductCode.clp) {
      return _computeClpProcessingFee();
    } else {
      return "₹ ${offerSection.processFee}";
    }
  }

  _computeClpProcessingFee() {
    if (offerSection.processFee == 0) {
      return "${offerSection.processFee}%";
    } else {
      return "Upto ${offerSection.processFee}%";
    }
  }

  TextStyle get _titleStyle {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: offWhiteColor,
      fontFamily: 'Figtree',
    );
  }

  Row _limitText() {
    return Row(
      children: [
        const Text(
          "Limit:  ",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: navyBlueColor,
          ),
        ),
        Text(
          AppFunctions.getIOFOAmount(double.parse(offerSection.limitAmount)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: navyBlueColor,
          ),
        ),
      ],
    );
  }

  Row _offerDetailText({required String key, required String value}) {
    return Row(
      children: [
        Text(
          "$key: ",
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: navyBlueColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: navyBlueColor,
          ),
        ),
      ],
    );
  }

  Widget _documentsWidget({
    required String title,
    required VoidCallback letterCallback,
  }) {
    return DocumentButton(
      title: title,
      onPressed: letterCallback,
      borderColor: const Color(0xff1D478E),
    );
  }

// _computeOfferDate() {
//   DateTime _dateTime = DateTime.parse(offerDateTime);
//   return DateFormat(
//           "d'${AppFunctions().getDayOfMonthSuffix(_dateTime.day)}' MMM, yyyy")
//       .format(_dateTime);
// }
}
