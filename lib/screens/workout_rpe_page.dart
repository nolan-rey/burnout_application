import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'workout_summary_page.dart';

class WorkoutRpePage extends StatefulWidget {
  final String sessionTitle;
  final int totalTime;
  const WorkoutRpePage({super.key, required this.sessionTitle, required this.totalTime});

  @override
  State<WorkoutRpePage> createState() => _WorkoutRpePageState();
}

class _WorkoutRpePageState extends State<WorkoutRpePage> {
  int _selectedRpe = 5;
  int _selectedMood = 2;

  final _rpeDescriptions = {
    1: 'Très facile',
    2: 'Facile',
    3: 'Léger',
    4: 'Assez léger',
    5: 'Effort modéré',
    6: 'Assez dur',
    7: 'Dur',
    8: 'Très dur',
    9: 'Extrême',
    10: 'Effort maximal',
  };

  final _moods = [
    {'emoji': '😩', 'label': 'Épuisé'},
    {'emoji': '😔', 'label': 'Difficile'},
    {'emoji': '😐', 'label': 'Normal'},
    {'emoji': '😁', 'label': 'Bien'},
    {'emoji': '🤩', 'label': 'Excellent'},
  ];

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Text('Séance terminée !', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text(widget.sessionTitle, style: const TextStyle(fontSize: 15, color: AppColors.textMuted)),
              const SizedBox(height: 4),
              Text(_formatTime(widget.totalTime), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 32),

              // RPE
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Effort perçu (RPE)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 2),
                              const Text('1 = très facile  |  10 = effort maximal', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        Text('$_selectedRpe', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1.4,
                      children: List.generate(10, (i) {
                        final val = i + 1;
                        final isSelected = val == _selectedRpe;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedRpe = val),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.cardDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$val',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _rpeDescriptions[_selectedRpe] ?? '',
                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Mood
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('Comment tu te sens ?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    const Text('Choisis l\'emoji qui correspond le mieux', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(5, (i) {
                        final isSelected = i == _selectedMood;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedMood = i),
                            child: Container(
                              margin: EdgeInsets.only(right: i < 4 ? 8 : 0),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.cardDark,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(_moods[i]['emoji']!, style: const TextStyle(fontSize: 28)),
                                  const SizedBox(height: 4),
                                  Text(_moods[i]['label']!, style: TextStyle(fontSize: 10, color: isSelected ? AppColors.primary : AppColors.textMuted)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutSummaryPage(
                        sessionTitle: widget.sessionTitle,
                        totalTime: widget.totalTime,
                        rpe: _selectedRpe,
                        moodIndex: _selectedMood,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 8,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  child: const Text('Valider et voir le résumé', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
