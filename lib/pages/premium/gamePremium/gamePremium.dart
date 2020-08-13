// gamePremium.dart
import "../../../imports.dart";

// TODO: implement chessBoard to try out ones move
class GamePremium extends StatefulWidget {
  final GameClass currentGame;
  final String opponentsName;
  bool isUserWhite;
  GamePremium({
    @required this.currentGame,
    @required this.opponentsName,
    @required this.isUserWhite,
  });

  @override
  GamePremiumState createState() => GamePremiumState();
}

class GamePremiumState extends State<GamePremium>
    with AfterLayoutMixin<GamePremium> {
  // bloc that controls the loading, updating and saving of the games
  GamesBloc gamesBloc;
  // the current game (given from Home())
  GameClass currentGame;
  // ChessBoardController for the ChessBoardWidget
  ChessBoardController chessBoardController = ChessBoardController();
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
    this.isUsersTurn = usersTurn();
    this.chessBoardController.loadPGN(widget.currentGame.pgn);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.gamesBloc = GamesBlocProvider.of(context).gamesBloc;
  }

  @override
  afterFirstLayout(BuildContext context) {
    // if the current GameStatus has changed, the right dialog is shown
    if (currentGame.gameStatus != GameStatus.playing) {
      // TODO: find out why I have to instantiate this extension ??
      // GameStatusDialogs(this).
      // no idea why this has to be so complicated
      gameStatusChanged(
        currentContext: context,
        gameStatus: currentGame.gameStatus,
        durationInMilliseconds: 750,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    ThemeData theme = Theme.of(context);
    Size size = mediaQueryData.size;

    var appBar = AppBar(
      title: Text(
        // cuts away "Partie gegen: "
        widget.opponentsName.replaceRange(0, 13, ""),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            GameClass updatedGame = await this
                .gamesBloc
                .cloudFirestoreDatabase
                .getGameFromFirestore(gameID: currentGame.id);
            this.gamesBloc.updateGameSink.add(updatedGame);
            setState(() {
              this.currentGame = GameClass.from(updatedGame);
              this.isUsersTurn = usersTurn();
            });
            chessBoardController.loadPGN(currentGame.pgn);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
        buildOptionsButton(),
      ],
    );

    double boardSize = size.width < size.height
        ? size.width * 0.9
        : size.height * 0.8 - appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
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
                  ChessBoardWidgetPremium(
                    currentGame: this.currentGame,
                    chessBoardController: this.chessBoardController,
                    isUserWhite: widget.isUserWhite,
                    isUsersTurn: this.isUsersTurn,
                    boardSize: boardSize,
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
    );
  }
}
