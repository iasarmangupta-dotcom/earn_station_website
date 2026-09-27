import 'package:flutter/material.dart';
import '../services/app_state.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.appState,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final user = appState.user;
    if (user == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Details Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF2563EB),
                  child: Text(
                    user.profilePic,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(width: 8),
                          if (user.isKycVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
                                  SizedBox(width: 4),
                                  Text('Verified', style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(user.email, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                      Text(user.phone, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                  tooltip: 'Logout',
                  onPressed: onLogout,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Top 10 Leaderboard
          Row(
            children: const [
              Icon(Icons.emoji_events_rounded, color: Color(0xFFF59E0B), size: 24),
              SizedBox(width: 8),
              Text('Top 10 Leaderboard', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appState.leaderboard.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = appState.leaderboard[index];
              bool isTop3 = item.rank <= 3;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: item.name == user.name ? const Color(0xFF2563EB).withOpacity(0.2) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: item.name == user.name ? const Color(0xFF3B82F6) : const Color(0xFF334155),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isTop3 ? const Color(0xFFF59E0B).withOpacity(0.2) : const Color(0xFF0F172A),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '#${item.rank}',
                        style: TextStyle(
                          color: isTop3 ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF334155),
                      child: Text(item.avatar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${item.totalCoins} Coins', style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('≈ ₹${item.totalInr.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
