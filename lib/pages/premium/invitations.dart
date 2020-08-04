// invitations.dart
import "../../imports.dart";

class Invitations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einladungen"),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("hier stehen dann irgendwann alle Einladungen"),
            ),
          ],
        ),
      ),
    );
  }
}
