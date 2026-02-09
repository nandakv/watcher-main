import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/design_system_components/design_system_components_logic.dart';
import 'package:privo/app/modules/design_system_components/widgets/foundation_color_list_view.dart';
import 'package:privo/app/modules/design_system_components/widgets/sticky_body_table.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../utils/app_text_styles.dart';
import 'sticky_header_table.dart';

class FoundationContent extends StatelessWidget {
  final logic = Get.find<DesignSystemComponentsLogic>();

  static const Color primaryDarkColor = Color(0xFF333333);
  static const Color primaryTextColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpacer(32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "COLORS",
              style: TextStyle(
                color: blue1200,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          FoundationColorListView(
            colors: logic.blueColors,
            title: "Brand & Primary Blue",
          ),
          FoundationColorListView(
            colors: logic.greenColors,
            title: "Brand Green",
          ),
          FoundationColorListView(
            colors: logic.yellowColors,
            title: "Secondary Yellow",
          ),
          FoundationColorListView(
            colors: logic.redColors,
            title: "Red",
          ),
          FoundationColorListView(
            colors: logic.greyColors,
            title: "Neutral / Grey",
          ),
          FoundationColorListView(
            colors: logic.pinkColors,
            title: "Pink",
          ),
          const VerticalSpacer(128),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "TYPOGRAPHY",
              style: TextStyle(
                color: blue1200,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _containerTitle("Body"),
          const VerticalSpacer(14),
          // _textTable(),
          StickyBodyTable(),
          const VerticalSpacer(40),
          _containerTitle("Heading"),
          StickyHeaderTable(),
          const VerticalSpacer(40),
          _containerTitle("Display"),
          _headings(),
          const VerticalSpacer(40),
          _mSpecialCase(),
          const VerticalSpacer(40),
        ],
      ),
    );
  }

  Padding _headings() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Table(

            columnWidths: const {
              0: FixedColumnWidth(50),
              1: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildStyledRow(
                'M Pop',
                Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: AppTextStyles.displayM(
                      color: primaryDarkColor, poppins: true),
                ),
              ),
              _buildStyledRow(
                'M Fig',
                Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: AppTextStyles.displayM(color: primaryDarkColor),
                ),
              ),
            ],
          ),
    );
  }

  SingleChildScrollView _mSpecialCase() {
    return const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                'M',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: darkBlueColor,
                ),
              ),
              SizedBox(width: 72,),
              SizedBox(
                width: 181,
                child: Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 1.68,
                    color: primaryDarkColor,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              SizedBox(width: 72,),
              SizedBox(
                width: 181,
                child: Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 1.68,
                    color: primaryDarkColor,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              SizedBox(width: 72,),
              SizedBox(
                width: 181,
                child: Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 1.68,
                    color: primaryDarkColor,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
            ],
          ),
        );
  }

  Container _containerTitle(String title) {
    return Container(
      color: primaryLightColor,
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
            color: darkBlueColor, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  TableRow _buildSeperatorContainer() {
    return TableRow(children: [
      Container(
        color: primaryLightColor,
        height: 32,
        width: 70,
      ),
      const SizedBox(),
    ]);
  }

  TableRow _buildStyledRow(String size, Widget secondColumn) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            size,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF003366), // darkBlueColor
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: secondColumn,
        ),
      ],
    );
  }

  SingleChildScrollView _textTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFDCDFE3), // Border color for the table
            width: 1, // Border width
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Size')),
            DataColumn(label: Text('Light')),
            DataColumn(label: Text('Regular')),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('XS')),
              const DataCell(Text('-')),
              DataCell(
                Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: AppTextStyles.headingXSMedium(color: primaryDarkColor),
                ),
              ),
            ]),
            DataRow(cells: [
              const DataCell(Text('S')),
              const DataCell(Text('-')),
              DataCell(
                Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: AppTextStyles.headingXSMedium(color: primaryDarkColor),
                ),
              ),
            ]),
            DataRow(cells: [
              const DataCell(Text('M')),
              DataCell(
                Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: AppTextStyles.headingXSMedium(color: primaryDarkColor),
                ),
              ),
              DataCell(
                Text(
                  'The quick brown fox jumped over the lazy dog.',
                  style: AppTextStyles.headingXSMedium(color: primaryDarkColor),
                ),
              ),
            ]),
            const DataRow(cells: [
              DataCell(Text('L')),
              DataCell(Text('-')),
              DataCell(Text('-')),
            ]),
          ],
        ),
      ),
    );
  }
}
