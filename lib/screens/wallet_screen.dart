import 'package:flutter/material.dart';
import '../services/app_state.dart';

class WalletScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onOpenWithdrawModal;

  const WalletScreen({
    super.key,
    required this.appState,
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
          // Wallet Header Banner
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Wallet', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.coins} Coins',
                          style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '≈ ₹${user.inrValue.toStringAsFixed(2)} INR',
                          style: const TextStyle(color: Color(0xFF10B981), fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: onOpenWithdrawModal,
                      icon: const Icon(Icons.outbox_rounded, size: 18),
                      label: const Text('Withdraw Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Balance Breakdown Tiles
          Row(
            children: [
              Expanded(
                child: _buildBalanceTile(
                  title: 'Lifetime Earnings',
                  amount: '₹${(user.totalEarnedCoins / 10.0).toStringAsFixed(2)}',
                  coins: '${user.totalEarnedCoins} Coins',
                  color: const Color(0xFF3B82F6),
                  icon: Icons.savings_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBalanceTile(
                  title: 'Pending Payouts',
                  amount: '₹0.00',
                  coins: '0 Coins',
                  color: const Color(0xFFF59E0B),
                  icon: Icons.pending_actions_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Transaction Ledger Header
          const Text('Transaction Ledger & History', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),

          if (appState.transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.history_rounded, color: Color(0xFF64748B), size: 40),
                  SizedBox(height: 8),
                  Text('No transactions yet', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appState.transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = appState.transactions[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (tx.isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          tx.isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                          color: tx.isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${tx.timestamp.day}/${tx.timestamp.month}/${tx.timestamp.year} • Status: ${tx.status}',
                              style: TextStyle(
                                color: tx.status == 'Completed'
                                    ? const Color(0xFF10B981)
                                    : (tx.status == 'Pending' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${tx.isCredit ? "+" : "-"}${tx.coins} Coins',
                            style: TextStyle(
                              color: tx.isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '₹${tx.amountInr.toStringAsFixed(2)}',
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                          ),
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

  Widget _buildBalanceTile({
    required String title,
    required String amount,
    required String coins,
    required Color color,
    required IconData icon,
  }) {
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
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 4),
          Text(amount, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(coins, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
