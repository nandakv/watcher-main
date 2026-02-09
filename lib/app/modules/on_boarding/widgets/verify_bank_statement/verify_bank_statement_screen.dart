// import 'dart:math';
//
// import 'package:after_layout/after_layout.dart';
// import 'package:privo/app/common_widgets/blue_button.dart';
// import 'package:privo/app/common_widgets/exit_page.dart';
// import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
// import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
// import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/bank_statement_selector.dart';
// import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';
// import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_top_section.dart';
// import 'package:privo/app/theme/app_colors.dart';
// import 'package:privo/app/theme/app_text_theme.dart';
// import 'package:privo/res.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
//
// import '../../../../utils/no_leading_space_formatter.dart';
// import '../bank_details/bank_name_widget.dart';
//
// class VerifyBankStatementScreen extends StatefulWidget {
//   const VerifyBankStatementScreen({Key? key}) : super(key: key);
//
//   @override
//   State<VerifyBankStatementScreen> createState() =>
//       _VerifyBankStatementScreenState();
// }
//
// class _VerifyBankStatementScreenState extends State<VerifyBankStatementScreen>
//     with AfterLayoutMixin {
//   final logic = Get.find<VerifyBankStatementLogic>();
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<VerifyBankStatementLogic>(
//         id: 'bank_names',
//         builder: (logic) {
//           switch (logic.getBankNames) {
//             case OnBoardingState.initialized:
//               return const SafeArea(
//                   child: Center(child: CircularProgressIndicator()));
//             case OnBoardingState.loading:
//               return const SafeArea(
//                   child: Center(child: CircularProgressIndicator()));
//             case OnBoardingState.success:
//               return SafeArea(child: bankSuccessWidget());
//             case OnBoardingState.error:
//               return SafeArea(
//                 child: ExitPage(
//                   assetImage: Res.sad_illustration,
//                   showButton: true,
//                 ),
//               );
//           }
//         });
//   }
//
//   Widget bankSuccessWidget() {
//     return GetBuilder<VerifyBankStatementLogic>(
//         id: 'top_section',
//         builder: (logic) {
//           return logic.isBankStatementLoading
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (!logic.isBankSelectorEditing)
//                         VerifyBankStatementTopSection(),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         children: [
//                           SvgPicture.asset(Res.Bank),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "Select your Salary Bank",
//                             style: buildMainTextStyle(),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 20, horizontal: 10),
//                         child: logic.bankNameController.text.isEmpty
//                             ? TypeAheadFormField<String>(
//                                 enabled: !logic.isLoading,
//                                 onSuggestionSelected: (suggestion) {
//                                   logic.bankNameController.text = suggestion;
//                                   logic.selectedBank = logic.banks
//                                       .where((element) => element
//                                           .perfiosBankName
//                                           .toLowerCase()
//                                           .contains(suggestion.toLowerCase()))
//                                       .toList()[0];
//
//                                   Get.log(
//                                       "statement ${logic.selectedBank.statementSupported}  netbanking ${logic.selectedBank.netbankingSupported}");
//
//                                   logic.verifyBankStatementChange();
//                                 },
//                                 suggestionsBoxDecoration:
//                                     const SuggestionsBoxDecoration(
//                                         elevation: 0),
//                                 itemBuilder: (context, itemData) {
//                                   return ListTile(
//                                     title: Text(itemData),
//                                   );
//                                 },
//                                 suggestionsCallback: (pattern) {
//                                   return logic.bankNames
//                                       .where((element) => element
//                                           .toLowerCase()
//                                           .contains(pattern.toLowerCase()))
//                                       .toList();
//                                 },
//                                 autoFlipDirection: true,
//                                 autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                 initialValue: null,
//                                 hideSuggestionsOnKeyboardHide: true,
//                                 validator: (value) =>
//                                     value!.isEmpty ? "Select a Bank" : null,
//                                 textFieldConfiguration: TextFieldConfiguration(
//                                   onTap: () {
//                                     logic.bankNameController.clear();
//                                     logic.isBankSelectorEditing = true;
//                                     logic.update(['top_section']);
//                                   },
//                                   inputFormatters: [NoLeadingSpaceFormatter()],
//                                   controller: logic.bankNameController,
//                                   focusNode: logic.bankNameFocus,
//                                   decoration: buildInputDecoration(logic),
//                                 ),
//                               )
//                             : BankNameWidget(
//                                 bankName: logic.selectedBank.perfiosBankName,
//                                 onClose: logic.onVerifyBankStatementBackPressed,
//                                 hideClose: false,
//                               ),
//                       ),
//                       if (logic.isVerifyBankStatementFilled)
//                         BankStatementSelector(),
//                       // const Spacer(),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       GetBuilder<VerifyBankStatementLogic>(builder: (logic) {
//                         return Center(
//                           child: BlueButton(
//                             onPressed: () => logic.bankSelectorIndex != 0
//                                 ? logic.onVerifyBankStatementContinueTapped()
//                                 : {},
//                             buttonColor: logic.bankSelectorIndex != 0
//                                 ? activeButtonColor
//                                 : inactiveButtonColor,
//                             isLoading: logic.isLoading,
//                           ),
//                         );
//                       }),
//                       const SizedBox(
//                         height: 30,
//                       )
//                     ],
//                   ),
//                 );
//         });
//   }
//
//   InputDecoration buildInputDecoration(VerifyBankStatementLogic logic) {
//     return InputDecoration(
//       fillColor: logic.bankNameController.text.isEmpty
//           ? Colors.transparent
//           : const Color(0xffF3F4FA),
//       filled: logic.bankNameController.text.isNotEmpty,
//       contentPadding: const EdgeInsets.all(10),
//       prefixIcon: logic.bankNameController.text.isEmpty
//           ? const Icon(Icons.search)
//           : null,
//       hintText: "Search by name",
//       // labelText: "Search bank by name",
//       isDense: true,
//       alignLabelWithHint: true,
//       border: OutlineInputBorder(
//         borderSide: const BorderSide(color: Color(0xffE5E5E5), width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
//
//   TextStyle buildMainTextStyle() {
//     return const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.normal,
//         color: Color(0xFF969697),
//         letterSpacing: 0.12);
//   }
//
//   @override
//   void afterFirstLayout(BuildContext context) {
//     logic.onAfterFirstLayout();
//   }
// }
