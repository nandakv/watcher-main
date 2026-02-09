import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/transaction_history/transaction_history_logic.dart';
import 'package:privo/res.dart';

class DateFilterChip extends StatelessWidget {
  final String dateRange;
  DateFilterChip({Key? key, required this.dateRange}) : super(key: key);

  final logic = Get.find<TransactionHistoryLogic>();

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(top: 6, right: 4),
              decoration: ShapeDecoration(
                color: const Color(0x19161742),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        dateRange,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Color(0xFF161742),
                          fontSize: 10,
                          fontFamily: 'Figtree',
                          fontWeight: FontWeight.w500,
                          height: 0.14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: InkWell(
              onTap: logic.clearDateFilter,
              child: Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(Res.clear_filter),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
