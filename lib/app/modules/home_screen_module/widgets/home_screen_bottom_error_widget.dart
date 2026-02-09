import 'package:flutter/material.dart';

import '../../../common_widgets/gradient_button.dart';

class HomeScreenBottomErrorWidget extends StatelessWidget {
  const HomeScreenBottomErrorWidget({
    Key? key,
    required this.retry,
  }) : super(key: key);

  final Function() retry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          )
        ],
      ),
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text("Something Went Wrong"),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GradientButton(
              onPressed: () => retry(),
              title: "Retry",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
