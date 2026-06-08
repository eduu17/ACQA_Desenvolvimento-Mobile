import 'package:flutter/material.dart';

import '../helpers/date_formatters.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

class AcqaCalendar extends StatelessWidget {
  const AcqaCalendar({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.tasksForDate,
    required this.onDateSelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final List<Task> Function(DateTime date) tasksForDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
    final daysInMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;
    final leadingEmptyCells = firstDay.weekday - 1;
    final cellCount = ((leadingEmptyCells + daysInMonth + 6) ~/ 7) * 7;

    return GlassSurface(
      radius: 30,
      padding: const EdgeInsets.all(12),
      color: palette.glass,
      child: Column(
        children: [
          Row(
            children: compactWeekdayNames.map((dayName) {
              return Expanded(
                child: Center(
                  child: Text(
                    dayName,
                    style: TextStyle(
                      color: palette.subtext,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cellCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - leadingEmptyCells + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                visibleMonth.year,
                visibleMonth.month,
                dayNumber,
              );
              final tasks = tasksForDate(date);

              return _CalendarDayCell(
                date: date,
                taskCount: tasks.length,
                pendingCount: tasks.where((task) => !task.completed).length,
                isSelected: isSameDay(date, selectedDate),
                isToday: isSameDay(date, DateTime.now()),
                onTap: () => onDateSelected(date),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.taskCount,
    required this.pendingCount,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final int taskCount;
  final int pendingCount;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final background = isSelected ? palette.selectedCell : palette.cell;
    final foreground = isSelected
        ? Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF111827)
            : Colors.white
        : palette.text;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: isToday ? AppColors.coral : palette.stroke,
              width: isToday ? 1.8 : 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (taskCount > 0)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: _TaskCountBadge(
                      taskCount: taskCount,
                      pendingCount: pendingCount,
                      selected: isSelected,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCountBadge extends StatelessWidget {
  const _TaskCountBadge({
    required this.taskCount,
    required this.pendingCount,
    required this.selected,
  });

  final int taskCount;
  final int pendingCount;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final badgeColor = pendingCount == 0 ? AppColors.blue : AppColors.coral;

    return Tooltip(
      message: '$taskCount tarefa(s), $pendingCount pendente(s)',
      child: Container(
        constraints: const BoxConstraints(minWidth: 22, minHeight: 20),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : badgeColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$taskCount',
            style: TextStyle(
              color: selected ? palette.text : Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
