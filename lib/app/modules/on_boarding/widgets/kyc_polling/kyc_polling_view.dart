import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../res.dart';
import '../../../../firebase/analytics.dart';
import '../result_page_widget.dart';
import 'kyc_polling_logic.dart';

class KycPollingView extends StatefulWidget {
  const KycPollingView({Key? key}) : super(key: key);

  @override
  State<KycPollingView> createState() => _KycPollingViewState();
}

class _KycPollingViewState extends State<KycPollingView> with AfterLayoutMixin {
  final logic = Get.find<KycPollingLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycPollingLogic>(
      builder: (logic) {
        return logic.isKycSuccess
            ? const _KYCSuccessWidget()
            : const ResultPage(
                title: "Sit Back!",
                subTitle:
                    "Processing your application. Please check in sometime.",
                assetImage: Res.Relax,
                resultPageImageType: ResultPageImageType.svg,
                state: ResultPageState.processing,
              );
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.startPolling();
    AppAnalytics.trackWebEngageUser(userAttributeName: "isKycFlowCompleted",userAttributeValue:true);
  }
}

class _KYCSuccessWidget extends StatelessWidget {
  const _KYCSuccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Res.verified_svg,
          ),
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            child: Text(
              'Your KYC verification is Successful!',
              style: TextStyle(
                color: Color(0xff344157),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
