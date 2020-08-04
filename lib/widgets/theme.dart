// theme.dart
import "../imports.dart";

/// theme for normal use
var theme = ThemeData(
  primaryColor: Colors.blue,
  accentColor: Colors.black,
  textTheme: TextTheme(
    // used for the title properties in ListTiles
    headline5: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    // used for the title properties of the ListTiles in Home and HomePremium
    headline6: TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    // used for medium sized subtitles
    subtitle1: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    // used for plain text
    bodyText1: TextStyle(),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.blue,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  iconTheme: IconThemeData(
    color: Colors.black,
    size: 24.0,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade800,
    // indent: 0.0,
    // endIndent: 0.0,
    // thickness: 1,
    space: 1,
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
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
  ),
  appBarTheme: AppBarTheme(
    // color: Colors.red,
    color: Colors.blue.shade900,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue.shade900,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
    size: 24.0,
  ),
  indicatorColor: Colors.green,
  // scaffoldBackgroundColor: Colors.black,
  // backgroundColor: Colors.black,
  canvasColor: Colors.black,
);
