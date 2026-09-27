import 'package:flutter/material.dart';
import '../models/app_models.dart';

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isAdminMode = false;
  UserProfile? _currentUser;
  
  // Storage lists
  final List<EarnTask> _tasks = [];
  final List<WalletTransaction> _transactions = [];
  final List<WithdrawalRequest> _withdrawals = [];
  final List<LeaderboardUser> _leaderboard = [];
  final Set<String> _completedTaskIds = {};

  AppState() {
    _loadInitialData();
  }

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdminMode => _isAdminMode;
  UserProfile? get user => _currentUser;
  List<EarnTask> get tasks => List.unmodifiable(_tasks);
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);
  List<WithdrawalRequest> get withdrawals => List.unmodifiable(_withdrawals);
  List<LeaderboardUser> get leaderboard => List.unmodifiable(_leaderboard);
  Set<String> get completedTaskIds => _completedTaskIds;

  void _loadInitialData() {
    // Initial dummy tasks matching the UI blueprint
    _tasks.addAll([
      EarnTask(
        id: 't1',
        title: 'Watch Motivational Video | Never Give Up',
        sponsor: 'Motivation Hub',
        thumbnailUrl: 'https://picsum.photos/seed/tech1/400/220',
        category: TaskCategory.youtube,
        rewardCoins: 50,
        durationSeconds: 30,
        requirements: 'Watch full video for 30 seconds. Do not skip or close the tab before progress reaches 100%.',
        actionUrl: 'https://youtube.com',
      ),
      EarnTask(
        id: 't2',
        title: 'Watch Tech Review & Product Overview',
        sponsor: 'Tech Insider',
        thumbnailUrl: 'https://picsum.photos/seed/tech2/400/220',
        category: TaskCategory.youtube,
        rewardCoins: 40,
        durationSeconds: 25,
        requirements: 'Watch full video for 25 seconds to verify completion.',
        actionUrl: 'https://youtube.com',
      ),
      EarnTask(
        id: 't3',
        title: 'Follow EarnStation Official Instagram',
        sponsor: 'EarnStation HQ',
        thumbnailUrl: 'https://picsum.photos/seed/insta/400/220',
        category: TaskCategory.instagram,
        rewardCoins: 30,
        durationSeconds: 15,
        requirements: 'Visit Instagram page, click follow, and return to claim your coins.',
        actionUrl: 'https://instagram.com',
      ),
      EarnTask(
        id: 't4',
        title: 'Join EarnStation Official Telegram Channel',
        sponsor: 'EarnStation Community',
        thumbnailUrl: 'https://picsum.photos/seed/tele/400/220',
        category: TaskCategory.telegram,
        rewardCoins: 35,
        durationSeconds: 15,
        requirements: 'Join channel for daily gift codes and announcements.',
        actionUrl: 'https://t.me',
      ),
      EarnTask(
        id: 't5',
        title: 'Complete Financial Literacy Quick Survey',
        sponsor: 'FinTech Pulse',
        thumbnailUrl: 'https://picsum.photos/seed/survey/400/220',
        category: TaskCategory.offers,
        rewardCoins: 100,
        durationSeconds: 45,
        requirements: 'Answer 5 quick questions about savings habits.',
        actionUrl: 'https://example.com/survey',
      ),
      EarnTask(
        id: 't6',
        title: 'Watch Trending Vlog & Life Hack Video',
        sponsor: 'Vlog World',
        thumbnailUrl: 'https://picsum.photos/seed/vlog/400/220',
        category: TaskCategory.youtube,
        rewardCoins: 50,
        durationSeconds: 30,
        requirements: 'Watch the entire video for 30s to trigger reward credit.',
        actionUrl: 'https://youtube.com',
      ),
    ]);

    // Initial Leaderboard
    _leaderboard.addAll([
      LeaderboardUser(rank: 1, name: 'Ajay Sharma', avatar: 'A', totalCoins: 12500, totalInr: 1250.0),
      LeaderboardUser(rank: 2, name: 'Priya Verma', avatar: 'P', totalCoins: 10800, totalInr: 1080.0),
      LeaderboardUser(rank: 3, name: 'Rahul Gupta', avatar: 'R', totalCoins: 9400, totalInr: 940.0),
      LeaderboardUser(rank: 4, name: 'Neha Singh', avatar: 'N', totalCoins: 8700, totalInr: 870.0),
      LeaderboardUser(rank: 5, name: 'Mohit Kumar', avatar: 'M', totalCoins: 7600, totalInr: 760.0),
      LeaderboardUser(rank: 6, name: 'Aman Patel', avatar: 'A', totalCoins: 6500, totalInr: 650.0),
      LeaderboardUser(rank: 7, name: 'Pooja Joshi', avatar: 'P', totalCoins: 5900, totalInr: 590.0),
      LeaderboardUser(rank: 8, name: 'Vikas Roy', avatar: 'V', totalCoins: 5200, totalInr: 520.0),
      LeaderboardUser(rank: 9, name: 'Ananya Roy', avatar: 'A', totalCoins: 4800, totalInr: 480.0),
      LeaderboardUser(rank: 10, name: 'Arman Gupta', avatar: 'A', totalCoins: 4250, totalInr: 425.0),
    ]);
  }

  void login(String name, String email, String phone) {
    _currentUser = UserProfile(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name.isEmpty ? 'Arman Gupta' : name,
      email: email.isEmpty ? 'arman@example.com' : email,
      phone: phone.isEmpty ? '+91 9876543210' : phone,
      profilePic: (name.isNotEmpty ? name[0] : 'A').toUpperCase(),
      coins: 50, // Welcome Signup Bonus
      todayEarnedCoins: 50,
      totalEarnedCoins: 50,
      streakDays: 1,
      rank: 12,
      referralCode: 'EARN9876',
      isKycVerified: true,
    );

    _isLoggedIn = true;

    // Initial mock transactions for user
    if (_transactions.isEmpty) {
      _transactions.addAll([
        WalletTransaction(
          id: 'tx_101',
          title: 'YouTube Video Task Reward',
          coins: 50,
          amountInr: 5.0,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isCredit: true,
          status: 'Completed',
        ),
        WalletTransaction(
          id: 'tx_102',
          title: 'Instagram Follow Task',
          coins: 30,
          amountInr: 3.0,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isCredit: true,
          status: 'Completed',
        ),
        WalletTransaction(
          id: 'tx_103',
          title: 'Daily Streak Bonus',
          coins: 100,
          amountInr: 10.0,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isCredit: true,
          status: 'Completed',
        ),
      ]);
    }

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  void toggleAdminMode(bool enabled) {
    _isAdminMode = enabled;
    notifyListeners();
  }

  // Complete a task and receive reward
  bool completeTask(EarnTask task) {
    if (_completedTaskIds.contains(task.id)) return false;

    _completedTaskIds.add(task.id);

    if (_currentUser != null) {
      int newCoins = _currentUser!.coins + task.rewardCoins;
      int newTodayEarned = _currentUser!.todayEarnedCoins + task.rewardCoins;
      int newTotalEarned = _currentUser!.totalEarnedCoins + task.rewardCoins;

      _currentUser = _currentUser!.copyWith(
        coins: newCoins,
        todayEarnedCoins: newTodayEarned,
        totalEarnedCoins: newTotalEarned,
      );

      _transactions.insert(
        0,
        WalletTransaction(
          id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
          title: '${task.title} (Reward)',
          coins: task.rewardCoins,
          amountInr: task.rewardCoins / 10.0,
          timestamp: DateTime.now(),
          isCredit: true,
          status: 'Completed',
        ),
      );
    }

    notifyListeners();
    return true;
  }

  // Request withdrawal
  bool requestWithdrawal({
    required double amountInr,
    required PaymentMethod method,
    required String paymentDetails,
  }) {
    int requiredCoins = (amountInr * 10).toInt();

    if (_currentUser == null || _currentUser!.coins < requiredCoins) {
      return false;
    }

    // Deduct coins
    _currentUser = _currentUser!.copyWith(
      coins: _currentUser!.coins - requiredCoins,
    );

    // Create withdrawal request for Admin
    final request = WithdrawalRequest(
      id: 'WDR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      userId: _currentUser!.id,
      userName: _currentUser!.name,
      userPhone: _currentUser!.phone,
      amountInr: amountInr,
      coinsDeducted: requiredCoins,
      method: method,
      paymentDetails: paymentDetails,
      requestedAt: DateTime.now(),
      status: WithdrawalStatus.pending,
    );

    _withdrawals.insert(0, request);

    // Add transaction entry
    _transactions.insert(
      0,
      WalletTransaction(
        id: request.id,
        title: 'Withdrawal to ${method.name.toUpperCase()} ($paymentDetails)',
        coins: requiredCoins,
        amountInr: amountInr,
        timestamp: DateTime.now(),
        isCredit: false,
        status: 'Pending',
      ),
    );

    notifyListeners();
    return true;
  }

  // Admin Actions
  void approveWithdrawal(String requestId) {
    final idx = _withdrawals.indexWhere((w) => w.id == requestId);
    if (idx != -1) {
      _withdrawals[idx].status = WithdrawalStatus.approved;
      
      // Update transaction status
      final txIdx = _transactions.indexWhere((t) => t.id == requestId);
      if (txIdx != -1) {
        _transactions[txIdx] = WalletTransaction(
          id: _transactions[txIdx].id,
          title: _transactions[txIdx].title,
          coins: _transactions[txIdx].coins,
          amountInr: _transactions[txIdx].amountInr,
          timestamp: _transactions[txIdx].timestamp,
          isCredit: _transactions[txIdx].isCredit,
          status: 'Completed',
        );
      }
      notifyListeners();
    }
  }

  void rejectWithdrawal(String requestId, String reason) {
    final idx = _withdrawals.indexWhere((w) => w.id == requestId);
    if (idx != -1) {
      final req = _withdrawals[idx];
      req.status = WithdrawalStatus.rejected;
      req.rejectionReason = reason;

      // Refund user coins
      if (_currentUser != null && req.userId == _currentUser!.id) {
        _currentUser = _currentUser!.copyWith(
          coins: _currentUser!.coins + req.coinsDeducted,
        );
      }

      // Update transaction status
      final txIdx = _transactions.indexWhere((t) => t.id == requestId);
      if (txIdx != -1) {
        _transactions[txIdx] = WalletTransaction(
          id: _transactions[txIdx].id,
          title: '${_transactions[txIdx].title} (Refunded)',
          coins: _transactions[txIdx].coins,
          amountInr: _transactions[txIdx].amountInr,
          timestamp: _transactions[txIdx].timestamp,
          isCredit: true,
          status: 'Rejected',
        );
      }
      notifyListeners();
    }
  }

  void addNewTask(EarnTask task) {
    _tasks.insert(0, task);
    notifyListeners();
  }
}
