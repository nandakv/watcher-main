import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/home_screen_loading_widget.dart';
import '../../../../../res.dart';
import '../../../../common_widgets/exit_page.dart';
import '../../../../common_widgets/gradient_button.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/app_functions.dart';
import '../../mixins/app_form_mixin.dart';
import 'offer_logic.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({Key? key}) : super(key: key);

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>  {
  final logic = Get.find<OfferLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferLogic>(
      builder: (logic) {
        return logic.isPageLoading
            ? const HomeScreenLoadingWidget()
            : _finalOfferWidget();
      },
    );
  }

  Widget _finalOfferWidget() {
    return GetBuilder<OfferLogic>(
      builder: (logic) {
        return logic.isError
            ? ExitPage(
                assetImage: Res.sad_illustration,
              )
            : Column(
                children: [
                  Expanded(
                    child: logic.computeOfferWidget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!logic.isPageLoading &&
                      logic.loanProductCode != LoanProductCode.clp)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GetBuilder<OfferLogic>(
                        id: logic.BUTTON_ID,
                        builder: (logic) {
                          return Column(
                            children: [
                              if (logic.loanProductCode !=
                                  LoanProductCode.clp) ...[
                                const SizedBox(
                                  height: 4,
                                ),
                                 Text(
                                  logic.responseModel.infoText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: navyBlueColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                              GradientButton(
                                title: logic.computeButtonTitle(),
                                onPressed: () =>
                                    logic.onOfferContinueButtonPress(),
                                isLoading: logic.isButtonLoading,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
      },
    );
  }
}
