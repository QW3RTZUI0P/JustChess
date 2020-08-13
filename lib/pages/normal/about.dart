// about.dart
import "../../imports.dart";

class About extends StatelessWidget {
  _createFeedbackMail() async {
    const url =
        "mailto:justchess.app@gmail.com?subject=Feedback%20JustChess&body=";
    bool canLaunchUrl = await canLaunch(url);
    if (canLaunchUrl) {
      await launch(url);
    } else {
      throw "Could not launch: $url";
    }
  }

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
        child: ListView(
          
          children: <Widget>[
            Card(
              child: Text(
                  "hier stehen dann mal ein paar Infos. Information, Information, Information, Information"),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Feedback geben"),
                    onTap: () => _createFeedbackMail(),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Datenschutzerklärung"),
                    onTap: () {},
                  )
                ],
              ),
            ),
          ],
        ),
        // child: SingleChildScrollView(
        //   padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        //   child: Container(
        //     color: Colors.red,
        //     height: mediaQueryData.size.height -
        //         appBar.preferredSize.height -
        //         mediaQueryData.padding.top -
        //         mediaQueryData.padding.bottom,
        //     width: mediaQueryData.size.width -
        //         mediaQueryData.padding.left -
        //         mediaQueryData.padding.right,
        //     child: Column(
        //       mainAxisSize: MainAxisSize.max,
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        // Text("hier stehen dann mal ein paar Infos"),
        // RaisedButton(
        //   child: Text("Feedback geben"),
        //   onPressed: () => _createFeedbackMail(),
        // ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
