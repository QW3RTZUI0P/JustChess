// chessBoardWidget.dart

import "../../imports.dart";

// TODO: add text widget which says who's turn it is
class ChessBoardWidget extends StatefulWidget {
  GameClass currentGame;
  bool isUserWhite;

  ChessBoardWidget({
    @required this.currentGame,
    @required this.isUserWhite,
  });

  @override
  _ChessBoardWidgetState createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget>
    with AfterLayoutMixin<ChessBoardWidget> {
  GameBloc _gameBloc;
  GameClass _currentGame;
  ChessBoardController _chessBoardController = ChessBoardController();
  bool _isUsersTurn;

  @override
  void initState() {
    super.initState();
    this._currentGame = widget.currentGame;
    this._isUsersTurn = usersTurn();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gameBloc = GameBlocProvider.of(context).gameBloc;
  }

  @override
  // Funktion aus dem Package after_layout
  void afterFirstLayout(BuildContext context) {
    _chessBoardController.loadPGN(_currentGame.pgn ?? "");
  }

  bool usersTurn() {
    if ((_currentGame.whitesTurn && widget.isUserWhite) ||
        (!_currentGame.whitesTurn && !widget.isUserWhite)) {
      return true;
    } else {
      return false;
    }
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
                        this
                            ._chessBoardController
                            .loadPGN(_currentGame.pgn ?? "");
                        print("partieINKlasse: " + this._currentGame.pgn);
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
                        setState(() {
                          this._isUsersTurn = false;
                          this._currentGame.pgn =
                              this._chessBoardController.game.pgn();
                        });
                        _currentGame.pgn = _chessBoardController.game.pgn();
                        // TODO: maybe invent a better and more secure way
                        _currentGame.whitesTurn =
                            widget.isUserWhite ? false : true;
                        print(_currentGame.pgn);
                        saveGame(game: _currentGame);
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) =>
                            _chessBoardController
                                .loadPGN(_currentGame.pgn ?? ""));
                        this
                            ._chessBoardController
                            .loadPGN(this._currentGame.pgn);
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
      enableUserMoves: this._isUsersTurn,
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
      chessBoardController: this._chessBoardController,
    );
  }
}
