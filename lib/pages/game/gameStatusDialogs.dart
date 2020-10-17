// gameStatusDialogs.dart
import "../../imports.dart";

// extension with the gameStatusChanged() method
extension GameStatusDialogs on OnlineGameState {
  // executes one or two seconds after build()
  // shows the right dialog

  void gameStatusChanged(
      {@required BuildContext currentContext,
      @required GameStatus gameStatus,
      @required int durationInMilliseconds}) async {
    await Future.delayed(Duration(milliseconds: durationInMilliseconds));

    ThemeData theme = Theme.of(currentContext);

    // dialog that is shown after the switch statement
    Dialog gameStatusDialog = Dialog();

    switch (gameStatus) {
      case GameStatus.stalemate:
        gameStatusDialog = Dialog(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Patt",
                  style: theme.dialogTheme.titleTextStyle,
                ),
                SizedBox(height: 5.0),
                Text("Das Spiel ist unentschieden ausgegangen."),
                Row(
                  children: [
                    FlatButton(
                      child: Text("Partie löschen"),
                      onPressed: () {
                        gamesBloc.deleteGameSink.add(currentGame);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        SnackbarMessage(
                            context: currentContext,
                            message: "Du hast die Partie gelöscht");
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );

        // shows the dialog declared in the previous switch statement
        showDialog(
            context: currentContext,
            builder: (BuildContext context) {
              return gameStatusDialog;
            });

        break;
      case GameStatus.whiteWon:
        gameStatusDialog = Dialog(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Weiß hat gewonnen",
                  style: theme.dialogTheme.titleTextStyle,
                ),
                Row(
                  children: [
                    FlatButton(
                      child: Text("Partie löschen"),
                      onPressed: () {
                        gamesBloc.deleteGameSink.add(currentGame);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // SnackbarMessage(
                        //     context: currentContext,
                        //     message: "Du hast die Partie gelöscht");
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );

        // shows the dialog declared in the previous switch statement
        showDialog(
            context: currentContext,
            builder: (BuildContext context) {
              return gameStatusDialog;
            });

        break;
      case GameStatus.blackWon:
        gameStatusDialog = Dialog(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Schwarz hat gewonnen",
                  style: theme.dialogTheme.titleTextStyle,
                ),
                Row(
                  children: [
                    FlatButton(
                      child: Text("Partie löschen"),
                      onPressed: () async {
                        gamesBloc.deleteGameSink.add(currentGame);
                        Navigator.pop(context);
                        Navigator.pop(context);

                        // SnackbarMessage(
                        //     context: currentContext,
                        //     message: "Du hast die Partie gelöscht");
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );

        // shows the dialog declared in the previous switch statement
        showDialog(
            context: currentContext,
            builder: (BuildContext context) {
              return gameStatusDialog;
            });

        break;
      case GameStatus.draw:
        gameStatusDialog = Dialog(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Remis",
                  style: theme.dialogTheme.titleTextStyle,
                ),
                SizedBox(height: 5.0),
                Text("Ihr habt euch auf Remis geeinigt"),
                Row(
                  children: [
                    FlatButton(
                      child: Text("Partie löschen"),
                      onPressed: () {
                        gamesBloc.deleteGameSink.add(currentGame);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // SnackbarMessage(
                        //     context: currentContext,
                        //     message: "Du hast die Partie gelöscht");
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );

        // shows the dialog declared in the previous switch statement
        showDialog(
            context: currentContext,
            builder: (BuildContext context) {
              return gameStatusDialog;
            });

        break;
      case GameStatus.whiteProposedDraw:
        gameStatusDialog = Dialog(
          child: Container(
            padding: EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Remis vorgeschlagen",
                  style: theme.dialogTheme.titleTextStyle,
                ),
                SizedBox(height: 5.0),
                Text("Dein Gegner hat ein Remis vorgeschlagen"),
                Row(
                  children: [
                    FlatButton(
                      child: Text(
                        "Remis annehmen",
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        GameClass updatedGame = GameClass.from(currentGame);
                        // updates the gameStatus to draw
                        updatedGame.gameStatus = GameStatus.draw;
                        gamesBloc.updateGameSink.add(updatedGame);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        SnackbarMessage(
                            context: currentContext,
                            message: "Du hast das Remis angenommen");
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Remis ablehnen",
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        GameClass updatedGame = GameClass.from(currentGame);
                        // updates the gameStatus to draw
                        updatedGame.gameStatus = GameStatus.playing;
                        gamesBloc.updateGameSink.add(updatedGame);
                        Navigator.of(context).pop();
                        SnackbarMessage(
                            context: currentContext,
                            message: "Du hast das Remis abgelehnt");
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );

        if (!widget.isUserWhite) {
          // shows the dialog declared in the previous switch statement
          showDialog(
              context: currentContext,
              builder: (BuildContext context) {
                return gameStatusDialog;
              });
        }

        break;
      case GameStatus.blackProposedDraw:
        gameStatusDialog = Dialog(
          child: Container(
            padding: EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Remis vorgeschlagen",
                  style: theme.dialogTheme.titleTextStyle,
                ),
                SizedBox(height: 5.0),
                Text("Dein Gegner hat ein Remis vorgeschlagen"),
                Row(
                  children: [
                    FlatButton(
                      child: Text(
                        "Remis annehmen",
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        GameClass updatedGame = GameClass.from(currentGame);
                        // updates the gameStatus to draw
                        updatedGame.gameStatus = GameStatus.draw;
                        gamesBloc.updateGameSink.add(updatedGame);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        SnackbarMessage(
                            context: currentContext,
                            message: "Du hast das Remis angenommen");
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Remis ablehnen",
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        GameClass updatedGame = GameClass.from(currentGame);
                        // updates the gameStatus to draw
                        updatedGame.gameStatus = GameStatus.playing;
                        gamesBloc.updateGameSink.add(updatedGame);
                        Navigator.of(context).pop();
                        SnackbarMessage(
                            context: currentContext,
                            message: "Du hast das Remis abgelehnt");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        if (widget.isUserWhite) {
          // shows the dialog declared in the previous switch statement
          showDialog(
              context: currentContext,
              builder: (BuildContext context) {
                return gameStatusDialog;
              });
        }
        break;
      case GameStatus.whiteGaveUp:
        gameStatusDialog = Dialog(
          child: Container(
            padding: EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Weiß hat aufgegeben",
                  style: theme.dialogTheme.titleTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text("Partie löschen"),
                      onPressed: () {
                        gamesBloc.deleteGameSink.add(currentGame);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // SnackbarMessage(
                        //     context: currentContext,
                        //     message: "Du hast die Partie gelöscht");
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );

        showDialog(
            context: currentContext,
            builder: (BuildContext context) {
              return gameStatusDialog;
            });

        break;
      case GameStatus.blackGaveUp:
        gameStatusDialog = Dialog(
          child: Container(
            padding: EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Schwarz hat aufgegeben",
                  style: theme.dialogTheme.titleTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text("Partie löschen"),
                      onPressed: () {
                        gamesBloc.deleteGameSink.add(currentGame);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // SnackbarMessage(
                        //     context: currentContext,
                        //     message: "Du hast die Partie gelöscht");
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );

        showDialog(
            context: currentContext,
            builder: (BuildContext context) {
              return gameStatusDialog;
            });

        break;
      default:
        break;
    }
  }
}
