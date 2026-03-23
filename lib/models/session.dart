import 'coach.dart';

class Session {
  final int id;
  final String title;
  final String category;
  final DateTime date;
  final Duration time;
  final String imageUrl;
  final Coach? coach;

  String get dateTimeDisplay {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final h = time.inHours.toString().padLeft(2, '0');
    final m = (time.inMinutes % 60).toString().padLeft(2, '0');
    if (isToday) {
      return "Aujourd'hui, ${h}h$m";
    }
    final months = [
      '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return '${date.day} ${months[date.month]}, ${h}h$m';
  }

  const Session({
    required this.id,
    required this.title,
    this.category = '',
    required this.date,
    required this.time,
    this.imageUrl = '',
    this.coach,
  });
}
