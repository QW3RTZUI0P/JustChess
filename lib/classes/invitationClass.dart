// invitationClass.dart
import "dart:convert";

class InvitationClass {
  String fromUsername;
  String toUsername;
  String fromID;
  String toID;
  String gameID;
  InvitationClass({
    this.fromUsername = "",
    this.toUsername = "",
    this.fromID = "",
    this.toID = "",
    this.gameID = "",
  });

  factory InvitationClass.fromJsonMap(Map<String, dynamic> jsonMap) {
    return InvitationClass(
      fromUsername: jsonMap["fromUsername"],
      toUsername: jsonMap["toUsername"],
      fromID: jsonMap["fromID"],
      toID: jsonMap["toID"],
      gameID: jsonMap["gameID"],
    );
  }

  Map toJsonMap() {
    return {
      "fromUsername": this.fromUsername,
      "toUsername": this.toUsername,
      "fromID": this.fromID,
      "toID": this.toID,
      "gameID": this.gameID,
    };
  }
}
