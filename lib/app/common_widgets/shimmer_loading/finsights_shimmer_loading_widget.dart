import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/common_widgets/app_lottie_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import '../../../components/skeletons/skeletons.dart';
import '../../../res.dart';
import '../../theme/app_colors.dart';

class FinSightsShimmerLoadingWidget extends StatelessWidget {
  const FinSightsShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topLoaderWidget(),
            verticalSpacer(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: SkeletonItem(
                child: skeletonWidget(height: 5, width: 85),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SkeletonItem(
                child: Row(
                  children: [
                    skeletonWidget(height: 19, width: 73),
                    const SizedBox(
                      width: 8,
                    ),
                    skeletonWidget(height: 19, width: 73),
                    const SizedBox(
                      width: 8,
                    ),
                    skeletonWidget(height: 19, width: 73),
                  ],
                ),
              ),
            ),
            _barGraphWidget(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 16, top: 45),
              child: SkeletonItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    skeletonWidget(height: 5, width: 85),
                    skeletonWidget(height: 19, width: 73),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SkeletonItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    skeletonWidget(height: 19, width: 73),
                    const SizedBox(
                      width: 10,
                    ),
                    skeletonWidget(height: 19, width: 73),
                  ],
                ),
              ),
            ),
            _shimmerList(),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 25, bottom: 16),
              child: skeletonWidget(height: 5, width: 85),
            ),
            const VerticalSpacer(10),
            _shimmerLineGraph()
          ],
        ),
      ),
    );
  }

  Container _shimmerLineGraph() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(left: 18, bottom: 40, right: 18),
        decoration: BoxDecoration(
          border: Border.all(
            color: lightGrayColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: const AppLottieWidget(
          assetPath: Res.shimmerEffectLineGraph,
          width: double.infinity,
          boxFit: BoxFit.fitWidth,
        ));
  }

  SkeletonItem _shimmerList() {
    return SkeletonItem(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: lightGrayColor,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      skeletonWidget(height: 5, width: 85),
                      skeletonWidget(height: 5, width: 27),
                    ],
                  ),
                  verticalSpacer(10),
                  skeletonWidget(height: 5, width: 170),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Stack _topLoaderWidget() {
    return Stack(children: [
      SkeletonItem(child: Container(height: 317, color: Colors.grey)),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, top: 20),
          child: SvgPicture.asset(Res.appBarBackIconSvg),
        ),
      )
    ]);
  }

  SkeletonItem _barGraphWidget() {
    return SkeletonItem(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(
            color: lightGrayColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                skeletonWidget(height: 5, width: 20),
                const SizedBox(height: 20),
                skeletonWidget(height: 5, width: 20),
                const SizedBox(height: 20),
                skeletonWidget(height: 5, width: 20),
                const SizedBox(height: 20),
                skeletonWidget(height: 5, width: 20),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 84,
                      width: 40,
                    ),
                    Column(
                      children: [
                        skeletonWidget(height: 69, width: 20),
                        const VerticalSpacer(10),
                        skeletonWidget(height: 5, width: 20),
                        const VerticalSpacer(20),
                        _skeletonWithDotWidget(),
                      ],
                    ),
                    const SizedBox(
                      height: 45,
                      width: 20,
                    ),
                    Column(
                      children: [
                        skeletonWidget(height: 115, width: 20),
                        const VerticalSpacer(10),
                        skeletonWidget(height: 5, width: 20),
                        const VerticalSpacer(35),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                      width: 20,
                    ),
                    Column(
                      children: [
                        skeletonWidget(height: 43, width: 20),
                        const VerticalSpacer(10),
                        skeletonWidget(height: 5, width: 20),
                        const VerticalSpacer(20),
                        _skeletonWithDotWidget(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _skeletonWithDotWidget() {
    return Row(
      children: [
        skeletonWidget(height: 10, width: 10),
        const SizedBox(width: 5),
        Column(
          children: [
            // const VerticalSpacer(5),
            skeletonWidget(height: 5, width: 56),
            const VerticalSpacer(5),

            skeletonWidget(height: 5, width: 56),
          ],
        ),
      ],
    );
  }

  Container skeletonWidget({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: lightGrayColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
