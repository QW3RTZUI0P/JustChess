// game.dart
import "../../imports.dart";

// TODO: clean this file up and split it in separate widgets
// TODO: think of a solution to solve the problem with variables just being references
// TODO: implement chessBoard to try out ones move
class Game extends StatefulWidget {
  final GameClass currentGame;
  final GameBloc oldGameBloc;
  Game({
    this.currentGame,
    this.oldGameBloc,
  });

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  GameBloc gameBloc;
  GameClass currentGame;
  bool isUserWhite;

  @override
  void initState() {
    super.initState();
    this.currentGame = GameClass.from(widget.currentGame);
    // TODO: think of a better solution so this variable can use the gameBloc in this State
    this.isUserWhite = (currentGame.player01IsWhite &&
                widget.oldGameBloc.currentUserID == currentGame.player01) ||
            (!currentGame.player01IsWhite &&
                widget.oldGameBloc.currentUserID == currentGame.player02)
        ? true
        : false;
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
      title: Text(currentGame.name ?? ""),
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
                    this.isUserWhite
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
                      isUserWhite: this.isUserWhite,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                this.isUserWhite
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
