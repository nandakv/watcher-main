import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/modules/on_boarding/widgets/employment_type/employment_type_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/circle_icon_widget.dart';

class EmploymentTypeScreen extends StatelessWidget {

  const EmploymentTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 50,
            ),
            child: Text(
              "Choose a profile that suits you",
              style: _titleTextStyle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetBuilder<EmploymentTypeLogic>(
                  id: 'self_employed_ic',
                  builder: (logic) {
                    return CircleIconWidget(
                      index: 1,
                      title: "Self-Employed",
                      currentIndex: logic.getempSelectorIndex,
                      onTap: (){
                        logic.setempSelectorIndex(1);
                      },
                      asset_path: Res.self_employed,
                    );
                  }),
              const SizedBox(width: 50,),
              GetBuilder<EmploymentTypeLogic>(
                  id: 'salaried_ic',
                  builder: (logic) {
                    return CircleIconWidget(
                      index: 2,
                      title: "Salaried",
                      currentIndex: logic.getempSelectorIndex,
                      onTap: (){
                        logic.setempSelectorIndex(2);
                      },
                      asset_path: Res.Salaried,
                    );
                  }),

            ],
          ),
        ),
        const Spacer(),
        GetBuilder<EmploymentTypeLogic>(
          builder: (logic) {
            return Center(
              child: BlueButton(
                onPressed: () => logic.onEmploymentContinueTapped(),
                buttonColor: logic.empSelectorIndex > 0
                    ? activeButtonColor
                    : inactiveButtonColor,
                isLoading: logic.isLoading,
              ),
            );
          },
        ),
        const SizedBox(height: 30)
      ],
    );
  }

  TextStyle get _titleTextStyle {
    return const TextStyle(
      fontSize: 16,
      color: Color(0xFF344157),
      letterSpacing: 0.12,
      fontWeight: FontWeight.w600,
    );
  }
}
