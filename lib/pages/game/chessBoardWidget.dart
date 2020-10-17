// chessBoardWidget.dart

import "../../imports.dart";
import "package:chess/chess.dart" as chess;

// TODO: add text widget which says who's turn it is
class ChessBoardWidget extends StatefulWidget {
  final GameClass currentGame;
  final ChessBoardController chessBoardController;
  final bool isUserWhite;
  final bool isUsersTurn;
  final double boardSize;
  final dynamic lastMove;
  ChessBoardWidget({
    @required this.currentGame,
    @required this.chessBoardController,
    @required this.isUserWhite,
    @required this.isUsersTurn,
    @required this.boardSize,
    @required this.lastMove,
  });

  @override
  _ChessBoardWidgetState createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget>
    with AfterLayoutMixin {
  GamesBloc _gamesBloc;
  GameClass _currentGame;
  bool isUsersTurn;

  @override
  void initState() {
    super.initState();
    this._currentGame = widget.currentGame;
    this.isUsersTurn = widget.isUsersTurn;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gamesBloc = GamesBlocProvider.of(context).gamesBloc;
    _currentGame = widget.currentGame;
    // widget.chessBoardController.loadPGN(_currentGame.pgn);
  }

  @override
  void didUpdateWidget(ChessBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.isUsersTurn = widget.isUsersTurn;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    makeLastMove(lastMove: widget.lastMove);
  }

  void confirmMove() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.red,
                    height: 100.0,
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      tooltip: "Abbrechen",
                      onPressed: () {
                        setState(() {
                          widget.chessBoardController
                              .loadPGN(widget.currentGame.pgn ?? "");
                          this.isUsersTurn = true;
                        });

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Container(
                  width: 2.0,
                  height: 100.0,
                  color: Colors.black,
                ),
                Expanded(
                  child: Container(
                    color: Colors.lightGreen,
                    height: 100.0,
                    child: IconButton(
                      icon: Icon(Icons.done),
                      tooltip: "Bestätigen",
                      onPressed: () {
                        GameClass updatedGame = GameClass.from(_currentGame);
                        updatedGame.pgn =
                            widget.chessBoardController.game.pgn();
                        updatedGame.moveCount =
                            widget.chessBoardController.game.move_number;
                        updatedGame.whitesTurn =
                            widget.isUserWhite ? false : true;
                        setState(() {
                          this.isUsersTurn = false;
                          this._currentGame.pgn =
                              widget.chessBoardController.game.pgn();
                          this._currentGame.moveCount =
                              widget.chessBoardController.game.move_number;
                          this.isUsersTurn = false;

                          // TODO: maybe invent a better and more secure way
                          _currentGame.whitesTurn =
                              widget.isUserWhite ? false : true;
                        });
                        saveGame(game: updatedGame);

                        Navigator.pop(context);

                        widget.chessBoardController
                            .loadPGN(this._currentGame.pgn ?? "");
                        if (widget.chessBoardController.game.in_checkmate) {
                          PieceColor loserColor = onCheckmate();
                          updatedGame.gameStatus =
                              loserColor == PieceColor.Black
                                  ? GameStatus.whiteWon
                                  : GameStatus.blackWon;
                          saveGame(game: updatedGame);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void saveGame({GameClass game}) {
    _gamesBloc.updateGameSink.add(game);
  }

  void makeLastMove({dynamic lastMove}) async {
    await Future.delayed(
      Duration(milliseconds: 500),
    );
    setState(() {
      widget.chessBoardController.game.move(widget.lastMove);
    });
  }

  PieceColor onCheckmate() {
    PieceColor loserColor =
        widget.chessBoardController.game.turn == chess.Color.WHITE
            ? PieceColor.White
            : PieceColor.Black;
    ThemeData theme = Theme.of(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: theme.dialogTheme.backgroundColor,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Schachmatt",
                    style: theme.dialogTheme.titleTextStyle,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    loserColor == PieceColor.White
                        ? "Schwarz hat gewonnen"
                        : "Weiß hat gewonnen",
                    style: theme.dialogTheme.contentTextStyle,
                  ),
                  Row(
                    children: [
                      FlatButton(
                        child: Text("Partie löschen"),
                        onPressed: () {
                          GameClass updatedGame = GameClass.from(_currentGame);
                          updatedGame.gameStatus =
                              loserColor == PieceColor.Black
                                  ? GameStatus.whiteWon
                                  : GameStatus.blackWon;
                          _gamesBloc.deleteGameSink.add(updatedGame);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // TODO: build a method that doesn't fetch all the games again from firestore (instead just add / delete the games locally)
                          _gamesBloc.refreshAll();
                        },
                      ),
                      FlatButton(
                        child: Text("OK"),
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
    return loserColor;
  }

  @override
  Widget build(BuildContext context) {
    print("building");

    return ChessBoard(
      size: widget.boardSize,
      whiteSideTowardsUser: widget.isUserWhite,
      enableUserMoves: this.isUsersTurn,
      onMove: (move) {
        confirmMove();
        // partie.anzahlDerZuege += 0.5;
        print(move);
      },
      onCheckMate: (_) {},
      // (color) {
      //   print("checkMate");
      //   GameClass updatedGame = GameClass.from(_currentGame);
      //   updatedGame.gameStatus = color == PieceColor.White
      //       ? GameStatus.whiteWon
      //       : GameStatus.blackWon;
      //   saveGame(game: updatedGame);
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       content: Text("$color hat gewonnen!"),
      //       actions: <Widget>[
      //         FlatButton(
      //           child: Text("Ok"),
      //           onPressed: () => Navigator.pop(context),
      //         )
      //       ],
      //     ),
      //   );
      // },
      onDraw: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("Unentschieden / Remis / Patt"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
        GameClass updatedGame = GameClass.from(_currentGame);
        updatedGame.gameStatus = GameStatus.stalemate;
        saveGame(game: updatedGame);
      },
      onCheck: (_) {},
      chessBoardController: widget.chessBoardController,
    );
  }
}
