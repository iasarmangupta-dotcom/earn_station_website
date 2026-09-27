enum TaskCategory { all, youtube, instagram, telegram, social, offers }

enum TaskStatus { available, inProgress, completed, pendingVerification }

enum WithdrawalStatus { pending, approved, rejected }

enum PaymentMethod { upi, bank, paytm, giftCard }

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePic;
  final int coins;
  final int todayEarnedCoins;
  final int totalEarnedCoins;
  final int streakDays;
  final int rank;
  final String referralCode;
  final bool isKycVerified;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.coins,
    required this.todayEarnedCoins,
    required this.totalEarnedCoins,
    required this.streakDays,
    required this.rank,
    required this.referralCode,
    this.isKycVerified = false,
  });

  double get inrValue => coins / 10.0; // 10 coins = ₹1

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    int? coins,
    int? todayEarnedCoins,
    int? totalEarnedCoins,
    int? streakDays,
    int? rank,
    bool? isKycVerified,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePic: profilePic,
      coins: coins ?? this.coins,
      todayEarnedCoins: todayEarnedCoins ?? this.todayEarnedCoins,
      totalEarnedCoins: totalEarnedCoins ?? this.totalEarnedCoins,
      streakDays: streakDays ?? this.streakDays,
      rank: rank ?? this.rank,
      referralCode: referralCode,
      isKycVerified: isKycVerified ?? this.isKycVerified,
    );
  }
}

class EarnTask {
  final String id;
  final String title;
  final String sponsor;
  final String thumbnailUrl;
  final TaskCategory category;
  final int rewardCoins;
  final int durationSeconds;
  final String requirements;
  final String actionUrl;
  final bool isPlatformOwned;

  EarnTask({
    required this.id,
    required this.title,
    required this.sponsor,
    required this.thumbnailUrl,
    required this.category,
    required this.rewardCoins,
    required this.durationSeconds,
    required this.requirements,
    required this.actionUrl,
    this.isPlatformOwned = true,
  });
}

class WalletTransaction {
  final String id;
  final String title;
  final int coins;
  final double amountInr;
  final DateTime timestamp;
  final bool isCredit; // true = earned, false = withdrawal
  final String status; // 'Completed', 'Pending', 'Failed'

  WalletTransaction({
    required this.id,
    required this.title,
    required this.coins,
    required this.amountInr,
    required this.timestamp,
    required this.isCredit,
    required this.status,
  });
}

class WithdrawalRequest {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final double amountInr;
  final int coinsDeducted;
  final PaymentMethod method;
  final String paymentDetails; // UPI ID or Bank A/C
  final DateTime requestedAt;
  WithdrawalStatus status;
  String? rejectionReason;

  WithdrawalRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.amountInr,
    required this.coinsDeducted,
    required this.method,
    required this.paymentDetails,
    required this.requestedAt,
    this.status = WithdrawalStatus.pending,
    this.rejectionReason,
  });
}

class LeaderboardUser {
  final int rank;
  final String name;
  final String avatar;
  final int totalCoins;
  final double totalInr;

  LeaderboardUser({
    required this.rank,
    required this.name,
    required this.avatar,
    required this.totalCoins,
    required this.totalInr,
  });
}
