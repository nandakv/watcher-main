import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../utils/app_functions.dart';

class DayMonthYear extends StatelessWidget{
  final DateTime date;

  const DayMonthYear({Key? key, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
 return RichText(
   text: TextSpan(
     children: [
       TextSpan(
           text: DateFormat('d').format(date),
           style:
           _titleTextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
       WidgetSpan(
         child: Text(
           AppFunctions().getDayOfMonthSuffix(date.day),
           style: _titleTextStyle(fontWeight: FontWeight.w600, fontSize: 12),
         ),
         alignment: PlaceholderAlignment.top,
       ),
       TextSpan(
           text: DateFormat(' MMM, yyyy').format(date),
           style:
           _titleTextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
     ],
   ),
 );
  }
  TextStyle _titleTextStyle(
      {double fontSize = 8, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize,
        letterSpacing: 0.18,
        fontWeight: fontWeight,
        fontFamily: 'Figtree',
        color: const Color(0xFF404040));
  }
}