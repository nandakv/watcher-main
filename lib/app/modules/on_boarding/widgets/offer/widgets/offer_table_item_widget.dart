import 'package:flutter/cupertino.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_Model.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../utils/app_functions.dart';

class OfferTableItemWidget extends StatelessWidget {
  final OfferTableModel offerTableModel;
  final bool uplInsurance;
  final EdgeInsets padding;

  const OfferTableItemWidget(
      {Key? key, required this.offerTableModel, this.uplInsurance = false,this.padding = const EdgeInsets.symmetric(vertical: 8)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      children: [
        _tableRow(
          title: offerTableModel.title,
          value: offerTableModel.value,
        ),
      ],
    );
  }

  TableRow _tableRow({required String title, required String value}) {
    return TableRow(
      children: [
        Padding(
          padding: padding,
          child: Text(
            title,
            style: TextStyle(
              color: uplInsurance
                  ? const Color(0xff404040)
                  : secondaryDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        //     const SizedBox(width: 10),
        Padding(
          padding: padding,
          child: Text(
            value,
            style: TextStyle(
              color: uplInsurance
                  ? const Color(0xff404040)
                  : primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
