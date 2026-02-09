import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/emi_calculator/widgets/calculator_screen.dart';
import 'package:privo/app/modules/emi_calculator/widgets/emi_calculator_intro.dart';
import 'package:privo/app/modules/emi_calculator/widgets/lpc_grid_screen.dart';
import 'package:privo/app/modules/on_boarding/model/privo_app_bar_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import 'emi_calculator_logic.dart';

class EmiCalculatorView extends StatefulWidget {
  EmiCalculatorView({Key? key}) : super(key: key);

  @override
  State<EmiCalculatorView> createState() => _EmiCalculatorViewState();
}

class _EmiCalculatorViewState extends State<EmiCalculatorView>
    with AfterLayoutMixin {
  final logic = Get.find<EmiCalculatorLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmiCalculatorLogic>(builder: (logic) {
      return WillPopScope(
        onWillPop: ()async{
          return logic.onWillPop();
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _appBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _computeBody(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _computeBody(){
    switch (logic.emiCalculatorState) {
      case EmiCalculatorState.intro:
        return EmiCalculatorIntro();
      case EmiCalculatorState.lpcListScreen:
        return LpcGridScreen();
      case EmiCalculatorState.calculator:
        return CalculatorScreen();
      case EmiCalculatorState.loading:
        return Container();
    }
  }

  Widget _appBar() {
    switch (logic.emiCalculatorState) {
      case EmiCalculatorState.intro:
      case EmiCalculatorState.loading:
        return SizedBox();
      default:
        return PrivoAppBar(
            model: PrivoAppBarModel(
                title: '',
                isTitleVisible: false,
                progress: 0.0,
                onClosePressed: (){
                  logic.onWillPop();
                },
                appBarText: 'EMI Calculator'),
            showFAQ: true);
    }
    ;
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }
}
