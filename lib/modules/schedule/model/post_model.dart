import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class PostModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? hour;

  @HiveField(5)
  String? urlImage;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.hour,
    required this.urlImage
  });
}
