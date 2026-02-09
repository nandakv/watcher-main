import 'package:flutter/services.dart';

abstract class DOBEvents {
  onMonthChange();
  onMonthRawKey(LogicalKeyboardKey rawKey);

  onDayChange();
  onDayRawKey(LogicalKeyboardKey rawKey);

  onYearChange();
  onYearRawKey(LogicalKeyboardKey rawKey);
}
