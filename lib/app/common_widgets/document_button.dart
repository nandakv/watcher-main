import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class DocumentButton extends StatelessWidget {
  const DocumentButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.borderColor = primaryDarkColor,
  }) : super(key: key);
  final String title;
  final VoidCallback? onPressed;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return _documentButton(title: title, onPressed: onPressed);
  }

  OutlinedButton _documentButton(
      {required String title, required VoidCallback? onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: _documentButtonStyle(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            Res.download,
            colorFilter: ColorFilter.mode(
              borderColor,
              BlendMode.srcATop,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                  color: borderColor,
                  fontSize: 10,
                  letterSpacing: 0.16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _documentButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            width: 0.5,
            color: borderColor,
          ),
        ),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 9,
        ),
      ),
      foregroundColor: MaterialStateProperty.all(darkBlueColor),
      side: MaterialStateProperty.all(
        BorderSide(color: borderColor),
      ),
    );
  }
}
