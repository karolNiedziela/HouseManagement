class EmailValidator {
  static String? baseEmailValidator(String? value) {
    if (value!.isEmpty) {
      return ('Wprowadź adres email.');
    }

    // reg expression for email
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return ("Wprowadź poprawny adres email.");
    }
    return null;
  }
}
