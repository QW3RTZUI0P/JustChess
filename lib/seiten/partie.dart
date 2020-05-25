// partie.dart
import "../imports.dart";

class Partie extends StatefulWidget {
  final PartieKlasse aktuellePartie;

  Partie({this.aktuellePartie});

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
    chessBoardController.loadPGN(this.partieInKlasse.pgn);
  }

  @override
  Widget build(BuildContext context) {
    PartienProvider partienProvider = Provider.of<PartienProvider>(context);
    Size size = MediaQuery.of(context).size;
    PartieKlasse partie = this.partieInKlasse;

    return Scaffold(
      appBar: AppBar(
        title: Text(partie.name),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            String pgn = chessBoardController.game.pgn();
            partie.pgn = pgn;
            // speichert die Partie automatisch
            partienProvider.partieUpgedatet(
              altePartie: widget.aktuellePartie,
              neuePartie: partie,
            );
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  VertikaleZahlen(
                    height: size.width * 0.9,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ChessBoard(
                    size: size.width * 0.9,
                    whiteSideTowardsUser: partie.benutzerIstWeiss,
                    onMove: (move) {
                      partie.anzahlDerZuege += 0.5;
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
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: HorizontaleBuchstaben(
                  width: size.width * 0.9,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
