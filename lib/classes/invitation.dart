// invitation.dart

class Invitation {
  String fromUsername;
  String toUsername;
  String fromID;
  String toID;
  String gameID;
  Invitation({
    this.fromUsername = "",
    this.toUsername = "",
    this.fromID = "",
    this.toID = "",
    this.gameID = "",
  });

  Map toJson() {
    return {
      "fromUsername": this.fromUsername,
      "toUsername": this.toUsername,
      "fromID": this.fromID,
      "toID": this.toID,
      "gameID": this.gameID,
    };
  }
}
