String formatDate(DateTime? date, {bool isYear = false}) {
  if (date == null) return '';
  if (isYear) {
    return '${date.day}/${date.month}/${date.year}';
  }
  return '${date.day}/${date.month}';
}

String formatTaskDate(DateTime? startDate, DateTime? endDate) {
  String start = formatDate(startDate);
  String end = formatDate(endDate);

  if (start.isNotEmpty && end.isNotEmpty) {
    return '$start - $end';
  } else if (start.isNotEmpty) {
    return 'Ngày bắt đầu: $start';
  } else if (end.isNotEmpty) {
    return 'Ngày kết thúc: $end';
  } else {
    return '';
  }
}

String formatDateRange(DateTime startDate, DateTime endDate) {
  final now = DateTime.now();
  final sameYear = startDate.year == now.year && endDate.year == now.year;

  String formatDate(DateTime date, bool showYear) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    if (showYear) {
      final year = date.year.toString();
      return '$day/$month/$year';
    } else {
      return '$day/$month';
    }
  }

  final startDateString = formatDate(startDate, !sameYear);
  final endDateString = formatDate(endDate, !sameYear);

  return '$startDateString - $endDateString';
}

String formatTimeRange(DateTime startTime, DateTime endTime) {
  String formatTime(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  final startTimeString = formatTime(startTime);
  final endTimeString = formatTime(endTime);

  return '$startTimeString - $endTimeString';
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
