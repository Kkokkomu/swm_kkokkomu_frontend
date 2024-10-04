import 'package:intl/intl.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

class CustomDateUtils {
  static DateTime parseDateTime(String? dateTime) =>
      DateTime.tryParse(dateTime ?? '') ??
      DateTime(Constants.unknownErrorDateTimeYear);

  static String formatDateTime(DateTime dateTime) =>
      DateFormat('yyyy-MM-dd').format(dateTime);
}
