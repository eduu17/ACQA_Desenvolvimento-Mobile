import 'package:flutter/material.dart';

import '../helpers/date_formatters.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

Future<String?> showAddTaskDialog(BuildContext context, DateTime selectedDate) {
  return showDialog<String>(
    context: context,
    builder: (_) => AddTaskDialog(selectedDate: selectedDate),
  );
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GlassSurface(
        radius: 32,
        padding: const EdgeInsets.all(22),
        color: palette.glassStrong,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nova tarefa',
                style: TextStyle(
                  color: palette.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                formatLongDate(widget.selectedDate),
                style: TextStyle(color: palette.subtext),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _taskController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Tarefa',
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Descreva a tarefa com pelo menos 3 letras.';
                  }

                  return null;
                },
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Adicionar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(_taskController.text.trim());
  }
}
