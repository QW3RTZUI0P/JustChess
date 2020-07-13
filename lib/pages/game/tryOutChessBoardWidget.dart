// tryOutChessBoardWidget.dart
import "../../imports.dart";

class TryOutChessBoardWidget extends StatefulWidget {
  final String pgn;
  final bool isUserWhite;
  TryOutChessBoardWidget({
    @required this.pgn,
    @required this.isUserWhite,
  });

  @override
  _TryOutChessBoardWidgetState createState() => _TryOutChessBoardWidgetState();
}

class _TryOutChessBoardWidgetState extends State<TryOutChessBoardWidget> {
  ChessBoardController _chessBoardController = ChessBoardController();

  @override
  void initState() {
    super.initState();
    _chessBoardController.loadPGN(widget.pgn);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            height: size.height,
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
                    children: <Widget>[
                      ChessBoard(
                        chessBoardController: _chessBoardController,
                        whiteSideTowardsUser: widget.isUserWhite,
                        size: size.width > size.height
                            ? size.height * 0.9
                            : size.width * 0.9,
                        onMove: (move) {},
                        onDraw: () {},
                        onCheckMate: (color) {},
                        onCheck: (_) {},
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            child: Text("Zurücksetzen"),
                            onPressed: () => setState(() {_chessBoardController.loadPGN(widget.pgn);})
                                
                          ),
                          RaisedButton(
                            child: Text("Einen Zug zurück"),
                            onPressed: () {
                              setState(() {
                                _chessBoardController.game.undo_move();
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
      ),
    );
  }
}
