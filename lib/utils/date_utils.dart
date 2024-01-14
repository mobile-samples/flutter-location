import 'package:intl/intl.dart';

class DateUtils {
  static formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return showDate(date);
  }

  static String showDate(DateTime date) {
    DateTime now = DateTime.now();

    Duration difference = now.difference(date);

    if (difference.inDays > 30) {
      return DateFormat.yMMMMd().format(date);
    } else if (difference.inDays >= 2) {
      String daysAgo = '${difference.inDays} days ago';
      dynamic month = (difference.inDays / 30).floor();
      String monthsAgo = '$month months ago';

      if (month > 0) {
        return '$daysAgo, $monthsAgo';
      } else {
        return daysAgo;
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours == 1) {
      return 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes == 1) {
      return 'A minute ago';
    } else {
      return 'Just now';
    }
  }
}
