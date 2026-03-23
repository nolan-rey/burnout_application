class Challenge {
  final int id;
  final String title;
  final String imageUrl;
  final int totalDays;
  int completedDays;
  int get remainingDays => totalDays - completedDays;
  double get progressPercentage => (completedDays / totalDays) * 100;
  String get progressDisplay => 'Jours $completedDays/$totalDays';
  bool isJoined;
  final String todayTask;
  final String iconName;
  List<bool> dayCompletionStatus;

  Challenge({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.totalDays,
    this.completedDays = 0,
    this.isJoined = false,
    this.todayTask = '',
    this.iconName = '',
    List<bool>? dayCompletionStatus,
  }) : dayCompletionStatus = dayCompletionStatus ?? [];
}
