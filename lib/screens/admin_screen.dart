import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../models/app_models.dart';

class AdminScreen extends StatefulWidget {
  final AppState appState;

  const AdminScreen({super.key, required this.appState});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _titleController = TextEditingController();
  final _sponsorController = TextEditingController();
  final _coinsController = TextEditingController(text: '50');
  final _durationController = TextEditingController(text: '30');
  TaskCategory _category = TaskCategory.youtube;

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add New Sponsor Campaign / Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Task Title (e.g. Watch Product Video)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _sponsorController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Sponsor Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _coinsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Reward Coins'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Duration (Seconds)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                widget.appState.addNewTask(
                  EarnTask(
                    id: 't_${DateTime.now().millisecondsSinceEpoch}',
                    title: _titleController.text,
                    sponsor: _sponsorController.text.isEmpty ? 'Verified Sponsor' : _sponsorController.text,
                    thumbnailUrl: 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/220',
                    category: _category,
                    rewardCoins: int.tryParse(_coinsController.text) ?? 50,
                    durationSeconds: int.tryParse(_durationController.text) ?? 30,
                    requirements: 'Complete video duration to claim coins.',
                    actionUrl: 'https://youtube.com',
                  ),
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New Task Created & Published Successfully!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
            child: const Text('Publish Task', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF334155))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingWithdrawals = widget.appState.withdrawals.where((w) => w.status == WithdrawalStatus.pending).toList();
    final allWithdrawals = widget.appState.withdrawals;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Admin Banner Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.admin_panel_settings_rounded, color: Color(0xFFF59E0B), size: 24),
                        SizedBox(width: 8),
                        Text('Owner / Admin Panel', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('Manage user payout requests, UPI withdrawals, and active campaigns.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _showAddTaskDialog,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Admin Stats Summary
          Row(
            children: [
              Expanded(child: _buildAdminStatTile('Pending Payouts', '${pendingWithdrawals.length}', Icons.pending_actions_rounded, const Color(0xFFF59E0B))),
              const SizedBox(width: 12),
              Expanded(child: _buildAdminStatTile('Active Tasks', '${widget.appState.tasks.length}', Icons.task_alt_rounded, const Color(0xFF3B82F6))),
              const SizedBox(width: 12),
              Expanded(child: _buildAdminStatTile('Total Users', '1,240', Icons.people_alt_rounded, const Color(0xFF10B981))),
            ],
          ),

          const SizedBox(height: 28),

          // Pending Withdrawal Requests Table
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('User Payout Requests (UPI / Bank)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),

          if (allWithdrawals.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.inbox_rounded, color: Color(0xFF64748B), size: 40),
                  SizedBox(height: 8),
                  Text('No withdrawal requests submitted yet.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allWithdrawals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final req = allWithdrawals[index];

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 16,
                                backgroundColor: Color(0xFF2563EB),
                                child: Icon(Icons.person, size: 18, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(req.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                  Text(req.userPhone, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: req.status == WithdrawalStatus.approved
                                  ? const Color(0xFF10B981).withOpacity(0.2)
                                  : (req.status == WithdrawalStatus.pending
                                      ? const Color(0xFFF59E0B).withOpacity(0.2)
                                      : const Color(0xFFEF4444).withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              req.status.name.toUpperCase(),
                              style: TextStyle(
                                color: req.status == WithdrawalStatus.approved
                                    ? const Color(0xFF10B981)
                                    : (req.status == WithdrawalStatus.pending ? const Color(0xFFF59E0B) : const Color(0xFFEF4444)),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF334155), height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Withdrawal Amount:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                              Text('₹${req.amountInr.toStringAsFixed(2)} (${req.coinsDeducted} Coins)', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Method: ${req.method.name.toUpperCase()}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                              Text('Details: ${req.paymentDetails}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                      if (req.status == WithdrawalStatus.pending) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  widget.appState.approveWithdrawal(req.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Payout Approved for ₹${req.amountInr}! Mark money sent via PhonePe/GPay.')),
                                  );
                                },
                                icon: const Icon(Icons.check_circle_rounded, size: 16),
                                label: const Text('Approve & Mark Sent'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  widget.appState.rejectWithdrawal(req.id, 'Invalid details');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Payout Rejected & Coins refunded to user.')),
                                  );
                                },
                                icon: const Icon(Icons.cancel_rounded, size: 16),
                                label: const Text('Reject & Refund'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFEF4444),
                                  side: const BorderSide(color: Color(0xFFEF4444)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAdminStatTile(String label, String value, IconData icon, Color color) {
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
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}
