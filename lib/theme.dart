import 'package:flutter/material.dart';
import 'package:freecell/functions/other.dart';

import 'data.dart';

ThemeData themeData({
  required Color tc,
  required Color bc,
}) {
  return ThemeData(
    fontFamily: pf['font'],
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontWeight: FontWeight.bold, color: tc, fontFamily: pf['font']),
      bodyLarge: TextStyle(fontWeight: FontWeight.bold, color: tc, fontFamily: pf['font']),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: bc,
      contentTextStyle: TextStyle(color: tc, fontWeight: FontWeight.bold),
    ),
    primaryColor: tc,
    inputDecorationTheme: InputDecorationTheme(
      counterStyle: TextStyle(color: tc, fontWeight: FontWeight.bold),
      labelStyle: TextStyle(color: tc, fontWeight: FontWeight.bold),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: tc, width: 2),
      ),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: tc, width: 2)),
    ),
    dividerColor: tc,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: tc),
    dialogBackgroundColor: bc,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: textColor(),
      shadowColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: textColor(),
        fontFamily: pf['font'],
        fontSize: 20,
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: tc,
      style: ListTileStyle.drawer,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: bc,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      shape: StadiumBorder(
        side: BorderSide(color: tc, width: 2),
      ),
      checkmarkColor: bc,
      selectedColor: tc,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: Colors.black,
    navigationBarTheme: NavigationBarThemeData(backgroundColor: bc),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    canvasColor: Colors.transparent,
    cardTheme: CardTheme(
      elevation: 6,
      shadowColor: tc,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      color: tc,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    //useMaterial3: true,
    iconTheme: IconThemeData(color: tc),
    shadowColor: tc,
    colorScheme: ColorScheme(
      primary: tc,
      onPrimary: bc,
      background: bc,
      onBackground: tc,
      surface: bc,
      onSurface: tc,
      error: tc,
      onError: bc,
      brightness: Brightness.light,
      secondary: tc,
      onSecondary: bc,
    ).copyWith(background: bc).copyWith(background: bc),
  );
}
