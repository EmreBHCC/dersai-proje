class TurkishDateFormatter {
  TurkishDateFormatter._();

  static const List<String> _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  static const List<String> _weekdays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  static const List<String> _weekdaysShort = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  static String monthName(DateTime date) => _months[date.month - 1];

  static String weekdayShort(DateTime date) => _weekdaysShort[date.weekday - 1];

  static String fullDate(DateTime date) =>
      '${date.day} ${monthName(date)} ${date.year}, ${_weekdays[date.weekday - 1]}';
}
