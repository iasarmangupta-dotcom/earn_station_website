import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/app_state.dart';

class ReferralsScreen extends StatelessWidget {
  final AppState appState;

  const ReferralsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final user = appState.user;
    final inviteLink = 'https://earnstation.in/invite?ref=${user?.referralCode ?? "EARN123"}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Invite Friends & Earn 100 Coins!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        'Earn 100 Bonus Coins for every friend who signs up and completes their first task.',
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.card_giftcard_rounded, color: Color(0xFFF59E0B), size: 48),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Referral Link Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Referral Code:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      user?.referralCode ?? 'EARN9876',
                      style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 2),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, color: Color(0xFF3B82F6)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: user?.referralCode ?? 'EARN9876'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Referral Code Copied to Clipboard!')),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF334155), height: 24),
                const Text('Your Invite Link:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          inviteLink,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: inviteLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invite Link Copied! Share with friends.')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Copy Link', style: TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Referral Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatBox(title: 'Total Invited', value: '8 Friends', icon: Icons.group_rounded, color: const Color(0xFF3B82F6)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(title: 'Referral Rewards', value: '800 Coins', icon: Icons.monetization_on_rounded, color: const Color(0xFFF59E0B)),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Anti-Abuse Rules Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Color(0xFFEF4444), size: 20),
                    SizedBox(width: 8),
                    Text('Anti-Abuse & Referral Rules', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                SizedBox(height: 8),
                Text('• Fake accounts, duplicate devices, or bot signups will be detected and permanently banned.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.4)),
                SizedBox(height: 4),
                Text('• Referral rewards are granted only after the referred user completes at least 1 verified task.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
