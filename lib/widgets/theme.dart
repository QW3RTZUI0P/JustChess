// theme.dart
import "../imports.dart";

// theme for normal use
var theme = ThemeData(
  textTheme: TextTheme(
    headline6: TextStyle(color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(),
  appBarTheme: AppBarTheme(
    color: Colors.blue,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 21,
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
);
// theme for dark mode (ios) or dark theme (android)
var darkTheme = ThemeData(
  textTheme: TextTheme(
    // bodyText1: TextStyle(
    //   color: Colors.white,
    // ),
    // bodyText2: TextStyle(
    //   color: Colors.white,
    // ),

    headline6: TextStyle(
      color: Colors.white,
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
  // backgroundColor: Colors.black12,
  // canvasColor: Colors.black12,
  // scaffoldBackgroundColor: Colors.black12,

);
