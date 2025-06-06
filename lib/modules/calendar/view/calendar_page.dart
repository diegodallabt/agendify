import 'package:agendify/modules/calendar/widget/card.dart';
import 'package:agendify/modules/calendar/widget/empty_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/calendar_viewmodel.dart';
import '../widget/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarViewModel>();
    final dayPosts = calendar.getPostsForSelectedDate();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed('/schedule').then((_) {
            context.read<CalendarViewModel>().refresh();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final contentWidth = isTablet ? 600.0 : constraints.maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Postagens agendadas',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                      const SizedBox(height: 32),
                      AFYCalendar(
                        selectedDate: calendar.selectedDate,
                        focusedMonth: calendar.focusedMonth,
                        allPosts: calendar.allPosts,
                        onDateSelected: calendar.selectDate,
                        onNextMonth: calendar.nextMonth,
                        onPreviousMonth: calendar.previousMonth,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Postagens agendadas',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: dayPosts.isEmpty
                  ? const AFYEmptyContainer()
                  : ListView.builder(
                          itemCount: dayPosts.length,
                          itemBuilder: (context, index) {
                            final post = dayPosts[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: AFYCard(
                                post: post,
                                onEdit: () {
                                  Navigator.of(context)
                                      .pushNamed('/schedule', arguments: post)
                                      .then((_) {
                                        context
                                            .read<CalendarViewModel>()
                                            .refresh();
                                      });
                                },
                                onDelete: () async {
                                  await calendar.deletePost(post);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Post excluído'),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
