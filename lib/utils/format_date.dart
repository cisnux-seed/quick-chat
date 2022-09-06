import 'package:intl/intl.dart';

String formatDate(DateTime createdAt) {
  final now = DateTime.now();
  // today
  if (now.difference(createdAt).inHours < 24) {
    return 'Today, ${DateFormat.jm().format(createdAt)}';
  }
  // today
  else if (now.difference(createdAt).inDays == 1) {
    return 'Yesterday, ${DateFormat.jm().format(createdAt)}';
  }
  // month ago
  else if ((now.difference(createdAt).inDays / 30).floor() >= 1) {
    return '${DateFormat.MMMd().format(createdAt)}, ${DateFormat.jm().format(createdAt)}';
  }
  // year ago
  return '${DateFormat.yMMMd().format(createdAt)}, ${DateFormat.jm().format(createdAt)}';
}
