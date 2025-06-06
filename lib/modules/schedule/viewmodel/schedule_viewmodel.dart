import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/post_model.dart';

class ScheduleViewModel extends ChangeNotifier {
  late Box<PostModel> _box;

  List<PostModel> get posts => _box.values.toList();

  Future<void> init() async {
    _box = Hive.box<PostModel>('scheduled_posts');
    notifyListeners();
  }

  Future<void> addPost(PostModel post) async {
    await _box.add(post);
    notifyListeners();
  }

  List<PostModel> getPostsForDate(DateTime date) {
    return _box.values.where((p) =>
      p.date.year == date.year &&
      p.date.month == date.month &&
      p.date.day == date.day
    ).toList();
  }
}
