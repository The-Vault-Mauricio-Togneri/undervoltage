import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime dateTime) {
    final String date = DateFormat.yMMMMd().format(dateTime);
    final String time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }
}
