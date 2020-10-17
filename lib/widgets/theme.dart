// theme.dart
import "../imports.dart";

/// theme for normal use
var theme = ThemeData(
  primaryColor: Colors.black,
  textTheme: TextTheme(
    // bold, very large headline (sized like the AppBar title)
    headline1: TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    // normal, very large headline (sized like the AppBar title)
    headline2: TextStyle(
      color: Colors.black,
      fontSize: 24.0,
    ),
    // bold, large headline
    headline3: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    // normal, large headline
    headline4: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
    ),
    // bold, medium sized headline
    // used for the title properties of the ListTiles in Home and HomePremium
    headline5: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    // normal, medium sized headline
    // used for the title properties in ListTiles
    headline6: TextStyle(
      color: Colors.black,
      fontSize: 16.0,
    ),
    //
    // used for medium sized subtitles
    subtitle1: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    ),
    // used for the subtitles in about.dart
    subtitle2: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 12.0,
    ),
    //
    // used for plain text
    bodyText1: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    // used for small text
    bodyText2: TextStyle(
      color: Colors.black,
      fontSize: 12.0,
    ),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.black,
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
    backgroundColor: Colors.black,
  ),
  iconTheme: IconThemeData(
    color: Colors.black,
    size: 24.0,
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade600,
    space: 1,
  ),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    ),
    // like textTheme.bodyText1
    contentTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    ),
    backgroundColor: Colors.white,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    ),
  ),
  indicatorColor: Colors.green.shade200,
);
//
//
//
/// theme for dark mode (ios) or dark theme (android)
var darkTheme = ThemeData(
  primaryColor: Colors.black,
  textTheme: TextTheme(
    // bold, very large headline (sized like the AppBar title)
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    // normal, very large headline (sized like the AppBar title)
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 24.0,
    ),
    // bold, large headline
    headline3: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    // normal, large headline
    headline4: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
    ),
    // bold, medium sized headline
    // used for the title properties of the ListTiles in Home and HomePremium
    headline5: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    // normal, medium sized headline
    // used for the title properties in ListTiles
    headline6: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
    ),
    //
    subtitle1: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
    ),
    //
    // used for plain text
    bodyText1: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
    ),
    // used for small text
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 12.0,
    ),
  ),
  appBarTheme: AppBarTheme(
    // color: Colors.red,
    color: Colors.blue.shade900,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
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
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade600,
    space: 1,
  ),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    ),
    contentTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
    ),
    backgroundColor: Colors.black,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.black,
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 14.0,
    ),
  ),
  indicatorColor: Colors.green,
  // scaffoldBackgroundColor: Colors.black,
  // backgroundColor: Colors.black,
  canvasColor: Colors.black,
);
