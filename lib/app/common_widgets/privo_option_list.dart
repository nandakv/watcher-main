import 'package:flutter/material.dart';

import 'custom_check_box.dart';

/// Currently it code will work only when there is 1 selection
class PrivoOptionList<T> extends StatelessWidget {
  final List<T> values;
  final ValueChanged<T> onChecked;
  final ValueChanged<T> onUnchecked;
  final T? selected;
  const PrivoOptionList(
      {Key? key,
      required this.values,
      required this.onChecked,
      required this.onUnchecked,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: values.map((e) => rowItem(object: e)).toList(),
    );
  }

  Widget rowItem({required T object}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCheckbox(
            color: const Color(0xFF161742),
            height: 20,
            width: 20,
            isChecked: selected == object,
            checkColor: Colors.white,
            iconSize: 14,
            onChanged: (value) {
              if (value == null) return;
              if (value) {
                onChecked(object);
              } else {
                onUnchecked(object);
              }
            },
          ),
          const SizedBox(
            width: 8,
          ),
          Center(
            child: Text(
              object.toString(),
              style: _titleTextStyle(),
            ),
          )
        ],
      ),
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      color: Color(0xFF404040),
      fontSize: 12,
      fontFamily: 'Figtree',
      fontWeight: FontWeight.w500,
    );
  }
}
