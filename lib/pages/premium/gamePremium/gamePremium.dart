// gamePremium.dart
import 'package:flutter/services.dart';

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
  _GamePremiumState createState() => _GamePremiumState();
}

class _GamePremiumState extends State<GamePremium> {
  // bloc that controls the loading, updating and saving of the games
  GamesBloc _gameBloc;
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
    this._gameBloc = GamesBlocProvider.of(context).gamesBloc;
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;

    double boardSize =
        size.width < size.height ? size.width * 0.9 : size.height * 0.9;

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
                ._gameBloc
                .cloudFirestoreDatabase
                .getGameFromFirestore(gameID: currentGame.id);
            this._gameBloc.updateGameSink.add(updatedGame);
            setState(() {
              this.currentGame = GameClass.from(updatedGame);
              this.isUsersTurn = usersTurn();
            });
            chessBoardController.loadPGN(currentGame.pgn);
          },
        ),
        // button that provides more options for the user (e.g. edit name of game, export pgn, ...)
        Builder(
          builder: (BuildContext context) => DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              icon: Icon(
                Icons.more_vert,
                color: theme.appBarTheme.actionsIconTheme.color,
              ),
              value: _dropdownButtonValue,
              hint: Text(""),
              // makes the DropdownButton show nothing except the Menu Icon
              selectedItemBuilder: (BuildContext context) {
                return dropdownButtonItems
                    .map<Widget>((currentItem) => Text(""))
                    .toList();
              },
              underline: null,
              items: this
                  .dropdownButtonItems
                  .map<DropdownMenuItem<int>>(
                    (currentItem) => DropdownMenuItem(
                      value: this.dropdownButtonItems.indexOf(currentItem),
                      child: Column(
                        children: <Widget>[
                          Text(currentItem),
                          Divider(),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              elevation: 0,
              onChanged: (int newValue) {
                switch (newValue) {
                  case 1:
                  case 2:
                  case 3:
                    Clipboard.setData(
                      ClipboardData(text: currentGame.pgn),
                    );
                    // shows a SnackBar that informs the user that the PGN has been pasted to the clipboard
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("PGN wurde in die Zwischenablage kopiert"),
                      ),
                    );
                    return;
                  default:
                    return;
                }
              },
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
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
      ),
    );
  }
}
