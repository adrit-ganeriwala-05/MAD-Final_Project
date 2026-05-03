import 'package:intl/intl.dart';

/// Extension methods on [DateTime].
extension DateTimeX on DateTime {
  /// Formats as `"Apr 20, 2026"`.
  String toDisplayDate() => DateFormat('MMM d, y').format(this);

  /// Formats as `"Apr 20 – May 3"` given an [end] date.
  String toDateRange(DateTime end) =>
      '${DateFormat('MMM d').format(this)} – ${DateFormat('MMM d').format(end)}';
}

/// Extension methods on [String].
extension StringX on String {
  /// Returns `true` if the string is a valid email address.
  bool get isValidEmail => RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(this);

  /// Capitalises the first letter of the string.
  String get capitalised =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);
}
