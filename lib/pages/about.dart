// about.dart
import "../imports.dart";

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Über"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text("hier stehen dann mal ein paar Infos")],
          ),
        ),
      ),
    );
  }
}
