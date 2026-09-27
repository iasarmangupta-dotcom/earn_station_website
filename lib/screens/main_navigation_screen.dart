import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../models/app_models.dart';
import 'dashboard_screen.dart';
import 'earn_screen.dart';
import 'wallet_screen.dart';
import 'referrals_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';
import 'task_detail_screen.dart';
import 'withdraw_dialog.dart';

class MainNavigationScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const MainNavigationScreen({
    super.key,
    required this.appState,
    required this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  EarnTask? _selectedTask;

  void _openWithdrawModal() {
    showDialog(
      context: context,
      builder: (_) => WithdrawModal(appState: widget.appState),
    );
  }

  void _startTask(EarnTask task) {
    setState(() {
      _selectedTask = task;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.appState.user;
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            border: Border(bottom: BorderSide(color: Color(0xFF334155))),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // App Logo
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Watch & Earn',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),

                // Admin Toggle Button
                TextButton.icon(
                  onPressed: () {
                    widget.appState.toggleAdminMode(!widget.appState.isAdminMode);
                    if (widget.appState.isAdminMode) {
                      setState(() {
                        _currentIndex = 5; // Admin tab
                      });
                    }
                  },
                  icon: Icon(
                    Icons.admin_panel_settings_rounded,
                    color: widget.appState.isAdminMode ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                    size: 18,
                  ),
                  label: Text(
                    widget.appState.isAdminMode ? 'Admin Active' : 'Admin Panel',
                    style: TextStyle(
                      color: widget.appState.isAdminMode ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Coins Balance Badge
                if (user != null)
                  InkWell(
                    onTap: _openWithdrawModal,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on_rounded, color: Color(0xFFF59E0B), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${user.coins}',
                            style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(width: 10),

                // Profile Avatar Button
                if (user != null)
                  InkWell(
                    onTap: () => setState(() => _currentIndex = 4),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF3B82F6),
                      child: Text(user.profilePic, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          // Sidebar for Desktop view
          if (isDesktop)
            Container(
              width: 220,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                border: Border(right: BorderSide(color: Color(0xFF334155))),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildSidebarItem(0, 'Dashboard', Icons.dashboard_rounded),
                  _buildSidebarItem(1, 'Earn / Tasks', Icons.stars_rounded),
                  _buildSidebarItem(2, 'My Wallet', Icons.account_balance_wallet_rounded),
                  _buildSidebarItem(3, 'Refer & Earn', Icons.card_giftcard_rounded),
                  _buildSidebarItem(4, 'Profile & Leader', Icons.person_rounded),
                  if (widget.appState.isAdminMode)
                    _buildSidebarItem(5, 'Owner Admin', Icons.admin_panel_settings_rounded, isHighlight: true),
                  const Spacer(),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
                    title: const Text('Log Out', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.bold)),
                    onTap: widget.onLogout,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

          // Main Screen View
          Expanded(
            child: _selectedTask != null
                ? TaskDetailScreen(
                    task: _selectedTask!,
                    appState: widget.appState,
                    onBack: () => setState(() => _selectedTask = null),
                  )
                : _buildScreenContent(),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex > 4 ? 0 : _currentIndex,
              onTap: (index) => setState(() {
                _currentIndex = index;
                _selectedTask = null;
              }),
              backgroundColor: const Color(0xFF1E293B),
              selectedItemColor: const Color(0xFF3B82F6),
              unselectedItemColor: const Color(0xFF64748B),
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.stars_rounded), label: 'Earn'),
                BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Wallet'),
                BottomNavigationBarItem(icon: Icon(Icons.card_giftcard_rounded), label: 'Refer'),
                BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
              ],
            ),
    );
  }

  Widget _buildSidebarItem(int index, String label, IconData icon, {bool isHighlight = false}) {
    bool isSelected = _currentIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF2563EB)
            : (isHighlight ? const Color(0xFFF59E0B).withOpacity(0.15) : Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : (isHighlight ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8)),
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isHighlight ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8)),
            fontWeight: isSelected || isHighlight ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
        onTap: () {
          setState(() {
            _currentIndex = index;
            _selectedTask = null;
          });
        },
      ),
    );
  }

  Widget _buildScreenContent() {
    switch (_currentIndex) {
      case 0:
        return DashboardScreen(
          appState: widget.appState,
          onNavigateToTab: (idx) => setState(() {
            _currentIndex = idx;
            _selectedTask = null;
          }),
          onStartTask: _startTask,
          onOpenWithdrawModal: _openWithdrawModal,
        );
      case 1:
        return EarnScreen(
          appState: widget.appState,
          onStartTask: _startTask,
        );
      case 2:
        return WalletScreen(
          appState: widget.appState,
          onOpenWithdrawModal: _openWithdrawModal,
        );
      case 3:
        return ReferralsScreen(appState: widget.appState);
      case 4:
        return ProfileScreen(
          appState: widget.appState,
          onLogout: widget.onLogout,
        );
      case 5:
        return AdminScreen(appState: widget.appState);
      default:
        return const SizedBox.shrink();
    }
  }
}
