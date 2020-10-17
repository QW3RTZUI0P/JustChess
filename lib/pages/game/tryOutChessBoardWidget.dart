// tryOutChessBoardWidget.dart
import "../../imports.dart";
import "package:chess/chess.dart" as chess;

class TryOutChessBoardWidget extends StatefulWidget {
  final String pgn;
  final bool isUserWhite;
  final double appBarHeight;
  TryOutChessBoardWidget({
    @required this.pgn,
    @required this.isUserWhite,
    @required this.appBarHeight,
  });

  @override
  _TryOutChessBoardWidgetState createState() => _TryOutChessBoardWidgetState();
}

class _TryOutChessBoardWidgetState extends State<TryOutChessBoardWidget> {
  ChessBoardController _chessBoardController = ChessBoardController();
  // list with the moves the user has undone
  List<chess.Move> movesList = [];
  // shows the user the current game status
  String currentGameStatus = "";
  // values for the "Backward" and "Forward" buttons
  bool allowForward = true;
  // TODO: make this clearer and clean this up
  String lastSavedGameStatus = "";

  @override
  void initState() {
    super.initState();
    _chessBoardController.loadPGN(widget.pgn);
  }

  @override
  Widget build(BuildContext context) {
    print("building try out");
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;

    double boardSize = size.width < size.height
        ? size.width * 0.9
        : size.height * 0.8 - widget.appBarHeight;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      currentGameStatus ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headline6,
                    ),
                    SizedBox(height: boardSize * 0.05),
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
                        ChessBoard(
                          chessBoardController: _chessBoardController,
                          whiteSideTowardsUser: widget.isUserWhite,
                          size: boardSize,
                          onMove: (String move) {
                            print("move");
                            setState(() {
                              allowForward = false;
                              currentGameStatus = "";
                              lastSavedGameStatus = "";
                              movesList.clear();
                            });
                          },
                          onDraw: () {
                            setState(() {
                              currentGameStatus = "Unentschieden";
                              lastSavedGameStatus = "Unentschieden";
                            });
                          },
                          onCheckMate: (PieceColor color) {
                            setState(() {
                              currentGameStatus = color == PieceColor.Black
                                  ? "Weiß hat gewonnen"
                                  : "Schwarz hat gewonnen";
                              lastSavedGameStatus = color == PieceColor.Black
                                  ? "Weiß hat gewonnen"
                                  : "Schwarz hat gewonnen";
                            });
                          },
                          onCheck: (_) {},
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
                    const SizedBox(
                      height: 5,
                    ),
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
                                this._chessBoardController.loadPGN(widget.pgn);
                                currentGameStatus = "";
                                allowForward = true;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          tooltip: "Zug zurück",
                          onPressed:
                              this._chessBoardController.game.history.isEmpty
                                  ? null
                                  : () {
                                      setState(() {
                                        movesList.add(this
                                            ._chessBoardController
                                            .game
                                            .undo_move());
                                        currentGameStatus = "";
                                        allowForward = true;
                                      });
                                    },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          tooltip: "Zug vor",
                          onPressed: this.movesList.isEmpty ||
                                  allowForward == false
                              ? null
                              : () {
                                  setState(() {
                                    _chessBoardController.game
                                        .make_move(movesList.last);
                                    movesList.removeLast();
                                    currentGameStatus = "";
                                    allowForward = true;
                                    if (movesList.length == 0) {
                                      currentGameStatus = lastSavedGameStatus;
                                    }
                                  });
                                },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
