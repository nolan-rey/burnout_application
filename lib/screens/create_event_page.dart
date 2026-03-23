import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  DateTime _eventDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _eventTime = const TimeOfDay(hour: 10, minute: 0);
  String _selectedTheme = 'Yoga';

  final List<String> _themes = ['Yoga', 'Cardio', 'Force', 'Crossfit', 'Nutrition', 'Bien-être'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Créer un Événement', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('NOUVELLE SESSION', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildField(
                    label: "Nom de l'événement",
                    icon: Icons.edit_rounded,
                    child: TextField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Ex: Yoga Morning Flow'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date & Time
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: 'Date',
                          icon: Icons.calendar_today_rounded,
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _eventDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                                builder: (ctx, child) => Theme(
                                  data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary)),
                                  child: child!,
                                ),
                              );
                              if (picked != null) setState(() => _eventDate = picked);
                            },
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: _boxDecoration(),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.textMuted.withValues(alpha: 0.5)),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${_eventDate.day.toString().padLeft(2, '0')}/${_eventDate.month.toString().padLeft(2, '0')}/${_eventDate.year}',
                                    style: const TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildField(
                          label: 'Heure',
                          icon: Icons.access_time_rounded,
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: _eventTime,
                                builder: (ctx, child) => Theme(
                                  data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary)),
                                  child: child!,
                                ),
                              );
                              if (picked != null) setState(() => _eventTime = picked);
                            },
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: _boxDecoration(),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time_rounded, size: 18, color: AppColors.textMuted.withValues(alpha: 0.5)),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${_eventTime.hour.toString().padLeft(2, '0')}:${_eventTime.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildField(
                    label: 'Lieu',
                    icon: Icons.location_on_rounded,
                    child: TextField(
                      controller: _locationCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Ex: Salle A, Annecy'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Theme & Price
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: 'Thème',
                          icon: Icons.label_rounded,
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: _boxDecoration(),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedTheme,
                                isExpanded: true,
                                dropdownColor: AppColors.surfaceDark,
                                style: const TextStyle(color: Colors.white),
                                icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
                                items: _themes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                                onChanged: (v) => setState(() => _selectedTheme = v!),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildField(
                          label: 'Prix',
                          icon: Icons.euro_rounded,
                          child: TextField(
                            controller: _priceCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('Gratuit ou montant'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildField(
                    label: 'Description',
                    icon: Icons.description_rounded,
                    child: Container(
                      decoration: _boxDecoration(),
                      child: TextField(
                        controller: _descriptionCtrl,
                        maxLines: 4,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Détails de la séance, matériel nécessaire...',
                          hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image upload placeholder
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle, width: 2, strokeAlign: BorderSide.strokeAlignInside),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.borderSubtle.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.image_rounded, color: AppColors.textMuted, size: 20),
                          ),
                          const SizedBox(height: 8),
                          const Text('Ajouter une image de couverture', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            color: AppColors.backgroundDark,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Événement publié !')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 12,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_rounded, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Publier l'événement", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({required String label, required IconData icon, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: AppColors.surfaceDark,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      filled: true,
      fillColor: AppColors.surfaceDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
