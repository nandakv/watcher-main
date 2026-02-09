import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/res.dart';

class BankNameWidget extends StatelessWidget {
  const BankNameWidget(
      {Key? key,
      required this.onClose,
      required this.bankName,
      this.hideClose = false})
      : super(key: key);

  final String bankName;
  final Function onClose;
  final bool hideClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _bankNameBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                bankName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: _bankNameTextStyle(),
              ),
            ),
            if (hideClose)
              InkWell(
                onTap: () => onClose(),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SvgPicture.asset(Res.pencil_icon),
                ),
              ),
          ],
        ),
      ),
    );
  }

  TextStyle _bankNameTextStyle() {
    return const TextStyle(
        fontSize: 14, color: Color(0xff363840), letterSpacing: 0.13);
  }

  BoxDecoration get _bankNameBoxDecoration {
    return BoxDecoration(
      color: const Color(0xffF3F4FA),
      borderRadius: BorderRadius.circular(50),
      boxShadow: const [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            offset: Offset(0, 3),
            blurRadius: 6)
      ],
    );
  }
}
