// game.dart
import "../../imports.dart";
import "package:chess/chess.dart" as chess;

// TODO: implement chessBoard to try out ones move
class Game extends StatefulWidget {
  final GameClass currentGame;
  final String opponentsName;
  bool isUserWhite;
  Game({
    @required this.currentGame,
    @required this.opponentsName,
    @required this.isUserWhite,
  });

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  // bloc that controls the loading, updating and saving of the games
  GameBloc _gameBloc;
  // the current game (given from Home())
  GameClass currentGame;
  // ChessBoardController for the ChessBoardWidget
  ChessBoardController chessBoardController = ChessBoardController();
  // tells whether the user is allowed to make turns
  bool isUsersTurn;

  @override
  void initState() {
    super.initState();
    this.currentGame = GameClass.from(widget.currentGame);
    this.isUsersTurn = usersTurn();
    this.chessBoardController.loadPGN(widget.currentGame.pgn);

    print("isWhite " + widget.isUserWhite.toString());
    print("isTurn " + this.isUsersTurn.toString());
    print("whitesTurn " + currentGame.whitesTurn.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._gameBloc = GameBlocProvider.of(context).gameBloc;
  }

  bool usersTurn() {
    if (currentGame.whitesTurn && widget.isUserWhite) {
      print("1");
      return true;
    } else if (!currentGame.whitesTurn && !widget.isUserWhite) {
      print("2");
      return true;
    } else {
      print("3");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double boardSize =
        size.width < size.height ? size.width * 0.9 : size.height * 0.9;

    var appBar = AppBar(
      title: Text(widget.opponentsName ?? ""),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            GameClass updatedGame = await this
                ._gameBloc
                .cloudFirestoreDatabase
                .getGameFromFirestore(gameID: currentGame.id);
            this._gameBloc.updateGameSink.add(updatedGame);
            setState(() {
              this.currentGame = GameClass.from(updatedGame);
              this.isUsersTurn = usersTurn();
            });
            chessBoardController.loadPGN(currentGame.pgn);
          },
        )
      ],
    );
    print("building game");
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            height: size.height - appBar.preferredSize.height - 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(currentGame.canBeDeleted
                    ? "Dein Gegner hat dieses Spiel gelöscht"
                    : ""),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.isUserWhite
                        ? VerticalNumbersWhite(
                            height: boardSize,
                          )
                        : VerticalNumbersBlack(
                            height: boardSize,
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                    ChessBoardWidget(
                      currentGame: this.currentGame,
                      chessBoardController: this.chessBoardController,
                      isUserWhite: widget.isUserWhite,
                      isUsersTurn: this.isUsersTurn,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                widget.isUserWhite
                    ? Center(
                        child: HorizontalLettersWhite(
                          width: boardSize,
                        ),
                      )
                    : Center(
                        child: HorizontalLettersBlack(
                          width: boardSize,
                        ),
                      ),
                RaisedButton(
                  child: Text("Zug ausprobieren"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) {
                            return TryOutChessBoardWidget(
                              pgn: this.currentGame.pgn,
                              isUserWhite: widget.isUserWhite,
                            );
                          }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
