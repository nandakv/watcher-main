import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

class TextRowWidget extends StatelessWidget {
  TextRowWidget({Key? key, required this.titles}) : super(key: key);

  List<String> titles;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: List.generate(
          titles.length,
          (index) {
            if (index % 2 != 0) return buildWidgetSpan();
            return TextSpan(
                text: titles[index],
                style: const TextStyle(fontSize: 10, color: infoTextColor));
          },
        ),
      ),
    );
  }

  WidgetSpan buildWidgetSpan() {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          height: 3,
          width: 3,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: dotTextColor),
        ),
      ),
    );
  }
}
