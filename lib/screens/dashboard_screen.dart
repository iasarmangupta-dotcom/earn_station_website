import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../models/app_models.dart';

class DashboardScreen extends StatelessWidget {
  final AppState appState;
  final Function(int tabIndex) onNavigateToTab;
  final Function(EarnTask task) onStartTask;
  final VoidCallback onOpenWithdrawModal;

  const DashboardScreen({
    super.key,
    required this.appState,
    required this.onNavigateToTab,
    required this.onStartTask,
    required this.onOpenWithdrawModal,
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
          // Greeting Header
          Row(
            children: [
              Text(
                'Hello, ${user.name}',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Text('👋', style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Keep watching, keep earning!', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
          const SizedBox(height: 20),

          // Main Balance Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Balance', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.monetization_on_rounded, color: Color(0xFFF59E0B), size: 28),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.coins} Coins',
                              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '≈ ₹${user.inrValue.toStringAsFixed(2)} INR',
                              style: const TextStyle(color: Color(0xFF10B981), fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onOpenWithdrawModal,
                  icon: const Icon(Icons.account_balance_wallet_rounded, size: 18),
                  label: const Text('Withdraw'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stat Cards (Today Earned, Total Earned, Rank)
          LayoutBuilder(
            builder: (context, constraints) {
              double cardWidth = (constraints.maxWidth - 32) / 3;
              if (cardWidth < 100) cardWidth = constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildStatTile(
                    width: cardWidth,
                    label: 'Today Earned',
                    value: '+${user.todayEarnedCoins}',
                    subtext: 'Coins',
                    icon: Icons.trending_up_rounded,
                    iconColor: const Color(0xFF10B981),
                  ),
                  _buildStatTile(
                    width: cardWidth,
                    label: 'Total Earned',
                    value: '${user.totalEarnedCoins}',
                    subtext: 'Coins',
                    icon: Icons.savings_rounded,
                    iconColor: const Color(0xFF3B82F6),
                  ),
                  _buildStatTile(
                    width: cardWidth,
                    label: 'Leaderboard Rank',
                    value: '#${user.rank}',
                    subtext: '(Top 100)',
                    icon: Icons.emoji_events_rounded,
                    iconColor: const Color(0xFFF59E0B),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          // Quick Actions Row
          const Text('Quick Actions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),

          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _buildQuickActionCard(
                title: 'Watch YouTube',
                subTitle: 'Earn Coins',
                icon: Icons.play_circle_fill_rounded,
                color: const Color(0xFFEF4444),
                onTap: () => onNavigateToTab(1), // Go to Earn tab
              ),
              _buildQuickActionCard(
                title: 'Follow Instagram',
                subTitle: 'Earn Coins',
                icon: Icons.camera_alt_rounded,
                color: const Color(0xFFEC4899),
                onTap: () => onNavigateToTab(1),
              ),
              _buildQuickActionCard(
                title: 'Join Telegram',
                subTitle: 'Earn Coins',
                icon: Icons.send_rounded,
                color: const Color(0xFF0EA5E9),
                onTap: () => onNavigateToTab(1),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Daily Tasks / Recommended Tasks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Featured Tasks", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => onNavigateToTab(1),
                child: const Text('View All Tasks', style: TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appState.tasks.take(3).length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = appState.tasks[index];
              final isDone = appState.completedTaskIds.contains(task.id);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        task.thumbnailUrl,
                        width: 70,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 50,
                          color: const Color(0xFF334155),
                          child: const Icon(Icons.play_circle_fill, color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(task.sponsor, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                              const SizedBox(width: 8),
                              const Text('•', style: TextStyle(color: Color(0xFF64748B))),
                              const SizedBox(width: 8),
                              const Icon(Icons.monetization_on_rounded, color: Color(0xFFF59E0B), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '+${task.rewardCoins} Coins',
                                style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: isDone ? null : () => onStartTask(task),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDone ? Colors.grey : const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(isDone ? 'Completed' : 'Start Task', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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

  Widget _buildStatTile({
    required double width,
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Text(subtext, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subTitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(subTitle, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
