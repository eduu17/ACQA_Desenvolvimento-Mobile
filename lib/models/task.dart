class Task {
  const Task({
    required this.id,
    required this.title,
    required this.date,
    this.completed = false,
  });

  final String id;
  final String title;
  final DateTime date;
  final bool completed;

  Task copyWith({String? id, String? title, DateTime? date, bool? completed}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      completed: completed ?? this.completed,
    );
  }
}
