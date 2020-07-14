// chessBoardWidget.dart

import "../../imports.dart";

// TODO: add text widget which says who's turn it is
class ChessBoardWidget extends StatefulWidget {
  GameClass currentGame;
  ChessBoardController chessBoardController;
  bool isUserWhite;
  bool isUsersTurn;
  ChessBoardWidget({
    @required this.currentGame,
    @required this.chessBoardController,
    @required this.isUserWhite,
    @required this.isUsersTurn,
  }) {
    print("white " + isUserWhite.toString());
    print("turn " + isUsersTurn.toString());
  }

  @override
  _ChessBoardWidgetState createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  GameBloc _gameBloc;
  GameClass _currentGame;
  bool isUsersTurn;

  @override
  void initState() {
    super.initState();
    this._currentGame = widget.currentGame;
    this.isUsersTurn = widget.isUsersTurn;
    print(this.isUsersTurn);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gameBloc = GameBlocProvider.of(context).gameBloc;
    this._currentGame = widget.currentGame;
    widget.chessBoardController.loadPGN(_currentGame.pgn);
  }

  @override
  void didUpdateWidget(ChessBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.isUsersTurn = widget.isUsersTurn;
  }

  // bool usersTurn() {
  //   if ((_currentGame.whitesTurn && widget.isUserWhite) ||
  //       (!_currentGame.whitesTurn && !widget.isUserWhite)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

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
                        widget.isUsersTurn = false;
                        setState(() {
                          this._currentGame.pgn =
                              widget.chessBoardController.game.pgn();
                          this.isUsersTurn = false;

                          // TODO: maybe invent a better and more secure way
                          _currentGame.whitesTurn =
                              widget.isUserWhite ? false : true;
                        });

                        saveGame(game: _currentGame);
                        Navigator.pop(context);

                        widget.chessBoardController
                            .loadPGN(this._currentGame.pgn ?? "");
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
    _gameBloc.updateGameSink.add(game);
  }

  @override
  Widget build(BuildContext context) {
    print("building");
    Size size = MediaQuery.of(context).size;

    double boardSize =
        size.width < size.height ? size.width * 0.9 : size.height * 0.9;

    return ChessBoard(
      size: boardSize,
      whiteSideTowardsUser: widget.isUserWhite,
      enableUserMoves: this.isUsersTurn,
      onMove: (move) {
        confirmMove();
        // partie.anzahlDerZuege += 0.5;
        print(move);
      },
      onCheckMate: (color) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("$color hat gewonnen!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      },
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
      },
      onCheck: (_) {},
      chessBoardController: widget.chessBoardController,
    );
  }
}
