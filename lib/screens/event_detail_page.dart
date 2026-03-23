import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';

class EventDetailPage extends StatelessWidget {
  final int eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final event = MockDataService().getEventById(eventId);
    if (event == null) {
      return Scaffold(body: Center(child: Text('Événement introuvable', style: TextStyle(color: Colors.white))));
    }
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: CachedNetworkImage(imageUrl: event.imageUrl, fit: BoxFit.cover),
                    ),
                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(gradient: AppColors.heroOverlay),
                    ),
                    // Top bar
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 16, right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _circleButton(Icons.arrow_back_rounded, () => Navigator.pop(context)),
                          _circleButton(Icons.share_rounded, () {}),
                        ],
                      ),
                    ),
                    // Title
                    Positioned(
                      bottom: 16, left: 20, right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('${event.category} & Flexibilité', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          const SizedBox(height: 10),
                          Text(event.title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Coach
                      if (event.coach != null) ...[
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 48, height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: AppColors.surfaceDark, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: CachedNetworkImage(imageUrl: event.coach!.imageUrl, fit: BoxFit.cover),
                                  ),
                                ),
                                if (event.coach!.isPro)
                                  Positioned(
                                    right: -4, bottom: -4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: AppColors.backgroundDark, width: 1),
                                      ),
                                      child: const Text('PRO', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('COACH PRINCIPAL', style: TextStyle(fontSize: 10, color: AppColors.textMuted.withValues(alpha: 0.7))),
                                  Text(event.coach!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(children: [
                                  const Text('🔥 ', style: TextStyle(fontSize: 12)),
                                  Text(event.intensity, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ]),
                                Text('Niveau ${event.level}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
                        const SizedBox(height: 20),
                      ],

                      // Date & Location
                      _buildInfoCard(Icons.calendar_today_rounded, 'DATE & HEURE', event.fullDateTimeDisplay),
                      const SizedBox(height: 12),
                      _buildInfoCard(Icons.location_on_rounded, 'LIEU', event.locationDetail),
                      const SizedBox(height: 24),

                      // Description
                      const Text('À propos du cours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(event.description, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
                      const SizedBox(height: 24),

                      // Participants
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Participants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
                            ),
                            child: Text('${event.currentParticipants} / ${event.maxParticipants} places', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (event.participantAvatars.isNotEmpty)
                        SizedBox(
                          height: 40,
                          child: Stack(
                            children: List.generate(
                              event.participantAvatars.length.clamp(0, 5),
                              (i) => Positioned(
                                left: i * 28.0,
                                child: Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.backgroundDark, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(imageUrl: event.participantAvatars[i], fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const Text('Les membres du club y vont.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom CTA
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                border: Border(top: BorderSide(color: AppColors.borderSubtle.withValues(alpha: 0.3))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    MockDataService().registerForEvent(event.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inscription confirmée !')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 12,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  child: Text("Je m'inscris  •  ${event.priceDisplay}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
