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

  Future<String?> schedulePost({
    required String title,
    required String description,
    required DateTime? date,
    required String? hour,
    required String? urlImage,
  }) async {
    if (urlImage == null) {
      return 'Por favor, selecione uma imagem.';
    }
    if (title.trim().isEmpty) {
      return 'Por favor, informe um título.';
    }
    if (description.trim().isEmpty) {
      return 'Por favor, informe uma legenda.';
    }
    if (date == null) {
      return 'Por favor, selecione uma data.';
    }
    if (hour == null || hour.trim().isEmpty) {
      return 'Por favor, selecione um horário.';
    }

    final id = DateTime.now().microsecondsSinceEpoch.toString();

    final newPost = PostModel(
      id: id,
      title: title.trim(),
      description: description.trim(),
      date: date,
      hour: hour.trim(),
      urlImage: urlImage,
    );

    await addPost(newPost);

    return null;
  }

  Future<String?> updateExistingPost({
    required PostModel post,
    required String title,
    required String description,
    required DateTime? date,
    required String? hour,
    required String? urlImage,
  }) async {
    if (urlImage == null) {
      return 'Por favor, selecione uma imagem.';
    }
    if (title.trim().isEmpty) {
      return 'Por favor, informe um título.';
    }
    if (description.trim().isEmpty) {
      return 'Por favor, informe uma legenda.';
    }
    if (date == null) {
      return 'Por favor, selecione uma data.';
    }
    if (hour == null || hour.trim().isEmpty) {
      return 'Por favor, selecione um horário.';
    }

    post.title = title.trim();
    post.description = description.trim();
    post.date = date;
    post.hour = hour.trim();
    post.urlImage = urlImage;

    await post.save();
    notifyListeners();
    return null;
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
      return 'https://picsum.photos/seed/$seed/200/300';
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
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - offset) {
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
      return 'https://picsum.photos/seed/$seed/200/300';
    });

    _imageOptions.addAll(moreImages);
    _isLoading = false;
    notifyListeners();
  }

  void selectImage(String url) {
    _selectedImageUrl = url;
    notifyListeners();
  }

  void ensureImageOption(String url) {
    if (!_imageOptions.contains(url)) {
      _imageOptions.insert(0, url);
      notifyListeners();
    }
  }

  void selectExistingImage(String url) {
    ensureImageOption(url);
    selectImage(url);
  }

  void removeImageOption(String url) {
    if (_imageOptions.contains(url)) {
      _imageOptions.remove(url);
      notifyListeners();
    }
  }

  void resetImageOptions() {
    _imageOptions.clear();
    loadInitialImages();
  }

  void clearSelectedImage() {
    _selectedImageUrl = null;
    notifyListeners();
  }
}
