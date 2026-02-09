import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appThemeData = ThemeData(
    scaffoldBackgroundColor: Colors.grey[50],
    primarySwatch: blue,
    primaryColor: activeButtonColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkBlueColor,
    ),
    dialogTheme: const DialogTheme(
      surfaceTintColor: Colors.white,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Figtree');

///Withdrawal screen theme
final ThemeData withdrawalScreenThemeData = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.montserratTextTheme());
