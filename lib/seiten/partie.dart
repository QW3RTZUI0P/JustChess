// partie.dart
import "../imports.dart";

class Partie extends StatefulWidget {
  final PartieKlasse aktuellePartie;

  Partie({this.aktuellePartie});

  @override
  _PartieState createState() => _PartieState();
}

class _PartieState extends State<Partie> {
  PartieKlasse partie;
  ChessBoardController chessBoardController = ChessBoardController();

  @override
  void initState() {
    super.initState();
    this.partie = widget.aktuellePartie;
  }

  @override
  Widget build(BuildContext context) {
    PartienProvider partienProvider = Provider.of<PartienProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(this.partie.name),
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
                  RaisedButton(
                    child: Text("Spiel laden"),
                    onPressed: () {
                      this.chessBoardController.loadPGN(this.partie.pgn);
                    },
                  ),
                  RaisedButton(
                    child: Text("Spiel speichern"),
                    onPressed: () {
                      String pgn = chessBoardController.game.pgn();
                      PartieKlasse neuePartie = this.partie;
                      neuePartie.pgn = pgn;
                      partienProvider.partieUpgedatet(
                        altePartie: widget.aktuellePartie,
                        neuePartie: neuePartie,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  VertikaleZahlen(
                    height: MediaQuery.of(context).size.width * 0.8,
                  ),
                  ChessBoard(
                    size: MediaQuery.of(context).size.width * 0.8,
                    onMove: (move) {
                      print(move);
                    },
                    onCheckMate: (color) {
                      print(color);
                    },
                    onDraw: () {
                      print("DRAW");
                    },
                    chessBoardController: chessBoardController,
                  ),
                ],
              ),
              Center(
                child: HorizontaleBuchstaben(
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
