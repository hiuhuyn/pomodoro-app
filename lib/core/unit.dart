String formatDate(DateTime? date) {
  if (date == null) return '';

  return '${date.day}/${date.month}';
}

String formatTaskDate(DateTime? startDate, DateTime? dueDate) {
  String start = formatDate(startDate);
  String due = formatDate(dueDate);

  if (start.isNotEmpty && due.isNotEmpty) {
    return '$start - $due';
  } else if (start.isNotEmpty) {
    return 'Start: $start';
  } else if (due.isNotEmpty) {
    return 'Due: $due';
  } else {
    return '';
  }
}

String formatMinutesToHHMM(int totalMinutes) {
  if (totalMinutes < 60) {
    return '$totalMinutes phút';
  }
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;
  if (minutes == 0 && hours != 0) {
    return '$hours giờ';
  }

  return '$hours giờ $minutes phút';
}
