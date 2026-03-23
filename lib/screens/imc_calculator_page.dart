import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ImcCalculatorPage extends StatefulWidget {
  const ImcCalculatorPage({super.key});

  @override
  State<ImcCalculatorPage> createState() => _ImcCalculatorPageState();
}

class _ImcCalculatorPageState extends State<ImcCalculatorPage> {
  bool _isMale = true;
  double _height = 175;
  double _weight = 70;
  double _age = 25;

  double get _imc => _weight / ((_height / 100) * (_height / 100));

  String get _imcStatus {
    if (_imc < 18.5) return 'Insuffisant';
    if (_imc < 25) return 'Normal';
    if (_imc < 30) return 'Surpoids';
    return 'Obésité';
  }

  Color get _imcStatusColor {
    if (_imc < 18.5) return AppColors.info;
    if (_imc < 25) return AppColors.success;
    if (_imc < 30) return AppColors.warning;
    return AppColors.error;
  }

  double get _indicatorPosition {
    final clamped = _imc.clamp(15.0, 40.0);
    return (clamped - 15) / (40 - 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  const Expanded(
                    child: Text('CALCULATEUR IMC', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gender
                    const Text('Genre', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isMale = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _isMale ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _isMale ? AppColors.primary : AppColors.borderSubtle, width: 2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('♂', style: TextStyle(fontSize: 18, color: _isMale ? Colors.white : AppColors.textSecondary)),
                                  const SizedBox(width: 8),
                                  Text('Homme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _isMale ? Colors.white : AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isMale = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: !_isMale ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: !_isMale ? AppColors.primary : AppColors.borderSubtle, width: 2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('♀', style: TextStyle(fontSize: 18, color: !_isMale ? Colors.white : AppColors.textSecondary)),
                                  const SizedBox(width: 8),
                                  Text('Femme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: !_isMale ? Colors.white : AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Height
                    _buildSliderCard('Hauteur', _height, 'cm', 100, 220, (v) => setState(() => _height = v)),
                    const SizedBox(height: 16),
                    // Weight
                    _buildSliderCard('Poids', _weight, 'kg', 30, 200, (v) => setState(() => _weight = v)),
                    const SizedBox(height: 16),
                    // Age
                    _buildSliderCard('Âge', _age, 'ans', 10, 100, (v) => setState(() => _age = v)),
                    const SizedBox(height: 24),

                    // IMC Result
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text('VOTRE IMC', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          Text(_imc.toStringAsFixed(1), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(_imcStatus, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _imcStatusColor)),
                          const SizedBox(height: 16),

                          // Scale
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Row(
                              children: [
                                Expanded(child: Container(height: 8, color: AppColors.info)),
                                Expanded(child: Container(height: 8, color: AppColors.success)),
                                Expanded(child: Container(height: 8, color: AppColors.warning)),
                                Expanded(child: Container(height: 8, color: AppColors.error)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final left = _indicatorPosition * constraints.maxWidth;
                              return SizedBox(
                                height: 16,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: left.clamp(0, constraints.maxWidth - 12),
                                      child: Container(
                                        width: 12, height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard(String label, double value, String unit, double min, double max, ValueChanged<double> onChanged) {
    return Container(
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
              Text(label, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${value.round()}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(unit, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.borderSubtle,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.1),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
