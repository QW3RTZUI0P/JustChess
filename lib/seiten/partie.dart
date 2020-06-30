// partie.dart
import "../imports.dart";

class Partie extends StatefulWidget {
  final PartieKlasse aktuellePartie;
  final GameBloc gameBloc;

  Partie({
    this.aktuellePartie,
    this.gameBloc,
  });

  @override
  _PartieState createState() => _PartieState();
}

class _PartieState extends State<Partie> with AfterLayoutMixin<Partie> {
  PartieKlasse partieInKlasse;
  ChessBoardController chessBoardController = ChessBoardController();

  @override
  void initState() {
    super.initState();
    this.partieInKlasse = widget.aktuellePartie;
  }

 

  @override
  // Funktion aus dem Package after_layout
  void afterFirstLayout(BuildContext context) {
    // lädt den letzten gespeicherten Spielstand automatisch auf das Schachfeld
    chessBoardController.loadPGN(this.partieInKlasse.pgn ?? "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PartieKlasse partie = this.partieInKlasse;

    var appBar = AppBar(
      title: Text(partie.name ?? ""),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          String pgn = chessBoardController.game.pgn();
          partie.pgn = pgn;
          widget.gameBloc.cloudFirestoreDatabase
              .updateGameFromFirestore(game: partie);
          print("pgn " + partie.pgn);
          print("id " + partie.id);
          // speichert die Partie automatisch
          // partienProvider.partieUpgedatet(
          //   altePartie: widget.aktuellePartie,
          //   neuePartie: partie,
          // );
          Navigator.pop(context);
        },
      ),
    );
    var chessBoard = ChessBoard(
      size: size.width * 0.9,
      whiteSideTowardsUser: partie.player01IsWhite,
      onMove: (move) {
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
                              height: size.width * 0.9,
                            )
                          : VertikaleZahlenSchwarz(
                              height: size.width * 0.9,
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
                            width: size.width * 0.9,
                          ),
                        )
                      : Center(
                          child: HorizontaleBuchstabenSchwarz(
                            width: size.width * 0.9,
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
