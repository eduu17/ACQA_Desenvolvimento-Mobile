const List<String> monthNames = [
  'janeiro',
  'fevereiro',
  'marco',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

const List<String> weekdayNames = [
  'segunda-feira',
  'terca-feira',
  'quarta-feira',
  'quinta-feira',
  'sexta-feira',
  'sabado',
  'domingo',
];

const List<String> compactWeekdayNames = [
  'SEG',
  'TER',
  'QUA',
  'QUI',
  'SEX',
  'SAB',
  'DOM',
];

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String formatMonthYear(DateTime date) {
  return '${monthNames[date.month - 1]} de ${date.year}';
}

String formatLongDate(DateTime date) {
  return '${weekdayNames[date.weekday - 1]}, ${date.day} de '
      '${monthNames[date.month - 1]}';
}

String formatShortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
