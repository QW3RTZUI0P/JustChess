// gamePremiumOptionsButton.dart
import "../../../imports.dart";
// for Clipboard
import 'package:flutter/services.dart';

extension GamePremiumOptionsButton on GamePremiumState {
// button that provides more options for the user (e.g. edit name of game, export pgn, give up, propose remis, ...)
  Widget buildOptionsButton({
    @required GameClass currentGame,
  }) =>
      Builder(
        builder: (BuildContext currentContext) {
          return PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: theme.appBarTheme.actionsIconTheme.color,
            ),
            tooltip: "Optionen",
            onSelected: (int selectedValue) {
              switch (selectedValue) {
                case 0:
                  showDialog(
                      context: currentContext,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: theme.dialogTheme.backgroundColor,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Aufgeben bestätigen",
                                  style: theme.dialogTheme.titleTextStyle,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Willst du wirlich aufgeben?",
                                  style: theme.dialogTheme.contentTextStyle,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FlatButton(
                                      child: Text(
                                        "Aufgeben",
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        doSetState(() {
                                          widget.isUserWhite
                                              ? currentGame.gameStatus =
                                                  GameStatus.whiteGaveUp
                                              : currentGame.gameStatus =
                                                  GameStatus.blackGaveUp;
                                        });

                                        saveGame(game: currentGame);
                                        print("aufgegeben");
                                        SnackbarMessage(
                                          context: currentContext,
                                          message: "Du hast aufgegeben",
                                        );
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Abbrechen"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                  break;
                case 1:
                  showDialog(
                      context: currentContext,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: theme.dialogTheme.backgroundColor,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Remis Vorschlag bestätigen",
                                  style: theme.dialogTheme.titleTextStyle,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Willst du wirlich Remis vorschlagen?",
                                  style: theme.dialogTheme.contentTextStyle,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FlatButton(
                                      child: Text(
                                        "Bestätigen",
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        doSetState(() {
                                          widget.isUserWhite
                                              ? currentGame.gameStatus =
                                                  GameStatus.whiteProposedDraw
                                              : currentGame.gameStatus =
                                                  GameStatus.blackProposedDraw;
                                        });

                                        saveGame(game: currentGame);
                                        print("Remis vorgeschlagen");
                                        SnackbarMessage(
                                          context: currentContext,
                                          message:
                                              "Du hast Remis vorgeschlagen",
                                        );
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Abbrechen"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                  break;
                case 2:
                  // copies the current pgn into the clipboard
                  Clipboard.setData(
                    ClipboardData(text: currentGame.pgn),
                  );
                  // shows a SnackBar that informs the user that the PGN has been pasted to the clipboard
                  Scaffold.of(currentContext).showSnackBar(
                    SnackBar(
                      content: Text("PGN wurde in die Zwischenablage kopiert"),
                    ),
                  );
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              // if you want to change the order, you have to change the corresponding int values in the preceding switch statement
              PopupMenuItem<int>(
                value: 0,
                child: Text("Aufgeben"),
                enabled: canUserGiveUp(currentGame.gameStatus),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Remis vorschlagen"),
                enabled: canUserProposeDraw(currentGame.gameStatus),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("PGN exportieren"),
              ),
            ],
          );
        },
      );
}

// whether the user is allowed to give up
bool canUserGiveUp(GameStatus gameStatus) {
  switch (gameStatus) {
    case GameStatus.playing:
      return true;
    case GameStatus.stalemate:
      return false;
    case GameStatus.draw:
      return false;
    case GameStatus.whiteWon:
      return false;
    case GameStatus.blackWon:
      return false;
    case GameStatus.whiteGaveUp:
      return false;
    case GameStatus.blackGaveUp:
      return false;
    case GameStatus.whiteProposedDraw:
      return true;
    case GameStatus.blackProposedDraw:
      return true;
    default:
      return true;
  }
}

// whether the user is allowed to propose draw
bool canUserProposeDraw(GameStatus gameStatus) {
  if (gameStatus == GameStatus.playing) {
    return true;
  } else {
    return false;
  }
  // switch (gameStatus) {
  //   case GameStatus.playing:
  //     return true;
  //   case GameStatus.stalemate:
  //     return false;
  //   case GameStatus.draw:
  //     return false;
  //   case GameStatus.whiteWon:
  //     return false;
  //   case GameStatus.blackWon:
  //     return false;
  //   case GameStatus.whiteGaveUp:
  //     return false;
  //   case GameStatus.blackGaveUp:
  //     return false;
  //   case GameStatus.whiteProposedDraw:
  //     return false;
  //   case GameStatus.blackProposedDraw:
  //     return false;

  //   default:
  //     return true;
  // }
}
