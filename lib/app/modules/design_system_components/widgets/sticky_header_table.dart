import 'package:flutter/material.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../../utils/app_text_styles.dart';

class StickyHeaderTable extends StatelessWidget {
  static const Color headerColor = Color(0xFF003366); // darkBlueColor
  static const Color cellColor = Color(0xFFF5F5F5); // lightGreyColor
  static const Color primaryDarkColor = Color(0xFF333333); // Cell text color

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    const headersRow = ['-', 'Medium', 'Semi Bold'];
    const headersColumn = ['XS', 'S', 'M', 'L', 'XL Pop', 'XL Fig'];

    // Mapping of styles with color
    final styles = {
      'XS': {
        'Medium': AppTextStyles.headingXSMedium(color: primaryDarkColor),
        'Semi Bold': AppTextStyles.headingXSBold(color: primaryDarkColor),
      },
      'S': {
        'Medium': AppTextStyles.headingSMedium(
          color: primaryDarkColor,
        ),
        'Semi Bold': AppTextStyles.headingSSemiBold(
          color: primaryDarkColor,
        ),
      },
      'M': {
        'Medium': AppTextStyles.headingMedium(color: primaryDarkColor),
        'Semi Bold': AppTextStyles.headingMSemiBold(color: primaryDarkColor),
      },
      'L': {
        'Medium': AppTextStyles.headingLarge(
          color: primaryDarkColor,
        ),
        'Semi Bold': AppTextStyles.headingLSemiBold(
          color: primaryDarkColor,
        ),
      },
      'XL Pop': {
        'Medium': AppTextStyles.poppinsHeadingXL(
          color: primaryDarkColor,
        ),
        'Semi Bold': AppTextStyles.poppinsHeadingXLMedium(
          color: primaryDarkColor,
        ),
      },
      'XL Fig': {
        'Medium': AppTextStyles.figtreeXL(
          color: primaryDarkColor,
        ),
        'Semi Bold': AppTextStyles.figTreeXLMedium(
          color: primaryDarkColor,
        ),
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

      rows.add(TableRow(
        children: cells,
      ));
    }

    return rows;
  }
}
