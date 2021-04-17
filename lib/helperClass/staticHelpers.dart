class StaticHelpers {
  static double? checkDouble(dynamic input, double? fallback) {
    switch (input.runtimeType) {
      case String:
        return double.tryParse(input) ?? fallback;
      case int:
        return input + .0;
      case double:
        return input;
      default:
        return fallback;
    }
  }

  static double checkDoubleN(dynamic input, double fallback) {
    switch (input.runtimeType) {
      case String:
        return double.tryParse(input) ?? fallback;
      case int:
        return input + .0;
      case double:
        return input;
      default:
        return fallback;
    }
  }
}
