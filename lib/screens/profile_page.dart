import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';
import 'imc_calculator_page.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockDataService().currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    const Text('Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.settings_rounded, color: AppColors.textSecondary, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: AppColors.primary, width: 3),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: CachedNetworkImage(imageUrl: user.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.backgroundDark, width: 3),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(user.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  user.membershipLevel.toUpperCase(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1),
                ),
              ),
              const SizedBox(height: 4),
              Text('Membre depuis ${user.memberSince}', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.4))),
              const SizedBox(height: 28),

              // Personal Info
              _buildSection(
                icon: Icons.person_rounded,
                title: 'Informations Personnelles',
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('EMAIL', user.email, locked: true),
                      Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                      _buildInfoRow('TÉLÉPHONE', user.phone, action: 'Modifier'),
                      Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                      _buildInfoRow('ADRESSE', user.address),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sports Data
              _buildSection(
                icon: Icons.fitness_center_rounded,
                title: 'Données Sportives',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildStatBox('ÂGE', '${user.age}', 'ans')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatBox('GENRE', user.gender, '')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildStatBox('GROUPE SANGUIN', user.bloodType, '', highlight: true)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ImcCalculatorPage())),
                            child: _buildStatBox('OUTILS', 'Calculateur IMC', '', isLink: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DISCIPLINE FAVORITE', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4), letterSpacing: 1)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text('🤸', style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.5))),
                              const SizedBox(width: 8),
                              Text(user.favoriteSport, style: const TextStyle(fontSize: 17, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save_rounded, size: 20),
                    label: const Text('Enregistrer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 16, color: Colors.white.withValues(alpha: 0.3)),
                    const SizedBox(width: 8),
                    Text('Déconnexion', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.3))),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.9))),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool locked = false, String? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4), letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, color: Colors.white)),
              ],
            ),
          ),
          if (locked) Icon(Icons.lock_rounded, size: 16, color: Colors.white.withValues(alpha: 0.2)),
          if (action != null) Text(action, style: const TextStyle(fontSize: 13, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, String unit, {bool highlight = false, bool isLink = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: highlight ? AppColors.primary.withValues(alpha: 0.3) : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4), letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isLink ? 14 : 22,
                    fontWeight: FontWeight.bold,
                    color: highlight ? AppColors.primary : Colors.white,
                  ),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(unit, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.4))),
                ),
              ],
              if (isLink) Text(' ›', style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.2))),
            ],
          ),
        ],
      ),
    );
  }
}
