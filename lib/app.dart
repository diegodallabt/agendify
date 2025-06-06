import 'package:agendify/modules/calendar/view/calendar_page.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'modules/schedule/view/schedule_page.dart';

class Agendify extends StatelessWidget {
  const Agendify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendify',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/calendar',
      routes: {
        '/calendar': (context) => const CalendarPage(),
        '/schedule': (context) => const SchedulePage(),
      },
    );
  }
}