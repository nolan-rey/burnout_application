import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final user = service.currentUser;

    final posts = [
      _FeedPost(
        userName: 'Thomas Anderson',
        userImage: user.imageUrl,
        timeAgo: 'Il y a 2h',
        text: 'Séance de musculation terminée ! Développé couché PR à 85kg 💪',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAnIGVS58sxYo_FKXHXKtyEgb2kkO8XU25VsgQSiG_Y4HM0jzAPAZjWlsscSm1nc1izJJGVT6eALKE2jmjNDWUqujqycDGpDe-QWZT4gQD9-lALkDGKJJrb2hgGenlHDp9BR6-QPC1s2I6aQTIZC41p4lYSLdI9VIWJwMfQ0hVOIX1ANpO1B0LnqhuqiZLbtUnfVWFki0Jonyn69R7wNgOLLGZamh6yYV58KtsfTr9sjzcln-wx5bwwtJA02rvSv6Oi7fcs2PqaKyPZ',
        likes: 24,
        comments: 5,
        duration: '47 min',
        rpe: '7/10',
      ),
      _FeedPost(
        userName: 'Marie Curie',
        userImage: service.coaches[1].imageUrl,
        timeAgo: 'Il y a 5h',
        text: 'Session Yoga flow incroyable ce matin. Namaste 🧘‍♀️',
        likes: 18,
        comments: 3,
        duration: '60 min',
        rpe: '5/10',
      ),
      _FeedPost(
        userName: 'Lucas Martin',
        userImage: service.coaches[2].imageUrl,
        timeAgo: 'Hier',
        text: 'Cardio blast terminé ! 5km en 22min, nouveau record personnel 🏃',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIDz6uARmNX2mf6bjr2OggXNnG7nMru03wXPIE1Ow1JZkbIyPgU8wZslMHeam_el3QtGxzFiYSH_f0I-j0245CAuvyL33hRUgcWKuWcGqcab4PGEsYQ1US4QvHgo1Dn0BBB_eNSAIhZxleOHoka0SttfIagm1W9dg0KR0FeFOrsNjzEgT_6NFPMkFUk3sM--V6Do123o6nX5_ORRNvxoYhY6NrZE1UCcKtFHx0MF7Q4UfFOVHmy5hW3WDufvbK-aWIMUymB5kJnA9k',
        likes: 42,
        comments: 8,
        duration: '22 min',
        rpe: '9/10',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
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
                  const Expanded(
                    child: Text('Feed', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            // Posts
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) => _buildPostCard(posts[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(_FeedPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: CachedNetworkImage(imageUrl: post.userImage, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(post.timeAgo, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz_rounded, color: AppColors.textMuted),
              ],
            ),
          ),
          // Stats badges
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildBadge(Icons.timer_outlined, post.duration),
                const SizedBox(width: 8),
                _buildBadge(Icons.fitness_center_rounded, 'RPE ${post.rpe}'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(post.text, style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.4)),
          ),
          // Image
          if (post.imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: CachedNetworkImage(imageUrl: post.imageUrl!, fit: BoxFit.cover),
              ),
            ),
          ],
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.favorite_rounded, size: 22, color: AppColors.primary.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text('${post.likes}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(width: 20),
                Icon(Icons.chat_bubble_outline_rounded, size: 20, color: AppColors.textMuted.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Text('${post.comments}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const Spacer(),
                Icon(Icons.share_outlined, size: 20, color: AppColors.textMuted.withValues(alpha: 0.7)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _FeedPost {
  final String userName;
  final String userImage;
  final String timeAgo;
  final String text;
  final String? imageUrl;
  final int likes;
  final int comments;
  final String duration;
  final String rpe;

  const _FeedPost({
    required this.userName,
    required this.userImage,
    required this.timeAgo,
    required this.text,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.duration,
    required this.rpe,
  });
}
