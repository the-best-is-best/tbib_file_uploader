import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme(),
    //  textTheme: textTheme(),
    // colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.white),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //     style: ElevatedButton.styleFrom(foregroundColor: Colors.white)),
    //colorSchemeSeed: mainColor,
    //  primaryColor: Colors.white,
    // primaryColorLight: mainColor,
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    // borderSide: const BorderSide(),
    gapPadding: 3,
  );
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    // errorBorder: outlineInputBorder.copyWith(
    //     borderSide: const BorderSide(color: Colors.red)),
    border: outlineInputBorder,
  );
}

// TextTheme textTheme() {
//   return const TextTheme(
//     bodyText1: TextStyle(color: mainColor),
//     bodyText2: TextStyle(color: mainColor),
//   );
// }

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}
