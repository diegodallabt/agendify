import 'package:agendify/modules/calendar/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../schedule/model/post_model.dart';
import '../viewmodel/calendar_viewmodel.dart';
import '../widget/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final posts = <PostModel>[
    PostModel(
      id: '1',
      title: 'Lorem ipsum dolor sit amet',
      description:
          'Aliquam ex arcu, dapibus ut congue at, dictum quis purus. Donec consectetur...',
      date: DateTime(2025, 9, 9, 14, 5),
      hour: '14:05',
      urlImage:
          'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg',
    ),
    PostModel(
      id: '2',
      title: 'Etiam dui arcu, viverra non',
      description:
          'Aliquam erat volutpat. Aliquam dignissim felis non felis molestie, et gravida orci finibus...',
      date: DateTime(2025, 9, 9, 19, 5),
      hour: '19:05',
      urlImage:
          'https://images.pexels.com/photos/3573356/pexels-photo-3573356.jpeg',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarViewModel>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed('/schedule');
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Postagens agendadas',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 40),
              AFYCalendar(
                selectedDate: calendar.selectedDate,
                focusedMonth: calendar.focusedMonth,
                allPosts: calendar.allPosts,
                onDateSelected: calendar.selectDate,
                onNextMonth: calendar.nextMonth,
                onPreviousMonth: calendar.previousMonth,
              ),
              const SizedBox(height: 40),
              Text(
                'Postagens agendadas',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return AFYCard(
                      post: post,
                      onEdit: () {
                      
                      },
                      onDelete: () {
                       
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
