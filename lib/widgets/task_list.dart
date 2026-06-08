import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onRemove,
  });

  final List<Task> tasks;
  final ValueChanged<Task> onToggle;
  final ValueChanged<Task> onRemove;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const _EmptyTasks();
    }

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return _TaskTile(
          task: task,
          onToggle: () => onToggle(task),
          onRemove: () => onRemove(task),
        );
      },
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onRemove,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final statusColor = task.completed ? AppColors.blue : AppColors.coral;
    final surfaceColor =
        task.completed ? palette.successSoft : palette.glassStrong;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.coral,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 18),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      onDismissed: (_) => onRemove(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border.all(color: palette.stroke, width: 1.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              Checkbox(
                value: task.completed,
                activeColor: AppColors.blue,
                onChanged: (_) => onToggle(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: palette.text,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _StatusLabel(
                      label: task.completed ? 'Concluida' : 'Pendente',
                      color: statusColor,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remover tarefa',
                icon: const Icon(Icons.delete_outline),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: GlassSurface(
        radius: 30,
        padding: const EdgeInsets.all(24),
        color: palette.glassStrong,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.playlist_add_check,
              size: 46,
              color: AppColors.coral,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhuma tarefa para este dia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.text,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Use o botao Nova tarefa para cadastrar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.subtext),
            ),
          ],
        ),
      ),
    );
  }
}
