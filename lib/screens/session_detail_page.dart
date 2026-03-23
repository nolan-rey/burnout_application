import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';
import '../models/workout_session.dart';
import 'workout_timer_page.dart';

class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = MockDataService().getTodayWorkoutSession();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 10, 16, 16),
                    color: AppColors.backgroundDark,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        const Expanded(
                          child: Text('Séance', textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // Session info card
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session.programName, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(height: 4),
                        Text(session.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildBadge(session.type),
                            const SizedBox(width: 8),
                            _buildBadge(session.weekLabel),
                            const SizedBox(width: 8),
                            _buildBadge(session.sessionLabel),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Divider(color: AppColors.borderSubtle.withValues(alpha: 0.5), height: 1),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('HEURE', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${session.time.inHours}h${(session.time.inMinutes % 60).toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('COACH', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                  const SizedBox(height: 4),
                                  Text(
                                    session.coach?.name ?? '-',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Exercises
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text('Exercices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),

                  ...session.blocks.map((block) => _buildBlockCard(block)),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            color: AppColors.navDark,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WorkoutTimerPage(session: session)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 8,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                ),
                child: const Text('Lancer la séance', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }

  Widget _buildBlockCard(WorkoutBlock block) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(block.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          ...block.exercises.map((ex) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ex.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(ex.displaySeries, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    if (ex.displayRecup.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Text(ex.displayRecup, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                    ],
                  ],
                ),
                if (ex.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(ex.note, style: TextStyle(fontSize: 12, color: AppColors.primary.withValues(alpha: 0.7), fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          )),
        ],
      ),
    );
  }
}
