// gamePremiumOptionsButton.dart
import "../../../imports.dart";
import 'package:flutter/services.dart';

extension GamePremiumOptionsButton on GamePremiumState {
// button that provides more options for the user (e.g. edit name of game, export pgn, give up, propose remis, ...)
  Widget buildOptionsButton() => Builder(
        builder: (BuildContext currentContext) {
          return PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: theme.appBarTheme.actionsIconTheme.color,
            ),
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
                                        setState(() {
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
                                        setState(() {
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
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Aufgeben"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Remis vorschlagen"),
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
