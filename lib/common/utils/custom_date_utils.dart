import 'package:intl/intl.dart';

class CustomDateUtils {
  static DateTime parseDateTime(String? dateTime) =>
      DateTime.tryParse(dateTime ?? '') ?? DateTime(9999);

  static String formatDateTime(DateTime dateTime) =>
      DateFormat('yyyy-MM-dd').format(dateTime);
}
