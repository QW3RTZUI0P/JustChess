// home.dart
import "../imports.dart";

class Home extends StatefulWidget {
  List<PartieKlasse> partien = [];
  var partieGeloescht;
  Home({
    this.partien,
    this.partieGeloescht,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("JustChess"),
        ),
        floatingActionButton: PartieErstellenButton(),
        body: SafeArea(
            child: widget.partien.isEmpty
                ? Center(
                    child: Text("Noch keine Partien hinzugefügt"),
                  )
                : Scrollbar(
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(
                              widget.partien[index].id,
                            ),
                            child: ListTile(
                              title: Text(widget.partien[index].name),
                              subtitle: Text(
                                  "Anzahl der Züge: ${widget.partien[index].anzahlDerZuege.toString()}"),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    fullscreenDialog: false,
                                    builder: (context) => Partie(
                                      aktuellePartie: widget.partien[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                            background: Icon(Icons.delete),
                            secondaryBackground: Icon(Icons.delete),
                            onDismissed: (direction) => widget.partieGeloescht(
                                partie: widget.partien[index]),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemCount: widget.partien.length),
                  )));
  }
}
