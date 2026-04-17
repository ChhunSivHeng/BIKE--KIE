import '../../../../model/pass.dart';

/// Utilities for booking screen
class BookingUtils {
  /// Format pass type name (capitalize first letter)
  static String formatPassTypeName(PassType type) {
    final name = type.name;
    return name.replaceFirst(name[0], name[0].toUpperCase());
  }

  /// Format date to display format (YYYY-MM-DD)
  static String formatDateForDisplay(DateTime date) {
    return date.toString().split(' ')[0];
  }

  /// Get location text with sector and availability
  static String getLocationText(int availableBikes) {
    return 'Sector 1 • $availableBikes bikes available';
  }

  /// Get pass status text
  static String getPassStatusText(bool hasPass) {
    return hasPass ? 'ACTIVE SUBSCRIPTION' : 'No Active Pass';
  }
}
