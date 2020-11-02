# JustChess
## General
JustChess is an app for playing chess games online, easy and direct. It focuses on games that last a longer period of time.
At the moment JustChess is only available in German.
 

## Structure
### Structure of the app
The main page of JustChess is the page with all the users games. From there, the user can switch to another page, create a new game or
see his invitations.
The other pages are the page with all the user's friends, the settings page and an about page with information about the app and me.

### Structure ob lib
The lib folder of JustChess contains all the apps code. It contains the following components:
- main.dart
- imports.dart
- pages (contains all the pages of the app)
- classes
- blocs (the code handling the state management)
- services (like FirebaseAuth or CloudFirestore)
- widgets (widgets needed all over the app)
- flutter_chess_board (a fork of Deven Joshi's flutter_chess_board package from https://github.com/deven98/flutter_chess_board)

### Structure of the code
Most of the code is structured like this:
Flutter widgets:
* fields (important before unimportant)
    * values to be initialized
    * public
    * private
* constructors
* methods and functions
* build() method

other classes:
* fields (important before unimportant)
    * values to be initialized
    * public
    * private
* constructors
* methods and functions
