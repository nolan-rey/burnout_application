import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user.dart';
import '../services/mock_data_service.dart';
import 'main_shell.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  final _pageController = PageController();

  // Step 1
  final _presentationCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  String _gender = 'Homme';
  DateTime _birthDate = DateTime(2000, 1, 1);
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _country = 'France';
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  // Step 2
  String _maritalStatus = 'Célibataire';
  final _partnerNameCtrl = TextEditingController();
  String _personalPhysicalFatigue = 'Modéré';
  String _personalMentalFatigue = 'Modéré';

  // Step 3
  String _tobacco = 'Non';
  String _alcohol = 'Occasionnel';
  String _drugs = 'Non';
  String _movementLimitations = 'Non';

  // Step 4
  String _sleepQuality = 'Bonne';
  String _dietQuality = 'Bonne';
  int _weeklyTraining = 3;

  final List<String> _genderOptions = ['Homme', 'Femme', 'Autre'];
  final List<String> _countryOptions = ['France', 'Belgique', 'Suisse', 'Canada', 'Autre'];
  final List<String> _maritalOptions = ['Célibataire', 'En couple', 'Marié(e)', 'Autre'];
  final List<String> _fatigueOptions = ['Faible', 'Modéré', 'Élevé', 'Très élevé'];
  final List<String> _yesNoOptions = ['Non', 'Oui', 'Occasionnel'];
  final List<String> _qualityOptions = ['Mauvaise', 'Moyenne', 'Bonne', 'Excellente'];

  static const int _totalSteps = 5;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _submit() {
    if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }
    final user = User(
      firstName: _firstNameCtrl.text,
      lastName: _lastNameCtrl.text,
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
      gender: _gender,
      birthDate: _birthDate,
      phone: _phoneCtrl.text,
      address: _addressCtrl.text,
      postalCode: _postalCodeCtrl.text,
      city: _cityCtrl.text,
      country: _country,
      presentation: _presentationCtrl.text,
      maritalStatus: _maritalStatus,
      partnerName: _partnerNameCtrl.text,
      personalPhysicalFatigue: _personalPhysicalFatigue,
      personalMentalFatigue: _personalMentalFatigue,
      sleepQuality: _sleepQuality,
      dietQuality: _dietQuality,
      weeklyTrainingCount: _weeklyTraining,
    );
    final success = MockDataService().createAccount(user);
    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la création du compte')),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _presentationCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _postalCodeCtrl.dispose();
    _cityCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _partnerNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _prevStep,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Créer un compte',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Étape ${_currentStep + 1} / $_totalSteps',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(_totalSteps, (i) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: i <= _currentStep ? AppColors.primary : AppColors.borderSubtle,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildStep4(),
                  _buildStep5(),
                ],
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentStep == _totalSteps - 1 ? 'Créer mon compte' : 'Continuer',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Informations Générales'),
          _fieldLabel('Présentation'),
          _buildTextArea(_presentationCtrl, 'Décrivez-vous...'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_fieldLabel('Prénom *'), _buildInput(_firstNameCtrl, 'Prénom')])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_fieldLabel('Nom *'), _buildInput(_lastNameCtrl, 'Nom')])),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Sexe'),
          _buildDropdown(_gender, _genderOptions, (v) => setState(() => _gender = v!)),
          const SizedBox(height: 12),
          _fieldLabel('Date de naissance'),
          _buildDatePicker(),
          _sectionTitle('Coordonnées'),
          _fieldLabel('Adresse mail *'),
          _buildInput(_emailCtrl, 'exemple@email.com', keyboard: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _fieldLabel('Téléphone'),
          _buildInput(_phoneCtrl, '06.00.00.00.00', keyboard: TextInputType.phone),
          _sectionTitle('Sécurité'),
          _fieldLabel('Mot de passe *'),
          _buildInput(_passwordCtrl, 'Mot de passe', isPassword: true),
          const SizedBox(height: 12),
          _fieldLabel('Confirmer *'),
          _buildInput(_confirmPasswordCtrl, 'Confirmer', isPassword: true),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Situation Personnelle'),
          _fieldLabel('Statut marital'),
          _buildDropdown(_maritalStatus, _maritalOptions, (v) => setState(() => _maritalStatus = v!)),
          const SizedBox(height: 12),
          _fieldLabel('Prénom partenaire (optionnel)'),
          _buildInput(_partnerNameCtrl, 'Prénom'),
          const SizedBox(height: 12),
          _fieldLabel('Fatigue personnelle'),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Physique', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 4),
                _buildDropdown(_personalPhysicalFatigue, _fatigueOptions, (v) => setState(() => _personalPhysicalFatigue = v!)),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Mentale', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 4),
                _buildDropdown(_personalMentalFatigue, _fatigueOptions, (v) => setState(() => _personalMentalFatigue = v!)),
              ])),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Adresse Postale'),
          _fieldLabel('Adresse'),
          _buildInput(_addressCtrl, 'Numéro et nom de rue'),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(width: 110, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_fieldLabel('Code Postal'), _buildInput(_postalCodeCtrl, '73190', keyboard: TextInputType.number)])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_fieldLabel('Ville'), _buildInput(_cityCtrl, 'Ville')])),
            ],
          ),
          const SizedBox(height: 12),
          _fieldLabel('Pays'),
          _buildDropdown(_country, _countryOptions, (v) => setState(() => _country = v!)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Antécédents'),
          _fieldLabel('Consommation de tabac'),
          _buildDropdown(_tobacco, _yesNoOptions, (v) => setState(() => _tobacco = v!)),
          const SizedBox(height: 12),
          _fieldLabel('Consommation d\'alcool'),
          _buildDropdown(_alcohol, _yesNoOptions, (v) => setState(() => _alcohol = v!)),
          const SizedBox(height: 12),
          _fieldLabel('Drogues'),
          _buildDropdown(_drugs, _yesNoOptions, (v) => setState(() => _drugs = v!)),
          const SizedBox(height: 12),
          _fieldLabel('Limitations de mouvement'),
          _buildDropdown(_movementLimitations, _yesNoOptions, (v) => setState(() => _movementLimitations = v!)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Qualité de Vie'),
          _fieldLabel('Qualité du sommeil'),
          _buildDropdown(_sleepQuality, _qualityOptions, (v) => setState(() => _sleepQuality = v!)),
          const SizedBox(height: 12),
          _fieldLabel('Qualité de l\'alimentation'),
          _buildDropdown(_dietQuality, _qualityOptions, (v) => setState(() => _dietQuality = v!)),
          _sectionTitle('Disponibilités'),
          _fieldLabel('Entraînements par semaine'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _weeklyTraining > 1 ? () => setState(() => _weeklyTraining--) : null,
                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Text('$_weeklyTraining', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _weeklyTraining < 7 ? () => setState(() => _weeklyTraining++) : null,
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String hint, {TextInputType? keyboard, bool isPassword = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController ctrl, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.surfaceDark,
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _birthDate,
          firstDate: DateTime(1920),
          lastDate: DateTime(2015),
          builder: (context, child) => Theme(data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.primary)), child: child!),
        );
        if (picked != null) setState(() => _birthDate = picked);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: AppColors.primary.withValues(alpha: 0.6)),
            const SizedBox(width: 12),
            Text(
              '${_birthDate.day.toString().padLeft(2, '0')}/${_birthDate.month.toString().padLeft(2, '0')}/${_birthDate.year}',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
