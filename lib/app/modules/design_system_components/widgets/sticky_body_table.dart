import 'package:flutter/material.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../utils/app_text_styles.dart';

class StickyBodyTable extends StatelessWidget {
  static const Color headerColor = Color(0xFF003366); // darkBlueColor
  static const Color cellColor = Color(0xFFF5F5F5); // lightGreyColor
  static const Color primaryDarkColor = Color(0xFF333333); // Cell text color

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          border: TableBorder.all(color: Colors.grey.shade400),
          defaultColumnWidth: const FixedColumnWidth(120),
          children: _buildTableRows(),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    // Define header row and column contents
    const headersRow = ['-', 'Light', 'Regular', 'Medium', 'Semi Bold'];
    const headersColumn = ['XS', 'S', 'M', 'L'];

    // Mapping of styles with color
    final styles = {
      'XS': {
        'Light': AppTextStyles.bodyXSLight(color: primaryDarkColor),
        'Regular': AppTextStyles.bodyXSRegular(color: primaryDarkColor),
        'Medium': AppTextStyles.bodyXSMedium(color: primaryDarkColor),
        'Semi Bold': AppTextStyles.bodyXSSemiBold(color: primaryDarkColor),
      },
      'S': {
        'Light': '-',
        'Regular': AppTextStyles.bodySRegular(color: primaryDarkColor),
        'Medium': AppTextStyles.bodySMedium(color: primaryDarkColor,),
        'Semi Bold': AppTextStyles.bodySSemiBold(color: primaryDarkColor,),
      },
      'M': {
        'Light': AppTextStyles.bodyMLight(color: primaryDarkColor),
        'Regular': AppTextStyles.bodyMRegular(color: primaryDarkColor),
        'Medium': AppTextStyles.bodyMMedium(color: primaryDarkColor),
        'Semi Bold': '-',
      },
      'L': {
        'Light': '-',
        'Regular': '-',
        'Medium': AppTextStyles.bodyLMedium(color: primaryDarkColor,),
        'Semi Bold': AppTextStyles.bodyLSemiBold(color: primaryDarkColor,),
      },
    };

    // Build rows for the table
    final rows = <TableRow>[
      // Add header row
      TableRow(
        children: headersRow
            .map(
              (header) => Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              header,
              style: const TextStyle(
                color: headerColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
            .toList(),
      ),
    ];

    // Add content rows
    for (final header in headersColumn) {
      final cells = headersRow.map((column) {
        // Skip the top-left cell (row header)
        if (header == '-' && column == '-') {
          return Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: const Text(''),
          );
        }

        // First column is row headers
        if (column == '-') {
          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              header,
              style: const TextStyle(
                color: headerColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        // Add the cell contents
        final textStyle = styles[header]?[column];
        return Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: textStyle is TextStyle
              ? Text(
            'The quick brown fox jumped over the lazy dog.',
            style: textStyle,
          )
              : const Text('-'),
        );
      }).toList();

      rows.add(TableRow(children: cells,));
    }

    return rows;
  }
}