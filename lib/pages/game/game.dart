// game.dart
import "../../imports.dart";

// TODO: implement chessBoard to try out ones move
class Game extends StatefulWidget {
  final GameClass currentGame;
  bool isUserWhite;
  bool isUsersTurn;
  Game({
    @required this.currentGame,
    @required this.isUserWhite,
    @required this.isUsersTurn,
  });

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  GameBloc gameBloc;
  GameClass currentGame;

  @override
  void initState() {
    super.initState();
    this.currentGame = GameClass.from(widget.currentGame);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.gameBloc = GameBlocProvider.of(context).gameBloc;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double boardSize =
        size.width < size.height ? size.width * 0.9 : size.height * 0.9;

    var appBar = AppBar(
      title: Text(currentGame.subtitle ?? ""),
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Container(
            height: size.height - appBar.preferredSize.height - 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
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
                      isUserWhite: widget.isUserWhite,
                      isUsersTurn: widget.isUsersTurn,
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
                              pgn: widget.currentGame.pgn,
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
