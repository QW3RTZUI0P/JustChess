// settings.dart
import "../../imports.dart";

// TODO: add an option to only show the labeling on no or on only two sides of the chess board
// TODO: add an option to enable/disable autosaving the game after each move
class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          children: <Widget>[
            ListTile(
              title: Text("Einstellungen"),
            ),
            Row(
              children: <Widget>[
                Text("Premium"),
                Switch(
                  value: false,
                  onChanged: (updatedSwitch) {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
