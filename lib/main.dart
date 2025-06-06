import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/hive/hive_config.dart';
import 'modules/schedule/viewmodel/schedule_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  final viewModel = ScheduleViewModel();
  await viewModel.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Agendify(),
    ),
  );
}