// onlineGame.dart
import "../../imports.dart";
import "package:chess/chess.dart" as chess;

// TODO: implement chessBoard to try out ones move
class OnlineGame extends StatefulWidget {
  final GameClass currentGame;
  final String opponentsName;
  final bool isUserWhite;
  OnlineGame({
    @required this.currentGame,
    @required this.opponentsName,
    @required this.isUserWhite,
  });

  @override
  OnlineGameState createState() => OnlineGameState();
}

class OnlineGameState extends State<OnlineGame> {
  // bloc that controls the loading, updating and saving of the games
  GamesBloc gamesBloc;
  // the current game (given from Home())
  GameClass currentGame;
  // ChessBoardController for the ChessBoardWidget
  ChessBoardController chessBoardController = ChessBoardController();
  // the move the chessBoardController undoes in initState()
  // will be done in ChessBoardWidgetPremium to show the user his opponents last turn
  dynamic lastMove;
  // tells whether the user is allowed to make turns
  bool isUsersTurn;
  // value for the DropdownButton in the AppBar
  int _dropdownButtonValue;
  // the items for the DropdownButton
  List<String> dropdownButtonItems = ["Aufgeben", "Remis", "PGN exportieren"];

  @override
  void initState() {
    super.initState();
    this.currentGame = GameClass.from(widget.currentGame);
    currentGame.isOnline = true;
    this.isUsersTurn = usersTurn();
    this.chessBoardController.loadPGN(widget.currentGame.pgn);
    lastMove = chessBoardController.game.undo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.gamesBloc = GamesBlocProvider.of(context).gamesBloc;
  }

  bool usersTurn() {
    if (currentGame.whitesTurn && widget.isUserWhite) {
      return true;
    } else if (!currentGame.whitesTurn && !widget.isUserWhite) {
      return true;
    } else {
      return false;
    }
  }

  void saveGame({GameClass game}) {
    gamesBloc.updateGameSink.add(game);
  }

  Future<void> makeLastMove({dynamic lastMove}) async {
    await Future.delayed(
      Duration(milliseconds: 500),
    );
    setState(() {
      chessBoardController.game.move(lastMove);
    });
  }

  // makes the last move with a promotion
  Future<void> makeLastMoveWithPromotion({dynamic lastMove}) async {
    await Future.delayed(
      Duration(milliseconds: 500),
    );
    setState(() {
      chessBoardController.game.move({
        "from": lastMove["from"],
        "to": lastMove["to"],
        "promotion": lastMove["san"].split("").last.toLowerCase()
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    ThemeData theme = Theme.of(context);
    Size size = mediaQueryData.size;

    print("building game");

    var appBar = AppBar(
      title: Text(
        // cuts away "Partie gegen: "
        widget.opponentsName.replaceRange(0, 13, ""),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          tooltip: "Neu laden",
          onPressed: () async {
            GameClass updatedGame = await this
                .gamesBloc
                .cloudFirestoreDatabase
                .getGameFromFirestore(gameID: currentGame.id);
            this.gamesBloc.updateGameSink.add(updatedGame);
            setState(() {
              this.currentGame = GameClass.from(updatedGame);
              this.isUsersTurn = usersTurn();
              chessBoardController.loadPGN(updatedGame.pgn);
              lastMove = chessBoardController.game.undo();
              print("lastMove: " + lastMove.toString());
            });

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              // makes a promotion if the last move has been a promotion
              if (lastMove["flags"].contains("p")) {
                makeLastMoveWithPromotion(lastMove: lastMove);
              } else {
                makeLastMove(lastMove: lastMove);
                String hello = "hello";
              }
              if (currentGame.gameStatus != GameStatus.playing) {
                gameStatusChanged(
                  currentContext: context,
                  gameStatus: currentGame.gameStatus,
                  durationInMilliseconds: 750,
                );
              }
            });
          },
        ),
        buildOptionsButton(
          currentGame: this.currentGame,
        ),
      ],
    );

    double boardSize = size.width < size.height
        ? size.width * 0.9
        : size.height * 0.8 - appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: Builder(builder: (BuildContext currentContext) {
        // if the current GameStatus has changed, the right dialog is shown
        if (currentGame.gameStatus != GameStatus.playing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // TODO: find out why I have to instantiate this extension ??
            // GameStatusDialogs(this).
            // no idea why this has to be so complicated
            gameStatusChanged(
              currentContext: currentContext,
              gameStatus: currentGame.gameStatus,
              durationInMilliseconds: 400,
            );
          });
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(currentGame.canBeDeleted
                    ? "Dein Gegner hat diese Partie gelöscht"
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
                      boardSize: boardSize,
                      lastMove: lastMove,
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
                              appBarHeight: appBar.preferredSize.height,
                            );
                          }),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // helper function for the extension GamePremiumOptionsButton
  void doSetState(Function setStateFunction) {
    setState(setStateFunction);
  }
}
