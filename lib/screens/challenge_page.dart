import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';

class ChallengePage extends StatefulWidget {
  final int challengeId;
  const ChallengePage({super.key, required this.challengeId});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  late final _challenge = MockDataService().getChallengeById(widget.challengeId);

  @override
  Widget build(BuildContext context) {
    if (_challenge == null) {
      return Scaffold(body: Center(child: Text('Défi introuvable', style: TextStyle(color: Colors.white))));
    }
    final c = _challenge;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: CachedNetworkImage(imageUrl: c.imageUrl, fit: BoxFit.cover),
                ),
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(gradient: AppColors.heroOverlay),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20, left: 20, right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('DÉFI ${c.totalDays} JOURS', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      Text(c.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Progression', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('${c.progressPercentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: c.progressPercentage / 100,
                        backgroundColor: AppColors.borderSubtle,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${c.completedDays} complétés', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Text('${c.remainingDays} restants', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Calendar Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text('Calendrier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(c.totalDays, (i) {
                  final isCompleted = i < c.completedDays;
                  final isCurrent = i == c.completedDays;
                  return Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCompleted ? AppColors.primary : (isCurrent ? AppColors.primary.withValues(alpha: 0.5) : AppColors.borderSubtle.withValues(alpha: 0.3)),
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check_rounded, size: 20, color: AppColors.primary)
                          : Text('${i + 1}', style: TextStyle(fontSize: 14, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal, color: isCurrent ? AppColors.primary : AppColors.textMuted)),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 28),

            // Today's Task
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withValues(alpha: 0.15), AppColors.surfaceDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.today_rounded, size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text("Tâche d'aujourd'hui", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(c.todayTask, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (c.completedDays < c.totalDays) {
                              c.completedDays++;
                              if (c.dayCompletionStatus.length > c.completedDays - 1) {
                                c.dayCompletionStatus[c.completedDays - 1] = true;
                              }
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 8,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        child: const Text('Commencer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
