// theme.dart
import "../imports.dart";

/// theme for normal use
var theme = ThemeData(
  textTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
  ),
  buttonTheme: ButtonThemeData(),
  appBarTheme: AppBarTheme(
    color: Colors.blue,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  iconTheme: IconThemeData(
    color: Colors.black,
  ),
  indicatorColor: Colors.green.shade200,
);
//
//
//
/// theme for dark mode (ios) or dark theme (android)
var darkTheme = ThemeData(
  textTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
      fontSize: 10,
    ),
  ),
  appBarTheme: AppBarTheme(
    // color: Colors.red,
    color: Colors.blue.shade900,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue.shade900,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  indicatorColor: Colors.green,
  // scaffoldBackgroundColor: Colors.black,
  // backgroundColor: Colors.black,
  canvasColor: Colors.black,
);
