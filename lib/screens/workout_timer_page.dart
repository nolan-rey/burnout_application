import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/workout_session.dart';
import 'workout_rpe_page.dart';

class WorkoutTimerPage extends StatefulWidget {
  final WorkoutSession session;
  const WorkoutTimerPage({super.key, required this.session});

  @override
  State<WorkoutTimerPage> createState() => _WorkoutTimerPageState();
}

class _WorkoutTimerPageState extends State<WorkoutTimerPage> {
  int _currentBlockIndex = 0;
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  bool _isRecovery = false;
  int _timerSeconds = 0;
  int _totalElapsed = 0;
  Timer? _timer;
  int _recoveryRemaining = 0;

  List<WorkoutExercise> get _allExercises {
    return widget.session.blocks.expand((b) => b.exercises).toList();
  }

  WorkoutExercise get _currentExercise => _allExercises[_flatExerciseIndex];

  int get _flatExerciseIndex {
    int idx = 0;
    for (int b = 0; b < _currentBlockIndex && b < widget.session.blocks.length; b++) {
      idx += widget.session.blocks[b].exercises.length;
    }
    return (idx + _currentExerciseIndex).clamp(0, _allExercises.length - 1);
  }

  String get _currentBlockName {
    if (_currentBlockIndex < widget.session.blocks.length) {
      return widget.session.blocks[_currentBlockIndex].name;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timerSeconds++;
        _totalElapsed++;
        if (_isRecovery && _recoveryRemaining > 0) {
          _recoveryRemaining--;
          if (_recoveryRemaining == 0) {
            _isRecovery = false;
          }
        }
      });
    });
  }

  void _nextSet() {
    final ex = _currentExercise;
    if (_currentSetIndex < ex.sets.length - 1) {
      setState(() {
        _currentSetIndex++;
        _timerSeconds = 0;
        if (ex.recupSeconds > 0) {
          _isRecovery = true;
          _recoveryRemaining = ex.recupSeconds;
        }
      });
    } else {
      _nextExercise();
    }
  }

  void _nextExercise() {
    final block = widget.session.blocks[_currentBlockIndex];
    if (_currentExerciseIndex < block.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSetIndex = 0;
        _timerSeconds = 0;
        _isRecovery = false;
      });
    } else {
      _nextBlock();
    }
  }

  void _nextBlock() {
    if (_currentBlockIndex < widget.session.blocks.length - 1) {
      setState(() {
        _currentBlockIndex++;
        _currentExerciseIndex = 0;
        _currentSetIndex = 0;
        _timerSeconds = 0;
        _isRecovery = false;
      });
    } else {
      _finishWorkout();
    }
  }

  void _skip() {
    _nextExercise();
  }

  void _finishWorkout() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutRpePage(
          sessionTitle: widget.session.title,
          totalTime: _totalElapsed,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final ex = _currentExercise;
    final currentSet = ex.sets.isNotEmpty && _currentSetIndex < ex.sets.length
        ? ex.sets[_currentSetIndex]
        : null;
    final progress = '${_flatExerciseIndex + 1} / ${_allExercises.length}';

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 10, 16, 8),
            color: AppColors.backgroundDark,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _timer?.cancel();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                  ),
                ),
                Expanded(
                  child: Text(progress, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
                ),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(_formatTime(_totalElapsed), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Exercise card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(_currentBlockName, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(height: 8),
                        Text(ex.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 24),

                        // Timer circle
                        SizedBox(
                          width: 200, height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 200, height: 200,
                                child: CircularProgressIndicator(
                                  value: _isRecovery && _currentExercise.recupSeconds > 0
                                      ? _recoveryRemaining / _currentExercise.recupSeconds
                                      : 1.0,
                                  strokeWidth: 14,
                                  backgroundColor: AppColors.borderSubtle,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _isRecovery ? AppColors.warning : AppColors.primary,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Série ${_currentSetIndex + 1}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _isRecovery ? _formatTime(_recoveryRemaining) : _formatTime(_timerSeconds),
                                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Stats
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.cardDark,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Text('Reps', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentSet?.reps?.toString() ?? '${ex.repsPerSerie}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.cardDark,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Text('Charge', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentSet?.weight != null ? '${currentSet!.weight}kg' : '—',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (ex.note.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(ex.note, style: TextStyle(fontSize: 12, color: AppColors.primary.withValues(alpha: 0.7)), textAlign: TextAlign.center),
                        ],
                      ],
                    ),
                  ),

                  // Recovery banner
                  if (_isRecovery) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text('Récupération', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const SizedBox(height: 8),
                          Text(_formatTime(_recoveryRemaining), style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          const Text('Préparez-vous pour la série suivante', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
            color: AppColors.navDark,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _skip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardDark,
                        foregroundColor: AppColors.textSecondary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                        elevation: 0,
                      ),
                      child: const Text('Passer', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _nextSet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                      ),
                      child: const Text('Série suivante', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
