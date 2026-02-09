import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/design_system_components/design_system_components_logic.dart';

class FoundationColorListView extends StatelessWidget {
  List<DesignColorModel> colors;
  String title;

  FoundationColorListView(
      {super.key, required this.colors, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29,vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black
          ),),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFDCDFE3), // Border color for the table
                width: 1, // Border width
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Value")),
                DataColumn(label: Text("Sample")),
              ],
              dataRowHeight: 56,
              showCheckboxColumn: false,
              rows: colors.map((colorItem) {
                return DataRow(
                  color: colorItem.fillColor,
                  cells: [
                    DataCell(Text(colorItem.title)),
                    DataCell(Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: colorItem.color,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '#${colorItem.color.value.toRadixString(16).substring(
                              2).toUpperCase()}',
                        ),
                      ],
                    )),
                  ],
                );
              }).toList(),
              border: TableBorder.all(
                color: const Color(0xFFDCDFE3),
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
