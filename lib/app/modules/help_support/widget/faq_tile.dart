import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

class FAQTile extends StatefulWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final bool isRightArrow;
  final Function(bool isExpanded) onClicked;

  const FAQTile({
    Key? key,
    required this.question,
    required this.answer,
    this.isExpanded = false,
    this.isRightArrow = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool isExpanded = false;

  @override
  void initState() {
    isExpanded = widget.isExpanded;
    super.initState();
  }

  Widget _question() {
    return Text(
      widget.question,
      style: TextStyle(
        fontSize: 14,
        fontWeight: isExpanded ? FontWeight.w500 : FontWeight.normal,
        color: navyBlueColor,
      ),
    );
  }

  Widget _arrowButton() {
    if(widget.isRightArrow){
      return InkWell(
          onTap: (){
            widget.onClicked(isExpanded);
          },
          child: Icon(Icons.arrow_right));
    }
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
        widget.onClicked(isExpanded);
      },
      child: AnimatedSwitcher(
        duration: const Duration(microseconds: 350),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: isExpanded
                ? const Icon(
                    Icons.keyboard_arrow_up,
                  )
                : const Icon(
                    Icons.keyboard_arrow_down,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _answer() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isExpanded
          ? Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                widget.answer,
                style: const TextStyle(
                  fontSize: 12,
                  color: darkBlueColor,
                  height: 1.6,
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _question()),
              _arrowButton(),
            ],
          ),
          _answer(),
        ],
      ),
    );
  }
}
