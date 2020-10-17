// validators.dart
class Validators {
  // used in SignUp and SignIn
  /// checks whether the username is empty or shorter than 4 letters
  String checkUsername({String benutzername}) {
    if (benutzername.isEmpty || benutzername.split("").length < 4) {
      return "Der Benutzername muss mindestens vier Zeichen enthalten";
    } else if (benutzername.contains(" ")) {
      return "Der Benutzername darf keine Leerzeichen enthalten";
    } else if (benutzername.contains(".") || benutzername.contains("@")) {
      return "Der Benutzername darf keine Punkte oder @ Zeichen enthalten";
    } else {
      return null;
    }
  }

  /// checks whether the email contains a . and a @
  String checkEmail({String email}) {
    if (email.contains(".") && email.contains("@")) {
      return null;
    } else {
      return "Bitte eine gültige Email Adresse eingeben";
    }
  }

  /// checks whether the passwort is longer than 8 letters
  String checkPassword({String password}) {
    if (password.split("").length < 8) {
      return "Das Passwort muss mindestens acht Zeichen lang sein";
    } else {
      return null;
    }
  }

  /// checks whether the sign in username is not empty
  String checkSignInUsername({String username}) {
    if (username.isEmpty || username == "") {
      return "Bitte einen Benutzernamen eingeben";
    } else {
      return null;
    }
  }

  /// checks whether the sign in passwort is not empty
  String checkSignInPassword({String password}) {
    if (password.isEmpty || password == "") {
      return "Bitte ein Passwort eingeben";
    } else {
      return null;
    }
  }

  // used in CreateGame
  /// checks whether the Game title is not null
  String checkGameTitle({String gameTitle}) {
    if (gameTitle.isEmpty || gameTitle == "") {
      return "Bitte einen Namen eingeben";
    } else {
      return null;
    }
  }
}
