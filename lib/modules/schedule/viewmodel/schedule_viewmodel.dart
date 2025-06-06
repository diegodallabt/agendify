import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/post_model.dart';

class ScheduleViewModel extends ChangeNotifier {
  late Box<PostModel> _box;
  bool _isLoading = false;
  final List<String> _imageOptions = [];
  final _random = Random();
  String? _selectedImageUrl;

  List<String> get imageOptions => List.unmodifiable(_imageOptions);
  String? get selectedImageUrl => _selectedImageUrl;
  List<PostModel> get posts => _box.values.toList();
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _box = Hive.box<PostModel>('scheduled_posts');
    loadInitialImages(); 
    notifyListeners();
  }

  Future<void> addPost(PostModel post) async {
    await _box.add(post);
    notifyListeners();
  }

  List<PostModel> getPostsForDate(DateTime date) {
    return _box.values
        .where(
          (p) =>
              p.date.year == date.year &&
              p.date.month == date.month &&
              p.date.day == date.day,
        )
        .toList();
  }

  void loadInitialImages() {
    final initialImages = List.generate(10, (_) {
      final seed = _random.nextInt(10000);
      return 'https://picsum.photos/200/300?seed=$seed';
    });

    _imageOptions.addAll(initialImages);
    notifyListeners();
  }

  void addScrollEndListener({
  required ScrollController controller,
  required VoidCallback onEndReached,
  double offset = 100,
}) {
  controller.addListener(() {
    if (controller.position.pixels >= controller.position.maxScrollExtent - offset) {
      onEndReached();
    }
  });
}

  Future<void> loadMoreImages() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final moreImages = List.generate(10, (_) {
      final seed = _random.nextInt(10000);
      return 'https://picsum.photos/200/300?seed=$seed';
    });

    _imageOptions.addAll(moreImages);
    _isLoading = false;
    notifyListeners();
  }

  void selectImage(String url) {
    _selectedImageUrl = url;
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImageUrl = null;
    notifyListeners();
  }
}
