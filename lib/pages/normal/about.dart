// about.dart
import "../../imports.dart";

// TODO: add link to flutter_chess_board LICENSE

class About extends StatelessWidget {
  _createFeedbackMail() async {
    const url =
        "mailto:justchess.app@gmail.com?subject=Feedback%20und%20Verbesserungsvorschläge%20für%20JustChess&body=";
    bool canLaunchUrl = await canLaunch(url);
    if (canLaunchUrl) {
      await launch(url);
    } else {
      throw "Could not launch: $url";
    }
  }

  _launchGithubPage() async {
    const url = "https://github.com/QW3RTZUI0P/JustChess";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // TODO: give every the button the right functionality
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var appBar = AppBar(
      title: Text("Über"),
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 5.0),
              Row(
                children: [
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "ALLGEMEIN",
                    style: theme.textTheme.subtitle2,
                  ),
                ],
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Feedback und Verbesserungsvorschläge",
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text("via E-Mail"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => _createFeedbackMail(),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Im App Store bewerten"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Datenschutzerklärung"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Nutzungsbedingungen"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "ÜBER UNS",
                    style: theme.textTheme.subtitle2,
                  ),
                ],
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Unsere Website"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Auf Github beitragen"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => _launchGithubPage(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "DANKSAGUNG",
                    style: theme.textTheme.subtitle2,
                  ),
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Vielen Dank an alle meine Beta Tester auf Testflight!",
                    maxLines: 100,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "QUELLEN",
                    style: theme.textTheme.subtitle2,
                  ),
                ],
              ),
              Card(
                child: ListTile(
                  title: Text("Quellen für App Icon"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
