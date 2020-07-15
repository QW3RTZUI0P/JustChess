// createOfflineGame.dart
import "../../imports.dart";

class CreateOfflineGame extends StatefulWidget {
  @override
  _CreateOfflineGameState createState() => _CreateOfflineGameState();
}

class _CreateOfflineGameState extends State<CreateOfflineGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("createOfflineGame"),
            ],
          ),
        ),
      ),
    );
  }
}
