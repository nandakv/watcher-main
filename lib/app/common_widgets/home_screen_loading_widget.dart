import 'package:flutter/material.dart';

import 'shimmer_loading/skeleton_loading_widget.dart';

class HomeScreenLoadingWidget extends StatelessWidget {
  const HomeScreenLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff151742),
                Color(0xff1C468B),
                Color(0xff1C478D),
              ],
              stops: [0.0, 0.63, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: SkeletonLoadingWidget(
              skeletonLoadingType: SkeletonLoadingType.home,
            ),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 20,
            ),
            child: SkeletonLoadingWidget(
              skeletonLoadingType: SkeletonLoadingType.homeBottom,
            ),
          ),
        ),
      ],
    );
  }
}
