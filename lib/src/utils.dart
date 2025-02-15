import 'dart:math';

class Utils {
  static double fixed(double value, int decimal) {
    int fac = pow(10, decimal) as int;
    return (value * fac).round() / fac;
  }
}

extension ListExt<T> on List<T> {
  T? getOrNull(int index) => index < length ? this[index] : null;
}
