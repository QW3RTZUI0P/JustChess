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
      headline6: TextStyle(color: Colors.white),
    ),
  ),
);
// theme for dark mode (ios) or dark theme (android)
var darkTheme = ThemeData(
  textTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white,
    ),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.blue.shade900,
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.white),
    ),
  ),
);
