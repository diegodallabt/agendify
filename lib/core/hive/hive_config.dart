import 'package:hive_flutter/hive_flutter.dart';
import '../../modules/schedule/model/post_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PostModelAdapter());
  await Hive.openBox<PostModel>('scheduled_posts');
}
