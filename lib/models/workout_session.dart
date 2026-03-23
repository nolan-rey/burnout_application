import 'coach.dart';

class WorkoutSet {
  final int setNumber;
  int? reps;
  double? weight;
  double? duration;

  WorkoutSet({
    required this.setNumber,
    this.reps,
    this.weight,
    this.duration,
  });
}

class WorkoutExercise {
  final int id;
  final String name;
  final int seriesCount;
  final int repsPerSerie;
  final int recupSeconds;
  final String note;
  final List<WorkoutSet> sets;

  String get displaySeries => repsPerSerie > 1
      ? '$seriesCount x $repsPerSerie reps'
      : '$seriesCount serie(s)';

  String get displayRecup =>
      recupSeconds > 0 ? 'Recup : ${recupSeconds}s' : '';

  const WorkoutExercise({
    required this.id,
    required this.name,
    this.seriesCount = 0,
    this.repsPerSerie = 0,
    this.recupSeconds = 0,
    this.note = '',
    this.sets = const [],
  });
}

class WorkoutBlock {
  final String name;
  final List<WorkoutExercise> exercises;

  const WorkoutBlock({
    required this.name,
    this.exercises = const [],
  });
}

class WorkoutSession {
  final int id;
  final String title;
  final String programName;
  final String weekLabel;
  final String sessionLabel;
  final String type;
  final DateTime date;
  final Duration time;
  final Coach? coach;
  final List<WorkoutBlock> blocks;

  const WorkoutSession({
    required this.id,
    required this.title,
    this.programName = '',
    this.weekLabel = '',
    this.sessionLabel = '',
    this.type = '',
    required this.date,
    required this.time,
    this.coach,
    this.blocks = const [],
  });
}
