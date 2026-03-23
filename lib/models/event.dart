import 'package:intl/intl.dart';
import 'coach.dart';

class Event {
  final int id;
  final String title;
  final String category;
  final String description;
  final DateTime date;
  final Duration startTime;
  final Duration endTime;
  final String location;
  final String locationDetail;
  final String imageUrl;
  final double price;
  bool get isFree => price == 0;
  String get priceDisplay => isFree ? 'Gratuit' : '${price.toStringAsFixed(0)}€';
  final int maxParticipants;
  int currentParticipants;
  int get remainingSpots => maxParticipants - currentParticipants;
  String get participantsDisplay => '+$currentParticipants participants';
  final List<String> participantAvatars;
  final Coach? coach;
  final String intensity;
  final String level;

  String get dateDisplay => DateFormat('dd MMM', 'fr_FR').format(date);
  String get timeDisplay {
    final h = startTime.inHours.toString().padLeft(2, '0');
    final m = (startTime.inMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get fullDateTimeDisplay {
    final dayName = DateFormat('EEEE', 'fr_FR').format(date);
    final dayMonth = DateFormat('dd MMM', 'fr_FR').format(date);
    final startH = startTime.inHours.toString().padLeft(2, '0');
    final startM = (startTime.inMinutes % 60).toString().padLeft(2, '0');
    final endH = endTime.inHours.toString().padLeft(2, '0');
    final endM = (endTime.inMinutes % 60).toString().padLeft(2, '0');
    return '$dayName $dayMonth • $startH:$startM - $endH:$endM';
  }

  Event({
    required this.id,
    required this.title,
    this.category = '',
    this.description = '',
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    this.locationDetail = '',
    this.imageUrl = '',
    this.price = 0,
    this.maxParticipants = 0,
    this.currentParticipants = 0,
    List<String>? participantAvatars,
    this.coach,
    this.intensity = '',
    this.level = '',
  }) : participantAvatars = participantAvatars ?? [];
}
