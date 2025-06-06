import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../schedule/model/post_model.dart';

class CalendarViewModel extends ChangeNotifier {
  late Box<PostModel> _box;

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> init() async {
    _box = Hive.box<PostModel>('scheduled_posts');
    notifyListeners();
  }

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedMonth => _focusedMonth;

  List<PostModel> get allPosts => _box.values.toList();

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void previousMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
  }

  Future<void> deletePost(PostModel post) async {
    await post.delete();
    notifyListeners();
  }

  bool hasPostForDate(DateTime date) {
    final clean = DateUtils.dateOnly(date);
    return _box.values.any((p) => DateUtils.isSameDay(p.date, clean));
  }

  List<PostModel> getPostsForSelectedDate() {
    final clean = DateUtils.dateOnly(_selectedDate);
    return _box.values
        .where((p) => DateUtils.isSameDay(p.date, clean))
        .toList();
  }

  void refresh() {
    notifyListeners();
  }
}
