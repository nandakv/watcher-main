import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/horizontal_option_chooser_widget/horizontal_option_chooser_item.dart';
import 'package:privo/app/common_widgets/horizontal_option_chooser_widget/horizontal_option_item.dart';

class HorizontalOptionChooserWidget extends StatefulWidget {
  const HorizontalOptionChooserWidget({
    Key? key,
    required this.items,
    required this.onTap,
    required this.currentIndex,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween
  })  : assert(items.length <= 3 && items.length >= 1,
            'The length of items must be between 1 and 3'),
        super(key: key);

  ///The length of [items] must be between 1 and 3
  final List<HorizontalOptionItem> items;
  final Function(int index)? onTap;
  final int? currentIndex;
  final MainAxisAlignment mainAxisAlignment;

  @override
  State<HorizontalOptionChooserWidget> createState() =>
      _HorizontalOptionChooserWidgetState();
}

class _HorizontalOptionChooserWidgetState
    extends State<HorizontalOptionChooserWidget> with AfterLayoutMixin {
  final _parentWidgetKey = GlobalKey();

  double? itemHeight;
  double? itemWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: _parentWidgetKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: widget.mainAxisAlignment,
      children: List.generate(
        widget.items.length,
        (index) => Flexible(
          child: InkWell(
            onTap: () {
              widget.onTap?.call(index);
            },
            child: HorizontalOptionChooserItem(
              index: index,
              item: widget.items[index],
              isSelected:
                  widget.currentIndex != null && widget.currentIndex == index,
              height: itemHeight,
              width: itemWidth,
            ),
          ),
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    if (_parentWidgetKey.currentContext != null &&
        _parentWidgetKey.currentContext != null) {
      double parentWidth = _parentWidgetKey.currentContext!.size!.width;
      Get.log("parentWidth = $parentWidth");
      setState(() {
        itemWidth = (parentWidth / 3) - 25;
        itemHeight = itemWidth! - (itemWidth! * (15 / 100));
      });
    }
  }
}
