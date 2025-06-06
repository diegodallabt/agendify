import 'package:flutter/material.dart';
import '../../schedule/model/post_model.dart';

class CalendarViewModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final List<PostModel> _allPosts;

  CalendarViewModel(this._allPosts);

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedMonth => _focusedMonth;
  List<PostModel> get allPosts => List.unmodifiable(_allPosts);

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

  bool hasPostForDate(DateTime date) {
    final clean = DateUtils.dateOnly(date);
    return _allPosts.any((p) => DateUtils.isSameDay(p.date, clean));
  }

  List<PostModel> getPostsForSelectedDate() {
    final clean = DateUtils.dateOnly(_selectedDate);
    return _allPosts.where((p) => DateUtils.isSameDay(p.date, clean)).toList();
  }

  void updatePosts(List<PostModel> posts) {
    _allPosts
      ..clear()
      ..addAll(posts);
    notifyListeners();
  }
}
