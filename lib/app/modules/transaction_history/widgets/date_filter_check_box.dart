// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:privo/app/common_widgets/custom_check_box.dart';
// import 'package:privo/app/modules/transaction_history/transaction_history_logic.dart';

// import '../model/date_filter_type_model.dart';

// class DateFilterCheckBox extends StatelessWidget {
//   final String title;
//   final DateFilterType dateFilter;

//   const DateFilterCheckBox(
//       {Key? key, required this.title, required this.dateFilter})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<TransactionHistoryLogic>(builder: (logic) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CustomCheckbox(
//               color: const Color(0xFF161742),
//               height: 20,
//               width: 20,
//               isChecked: dateFilter == logic.selectedDateFilterType.type,
//               checkColor: Colors.white,
//               iconSize: 14,
//               onChanged: (value) {
//                 //   logic.onCheckBoxChanged(value, dateFilter);
//               },
//             ),
//             const SizedBox(
//               width: 8,
//             ),
//             Center(
//               child: Text(
//                 title,
//                 style: _titleTextStyle(),
//               ),
//             )
//           ],
//         ),
//       );
//     });
//   }

//   TextStyle _titleTextStyle() {
//     return const TextStyle(
//       color: Color(0xFF404040),
//       fontSize: 12,
//       fontFamily: 'Figtree',
//       fontWeight: FontWeight.w500,
//     );
//   }
// }
