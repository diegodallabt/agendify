import '../../modules/schedule/model/post_model.dart';

class CalendarUtils {
  static List<DateTime?> generateDaysForMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstWeekdayIndex = firstDayOfMonth.weekday - 1;
    final days = <DateTime?>[];

    for (int i = 0; i < firstWeekdayIndex; i++) {
      days.add(null);
    }

    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    while (days.length % 7 != 0) {
      days.add(null);
    }

    return days;
  }

  static bool hasPostForDate(DateTime date, List<PostModel> allPosts) {
    final clean = DateTime(date.year, date.month, date.day);
    return allPosts.any((p) {
      final postDate = DateTime(p.date.year, p.date.month, p.date.day);
      return postDate == clean;
    });
  }

  static int countPostsForDate(DateTime date, List<PostModel> allPosts) {
    final clean = DateTime(date.year, date.month, date.day);
    return allPosts.where((p) {
      final pClean = DateTime(p.date.year, p.date.month, p.date.day);
      return pClean == clean;
    }).length;
  }

  static String monthName(int month) {
    const months = [
      '',
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return months[month];
  }
}
