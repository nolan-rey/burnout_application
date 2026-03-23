import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';
import '../models/workout_session.dart';
import 'session_detail_page.dart';
import 'create_event_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _service = MockDataService();
  late DateTime _selectedDate;
  late DateTime _weekStart;
  late List<WorkoutSession> _sessions;
  final _challenge = MockDataService().challenges.first;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekStart = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    _loadSessions();
  }

  void _loadSessions() {
    _sessions = _service.getSessionsForDate(_selectedDate);
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _loadSessions();
    });
  }

  void _prevWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventPage())),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mes activités', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18),
                    ),
                  ],
                ),
              ),

              // Week selector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _prevWeek,
                      icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary, size: 28),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 76,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final day = _weekStart.add(Duration(days: index));
                            final isSelected = day.day == _selectedDate.day &&
                                day.month == _selectedDate.month &&
                                day.year == _selectedDate.year;
                            final isToday = day.day == DateTime.now().day &&
                                day.month == DateTime.now().month &&
                                day.year == DateTime.now().year;
                            final dayNames = ['LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM', 'DIM'];

                            return GestureDetector(
                              onTap: () => _selectDate(day),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 54,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  gradient: isSelected ? AppColors.primaryGradient : null,
                                  color: isSelected
                                    ? null
                                    : (isToday ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent),
                                  borderRadius: BorderRadius.circular(18),
                                  border: isToday && !isSelected
                                    ? Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5)
                                    : null,
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ] : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dayNames[index],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.white : AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                          ? Colors.white
                                          : (isToday ? AppColors.primary : AppColors.textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _nextWeek,
                      icon: const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Sessions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text('Séances du jour', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              if (_sessions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('Aucune séance ce jour', style: TextStyle(fontSize: 15, color: AppColors.textMuted))),
                )
              else
                ...(_sessions.map((s) => _buildSessionCard(s))),
              const SizedBox(height: 20),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
              ),
              const SizedBox(height: 16),

              // Challenge progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progression du défi', 
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.w700, 
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Continuez votre série !',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Days grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(_challenge.totalDays, (i) {
                    final isCompleted = i < _challenge.completedDays;
                    final isCurrent = i == _challenge.completedDays;
                    return Container(
                      width: 44, 
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: isCompleted ? AppColors.primaryGradient : null,
                        color: isCompleted 
                          ? null 
                          : AppColors.surfaceDark.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCompleted 
                            ? Colors.transparent
                            : (isCurrent ? AppColors.primary : Colors.white.withValues(alpha: 0.08)),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check_rounded, size: 20, color: Colors.white)
                            : Text(
                                '${i + 1}', 
                                style: TextStyle(
                                  fontSize: 14, 
                                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                  color: isCurrent ? AppColors.primary : AppColors.textMuted,
                                ),
                              ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Progression', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('${_challenge.progressPercentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _challenge.progressPercentage / 100,
                          backgroundColor: AppColors.borderSubtle,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${_challenge.remainingDays} jours restants', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(WorkoutSession session) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SessionDetailPage())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surfaceDark.withValues(alpha: 0.9),
              AppColors.surfaceDark.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    session.type, 
                    style: const TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.w700, 
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    session.weekLabel, 
                    style: const TextStyle(
                      fontSize: 11, 
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              session.title, 
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w700, 
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              session.programName, 
              style: TextStyle(
                fontSize: 14, 
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded, 
                    size: 18, 
                    color: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${session.time.inHours}h${(session.time.inMinutes % 60).toString().padLeft(2, '0')}', 
                    style: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600, 
                      color: Colors.white,
                    ),
                  ),
                  if (session.coach != null) ...[
                    const SizedBox(width: 16),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.person_rounded, 
                      size: 18, 
                      color: AppColors.primaryLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      session.coach!.name, 
                      style: const TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.w600, 
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
