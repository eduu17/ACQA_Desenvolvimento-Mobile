import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../helpers/date_formatters.dart';
import '../theme/app_theme.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/acqa_calendar.dart';
import '../widgets/glass_surface.dart';
import '../widgets/task_list.dart';
import '../widgets/vibrant_backdrop.dart';
import 'auth_screen.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key, required this.userName});

  final String userName;

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final TaskController _taskController = TaskController();
  var _selectedDate = dateOnly(DateTime.now());
  var _tabIndex = 0;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _taskController,
      builder: (context, _) {
        final palette = context.palette;

        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(
              'Ola, ${widget.userName}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _LogoutButton(onPressed: _logout),
              ),
            ],
          ),
          body: Stack(
            children: [
              const Positioned.fill(child: VibrantBackdrop()),
              IndexedStack(
                index: _tabIndex,
                children: [
                  CalendarPage(
                    controller: _taskController,
                    selectedDate: _selectedDate,
                    onDateSelected: _selectDate,
                    onOpenTasks: () => setState(() => _tabIndex = 1),
                  ),
                  TasksPage(
                    controller: _taskController,
                    selectedDate: _selectedDate,
                    onDateChanged: _selectDate,
                    onAddTask: _openAddTaskDialog,
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: _tabIndex == 0 ? AppColors.coral : AppColors.blue,
            foregroundColor: Colors.white,
            onPressed: _tabIndex == 0
                ? () => setState(() => _tabIndex = 1)
                : _openAddTaskDialog,
            icon: Icon(_tabIndex == 0 ? Icons.list_alt : Icons.add),
            label: Text(_tabIndex == 0 ? 'Ver tarefas' : 'Nova tarefa'),
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _PlannerTabBar(
              selectedIndex: _tabIndex,
              onSelected: (value) {
                setState(() => _tabIndex = value);
              },
              backgroundColor: palette.bottomGlass,
            ),
          ),
        );
      },
    );
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = dateOnly(date));
  }

  Future<void> _openAddTaskDialog() async {
    final title = await showAddTaskDialog(context, _selectedDate);

    if (title == null) {
      return;
    }

    _taskController.addTask(_selectedDate, title);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa adicionada como pendente.')),
    );
  }

  void _logout() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: 'Sair',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.coral.withAlpha(isDark ? 82 : 42),
                  AppColors.violet.withAlpha(isDark ? 54 : 28),
                ],
              ),
              border: Border.all(
                color: AppColors.coral.withAlpha(isDark ? 124 : 74),
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.coral.withAlpha(isDark ? 36 : 28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(11),
              child: Icon(Icons.close_rounded, size: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlannerTabBar extends StatelessWidget {
  const _PlannerTabBar({
    required this.selectedIndex,
    required this.onSelected,
    required this.backgroundColor,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: 30,
      blur: 30,
      padding: const EdgeInsets.all(6),
      color: backgroundColor,
      child: Row(
        children: [
          Expanded(
            child: _PlannerTabButton(
              label: 'Calendario',
              icon: Icons.calendar_month_outlined,
              selectedIcon: Icons.calendar_month_rounded,
              selected: selectedIndex == 0,
              color: AppColors.blue,
              onTap: () => onSelected(0),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _PlannerTabButton(
              label: 'Tarefas',
              icon: Icons.check_circle_outline_rounded,
              selectedIcon: Icons.check_circle_rounded,
              selected: selectedIndex == 1,
              color: AppColors.mint,
              onTap: () => onSelected(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlannerTabButton extends StatelessWidget {
  const _PlannerTabButton({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = selected ? Colors.white : palette.subtext;

    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        selectedIndexTint(color, isDark),
                      ],
                    )
                  : null,
              color: selected ? null : Colors.transparent,
              border: Border.all(
                color: selected
                    ? Colors.white.withAlpha(isDark ? 34 : 64)
                    : palette.stroke,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: color.withAlpha(isDark ? 58 : 52),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(selected ? selectedIcon : icon,
                    size: 21, color: textColor),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color selectedIndexTint(Color color, bool isDark) {
    if (color == AppColors.mint) {
      return isDark ? AppColors.blue : const Color(0xFF12B886);
    }

    return isDark ? AppColors.violet : AppColors.sky;
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onOpenTasks,
  });

  final TaskController controller;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onOpenTasks;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    _visibleMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  @override
  void didUpdateWidget(covariant CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDate.month != widget.selectedDate.month ||
        oldWidget.selectedDate.year != widget.selectedDate.year) {
      _visibleMonth = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthTaskCount = widget.controller.taskCountForMonth(_visibleMonth);
    final selectedPending = widget.controller.pendingCountFor(
      widget.selectedDate,
    );
    final palette = context.palette;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CalendarHeader(
            visibleMonth: _visibleMonth,
            monthTaskCount: monthTaskCount,
            onPrevious: () => _changeMonth(-1),
            onNext: () => _changeMonth(1),
            onToday: () {
              final today = dateOnly(DateTime.now());
              widget.onDateSelected(today);
              setState(() => _visibleMonth = DateTime(today.year, today.month));
            },
          ),
          const SizedBox(height: 18),
          AcqaCalendar(
            visibleMonth: _visibleMonth,
            selectedDate: widget.selectedDate,
            tasksForDate: widget.controller.tasksFor,
            onDateSelected: widget.onDateSelected,
          ),
          const SizedBox(height: 18),
          GlassSurface(
            radius: 28,
            padding: const EdgeInsets.all(18),
            color: palette.glassStrong,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatLongDate(widget.selectedDate),
                        style: TextStyle(
                          color: palette.text,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$selectedPending pendente(s) nesse dia',
                        style: TextStyle(
                          color: palette.subtext,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filled(
                  tooltip: 'Abrir tarefas do dia',
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: widget.onOpenTasks,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.visibleMonth,
    required this.monthTaskCount,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime visibleMonth;
  final int monthTaskCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassSurface(
      radius: 30,
      padding: const EdgeInsets.all(18),
      color: palette.glassStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formatMonthYear(visibleMonth).toUpperCase(),
                  style: TextStyle(
                    color: palette.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
              _MonthStepper(
                onPrevious: onPrevious,
                onNext: onNext,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _StatPill(
                icon: Icons.event_available_rounded,
                label: '$monthTaskCount tarefa(s)',
                color: AppColors.blue,
              ),
              OutlinedButton.icon(
                onPressed: onToday,
                icon: const Icon(Icons.today_rounded),
                label: const Text('Hoje'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? color.withAlpha(58) : color.withAlpha(214),
        border: Border.all(color: color.withAlpha(isDark ? 112 : 60)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isDark ? Colors.white : Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthStepper extends StatelessWidget {
  const _MonthStepper({
    required this.onPrevious,
    required this.onNext,
  });

  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blue.withAlpha(isDark ? 58 : 36),
            AppColors.violet.withAlpha(isDark ? 48 : 24),
          ],
        ),
        border: Border.all(color: palette.stroke),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withAlpha(isDark ? 28 : 22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MonthStepButton(
              tooltip: 'Mes anterior',
              icon: Icons.arrow_back_rounded,
              onPressed: onPrevious,
            ),
            Container(width: 1, height: 28, color: palette.stroke),
            _MonthStepButton(
              tooltip: 'Proximo mes',
              icon: Icons.arrow_forward_rounded,
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthStepButton extends StatelessWidget {
  const _MonthStepButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 46,
            height: 42,
            child: Icon(icon, color: palette.text, size: 20),
          ),
        ),
      ),
    );
  }
}

class TasksPage extends StatelessWidget {
  const TasksPage({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onAddTask,
  });

  final TaskController controller;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    final tasks = controller.tasksFor(selectedDate);
    final pendingCount = controller.pendingCountFor(selectedDate);
    final completedCount = controller.completedCountFor(selectedDate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TasksHeader(
            selectedDate: selectedDate,
            pendingCount: pendingCount,
            completedCount: completedCount,
            onPreviousDay: () {
              onDateChanged(selectedDate.subtract(const Duration(days: 1)));
            },
            onNextDay: () {
              onDateChanged(selectedDate.add(const Duration(days: 1)));
            },
            onAddTask: onAddTask,
          ),
          const SizedBox(height: 18),
          Expanded(
            child: TaskList(
              tasks: tasks,
              onToggle: (task) => controller.toggleTask(task.id),
              onRemove: (task) => controller.removeTask(task.id),
            ),
          ),
        ],
      ),
    );
  }
}

class _TasksHeader extends StatelessWidget {
  const _TasksHeader({
    required this.selectedDate,
    required this.pendingCount,
    required this.completedCount,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onAddTask,
  });

  final DateTime selectedDate;
  final int pendingCount;
  final int completedCount;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassSurface(
      radius: 30,
      padding: const EdgeInsets.all(18),
      color: palette.glassStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Dia anterior',
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: onPreviousDay,
              ),
              Expanded(
                child: Text(
                  formatLongDate(selectedDate),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: palette.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Proximo dia',
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: onNextDay,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatPill(
                icon: Icons.radio_button_unchecked_rounded,
                label: '$pendingCount pendente(s)',
                color: AppColors.coral,
              ),
              _StatPill(
                icon: Icons.task_alt_rounded,
                label: '$completedCount concluida(s)',
                color: AppColors.blue,
              ),
              OutlinedButton.icon(
                onPressed: onAddTask,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Adicionar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
