// partie.dart
import "../imports.dart";

// TODO: clean this file up and split it in separate widgets
// TODO: think of a solution to solve the problem with variables just being references
class Partie extends StatefulWidget {
  final PartieKlasse aktuellePartie;
  final GameBloc gameBloc;
  Partie({
    this.aktuellePartie,
    this.gameBloc,
  }) {
    print("Partie");
  }

  @override
  _PartieState createState() => _PartieState();
}

class _PartieState extends State<Partie> with AfterLayoutMixin<Partie> {
  GameBloc gameBloc;
  PartieKlasse partieInKlasse;
  ChessBoardController chessBoardController = ChessBoardController();
  bool isUserWhite;
  bool isUsersTurn;

  @override
  void initState() {
    super.initState();
    this.partieInKlasse = PartieKlasse.from(widget.aktuellePartie);
    this.isUserWhite = (partieInKlasse.player01IsWhite &&
                widget.gameBloc.currentUserID == partieInKlasse.player01) ||
            (!partieInKlasse.player01IsWhite &&
                widget.gameBloc.currentUserID == partieInKlasse.player02)
        ? true
        : false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.gameBloc = GameBlocProvider.of(context).gameBloc;
  }

  @override
  // Funktion aus dem Package after_layout
  void afterFirstLayout(BuildContext context) {
    if (this.isUsersTurn == null) {
      setState(() {
        this.isUsersTurn = usersTurn();
      });
    }
    // lädt den letzten gespeicherten Spielstand automatisch auf das Schachfeld
    chessBoardController.loadPGN(this.partieInKlasse.pgn ?? "");
    print(this.partieInKlasse.pgn);
  }

  bool usersTurn() {
    String turn = chessBoardController.game.turn.toString();
    if ((turn == "w" && isUserWhite) || (turn == "b" && !isUserWhite)) {
      return true;
    }  else {
      return false;
    }
  }

  void confirmMove({@required PartieKlasse gameToSafe}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  chessBoardController.loadPGN(partieInKlasse.pgn ?? "");
                  print("partieINKlasse: " + this.partieInKlasse.pgn);
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  setState(() {
                    this.isUsersTurn = false;
                    this.partieInKlasse.pgn = chessBoardController.game.pgn();
                  });
                  safeGame(game: gameToSafe);
                  Navigator.pop(context);
                  chessBoardController.loadPGN(this.partieInKlasse.pgn);
                },
              ),
            ],
          );
        });
  }

  void safeGame({PartieKlasse game}) {
    gameBloc.updateGameSink.add(game);
  }

  @override
  Widget build(BuildContext context) {
    print("building");
    Size size = MediaQuery.of(context).size;
    PartieKlasse partie = PartieKlasse.from(partieInKlasse);

    double boardSize =
        size.width < size.height ? size.width * 0.9 : size.height * 0.9;

    var appBar = AppBar(
      title: Text(partie.name ?? ""),
      actions: <Widget>[IconButton(icon: Icon(Icons.refresh), onPressed: () {
        setState(() {
          this.isUsersTurn = usersTurn();
        });
      },)],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        
        onPressed: () {
          partie.pgn = chessBoardController.game.pgn();
          safeGame(game: partie);

          Navigator.pop(context);
        },
      ),
    );
    var chessBoard = ChessBoard(
      size: boardSize,
      whiteSideTowardsUser: this.isUserWhite,
      enableUserMoves: this.isUsersTurn,
      onMove: (move) {
        partie.pgn = chessBoardController.game.pgn();
        confirmMove(gameToSafe: partie);
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
      chessBoardController: chessBoardController,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chessBoardController.loadPGN(this.partieInKlasse.pgn);
    });
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Scrollbar(
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
                      chessBoard.whiteSideTowardsUser
                          ? VertikaleZahlenWeiss(
                              height: boardSize,
                            )
                          : VertikaleZahlenSchwarz(
                              height: boardSize,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      chessBoard,
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  chessBoard.whiteSideTowardsUser
                      ? Center(
                          child: HorizontaleBuchstabenWeiss(
                            width: boardSize,
                          ),
                        )
                      : Center(
                          child: HorizontaleBuchstabenSchwarz(
                            width: boardSize,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
