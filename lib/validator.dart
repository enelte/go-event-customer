class Validator {
  Validator._();

  static String defaultValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  static String emailValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  static String noValidator(String value) {
    return null;
  }
}
