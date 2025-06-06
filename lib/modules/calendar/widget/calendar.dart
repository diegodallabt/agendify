import 'package:flutter/material.dart';
import '../../../core/utils/calendar_utils.dart';
import '../../schedule/model/post_model.dart';

class AFYCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime focusedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final List<PostModel> allPosts;

  const AFYCalendar({
    super.key,
    required this.selectedDate,
    required this.focusedMonth,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.allPosts,
  });

  @override
  Widget build(BuildContext context) {
    final days = CalendarUtils.generateDaysForMonth(focusedMonth);
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodySmall?.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onPreviousMonth,
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              '${CalendarUtils.monthName(focusedMonth.month)} ${focusedMonth.year}',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: onNextMonth,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom']
                    .map((day) => Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color:
                                    theme.colorScheme.onSecondaryFixedVariant,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 26),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: days.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  final DateTime? day = days[index];
                  if (day == null) return const SizedBox.shrink();
    
                  final isSelected =
                      DateUtils.dateOnly(day) == DateUtils.dateOnly(selectedDate);
                  final hasPost =
                      CalendarUtils.hasPostForDate(day, allPosts);
    
                  return GestureDetector(
                    onTap: () => onDateSelected(day),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (hasPost) const SizedBox(height: 2),
                        if (hasPost)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
