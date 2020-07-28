// game.dart
import "../../imports.dart";
import 'package:chess/chess.dart' as chess;

// TODO: optimize performance here (maybe dont rebuild every time the user makes a move)
// TODO: include labeling into the chessboard widget
class Game extends StatefulWidget {
  GameClass game;
  bool isUserPremium;
  Game({
    @required this.game,
    @required this.isUserPremium,
  });

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  // bloc that controls the loading and saving of the local games
  LocalGamesBloc _localGamesBloc;
  // bloc that controls the loading and saving of all the games
  GamesBloc _gamesBloc;
  // the current game loaded onto the ChessBoard
  GameClass currentGame;
  // controller for the ChessBoard widget
  ChessBoardController _chessBoardController = ChessBoardController();
  // list with the moves the user has undone
  List<chess.Move> movesList = [];

  @override
  void initState() {
    super.initState();
    print("pgn " + widget.game.pgn);
    this.currentGame = GameClass.from(widget.game);
    _chessBoardController.loadPGN(this.currentGame.pgn);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isUserPremium) {
      this._gamesBloc = GamesBlocProvider.of(context).gamesBloc;
    } else {
      this._localGamesBloc = LocalGamesBlocProvider.of(context).localGamesBloc;
    }
  }

  // saves the game to the local file system
  void saveGame() {}

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // stuff for sizing the widgets correctly
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double chessBoardDimension =
        size.height < size.width ? size.height * 0.85 : size.width * 0.85;
    var appBar = AppBar(
      title: Text(
        this.currentGame.title,
      ),
      actions: <Widget>[
        // TODO: add options to this button
        // button that provides more options for the user (e.g. edit name of game, export pgn, ...)
        DropdownButton(
          icon: Icon(Icons.more_vert),
          items: [],
          onChanged: (_) {},
        ),
      ],
      textTheme: theme.appBarTheme.textTheme,
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            height: size.height -
                appBar.preferredSize.height -
                mediaQueryData.padding.top -
                mediaQueryData.padding.bottom,
            width: size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                currentGame.player01IsWhite
                    ? HorizontalLettersWhite(
                        width: chessBoardDimension,
                      )
                    : HorizontalLettersBlack(
                        width: chessBoardDimension,
                      ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    currentGame.player01IsWhite
                        ? VerticalNumbersWhite(height: chessBoardDimension)
                        : VerticalNumbersBlack(height: chessBoardDimension),
                    const SizedBox(width: 5),
                    ChessBoard(
                      size: chessBoardDimension,
                      labelingType: LabelingType.twoSides,
                      whiteSideTowardsUser: this.currentGame.player01IsWhite,
                      chessBoardController: _chessBoardController,
                      onCheck: (_) {},
                      onCheckMate: (_) {},
                      onDraw: () {},
                      onMove: (_) {
                        setState(() {
                          currentGame.pgn = _chessBoardController.game.pgn();
                          currentGame.moveCount =
                              _chessBoardController.game.move_number;
                          if (widget.isUserPremium) {
                            this._gamesBloc.updateGameSink.add(this.currentGame);
                          } else {
                            _localGamesBloc.localGameUpdated(
                                updatedGame: currentGame);
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    currentGame.player01IsWhite
                        ? VerticalNumbersWhite(height: chessBoardDimension)
                        : VerticalNumbersBlack(height: chessBoardDimension),
                  ],
                ),
                const SizedBox(height: 5),
                currentGame.player01IsWhite
                    ? HorizontalLettersWhite(
                        width: chessBoardDimension,
                      )
                    : HorizontalLettersBlack(
                        width: chessBoardDimension,
                      ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: RaisedButton(
                        child: Text("Zurücksetzen",
                            overflow: TextOverflow.ellipsis),
                        onPressed: () {
                          setState(() {
                            this.movesList.clear();
                            // loads the last saved state (pgn) of the game
                            this._chessBoardController.loadPGN(widget.game.pgn);
                            currentGame.pgn = _chessBoardController.game.pgn();
                            currentGame.moveCount =
                                _chessBoardController.game.move_number;
                            if (widget.isUserPremium) {
                              this._gamesBloc.updateGameSink.add(this.currentGame);
                            } else {
                              _localGamesBloc.localGameUpdated(
                                  updatedGame: currentGame);
                            }
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      tooltip: "Zug zurück",
                      onPressed: this._chessBoardController.game.history.isEmpty
                          ? null
                          : () {
                              setState(() {
                                this.movesList.add(this
                                    ._chessBoardController
                                    .game
                                    .undo_move());
                                currentGame.pgn =
                                    _chessBoardController.game.pgn();
                                currentGame.moveCount =
                                    _chessBoardController.game.move_number;
                                if (widget.isUserPremium) {
                                  this
                                      ._gamesBloc
                                      .updateGameSink
                                      .add(this.currentGame);
                                } else {
                                  _localGamesBloc.localGameUpdated(
                                      updatedGame: currentGame);
                                }
                              });
                            },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      tooltip: "Zug vor",
                      onPressed: this.movesList.isEmpty
                          ? null
                          : () {
                              setState(() {
                                this
                                    ._chessBoardController
                                    .game
                                    .make_move(movesList.last);
                                this.movesList.removeLast();
                                currentGame.pgn =
                                    _chessBoardController.game.pgn();
                                currentGame.moveCount =
                                    _chessBoardController.game.move_number;
                                if (widget.isUserPremium) {
                                  this
                                      ._gamesBloc
                                      .updateGameSink
                                      .add(this.currentGame);
                                } else {
                                  _localGamesBloc.localGameUpdated(
                                      updatedGame: currentGame);
                                }
                              });
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}