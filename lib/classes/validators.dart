// validators.dart
class Validators {
  /* Diese Funktionen werden in registrierung.dart und in anmeldung.dart benutzt,
  um die Eingaben des Users in ein TextFormField zu überprüfen */
  String checkUsername({String benutzername}) {
    if (benutzername.isEmpty || benutzername.split("").length < 4) {
      return "Der Benutzername muss mindestens vier Zeichen enthalten";
    } else {
      return null;
    }
  }

  String checkEmail({String email}) {
    if (email.contains(".") && email.contains("@")) {
      return null;
    } else {
      return "Bitte eine gültige Email Adresse eingeben";
    }
  }

  String checkPassword({String passwort}) {
    if (passwort.split("").length < 8) {
      return "Das Passwort muss mindestens acht Zeichen lang sein";
    } else {
      return null;
    }
  }
}
