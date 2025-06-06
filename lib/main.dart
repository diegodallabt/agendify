import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/hive/hive_config.dart';
import 'modules/calendar/viewmodel/calendar_viewmodel.dart';
import 'modules/schedule/viewmodel/schedule_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  final scheduleViewModel = ScheduleViewModel();
  await scheduleViewModel.init();

  final calendarViewModel = CalendarViewModel();
  await calendarViewModel.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ScheduleViewModel>.value(
          value: scheduleViewModel,
        ),
        ChangeNotifierProvider<CalendarViewModel>.value(
          value: calendarViewModel,
        ),
      ],
      child: const Agendify(),
    ),
  );
}
