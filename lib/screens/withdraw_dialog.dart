import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';

class WithdrawModal extends StatefulWidget {
  final AppState appState;

  const WithdrawModal({super.key, required this.appState});

  @override
  State<WithdrawModal> createState() => _WithdrawModalState();
}

class _WithdrawModalState extends State<WithdrawModal> {
  PaymentMethod selectedMethod = PaymentMethod.upi;
  final _amountController = TextEditingController(text: '50');
  final _paymentDetailsController = TextEditingController(text: 'user@upi');

  @override
  Widget build(BuildContext context) {
    final user = widget.appState.user;
    if (user == null) return const SizedBox.shrink();

    double enteredInr = double.tryParse(_amountController.text) ?? 0.0;
    int requiredCoins = (enteredInr * 10).toInt();
    bool hasEnoughCoins = user.coins >= requiredCoins && enteredInr >= 50.0;

    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Withdraw Earnings', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Available Balance Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Available Balance:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                  Text(
                    '${user.coins} Coins (₹${user.inrValue.toStringAsFixed(2)})',
                    style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text('Select Withdrawal Method:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(child: _buildMethodTile(PaymentMethod.upi, 'UPI ID', Icons.account_balance_wallet_rounded)),
                const SizedBox(width: 8),
                Expanded(child: _buildMethodTile(PaymentMethod.bank, 'Bank', Icons.account_balance_rounded)),
                const SizedBox(width: 8),
                Expanded(child: _buildMethodTile(PaymentMethod.paytm, 'Paytm', Icons.phone_android_rounded)),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Amount in Rupees (₹):', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
              ),
            ),

            const SizedBox(height: 14),
            Text(
              selectedMethod == PaymentMethod.upi ? 'Enter VPA / UPI ID:' : 'Enter Phone Number / Account Details:',
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _paymentDetailsController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: selectedMethod == PaymentMethod.upi ? 'e.g., mobile@upi' : 'Enter payment address',
                hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
              ),
            ),

            const SizedBox(height: 12),
            Text(
              'Required: $requiredCoins Coins | Min withdrawal: ₹50',
              style: TextStyle(
                color: hasEnoughCoins ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: hasEnoughCoins
                    ? () {
                        final ok = widget.appState.requestWithdrawal(
                          amountInr: enteredInr,
                          method: selectedMethod,
                          paymentDetails: _paymentDetailsController.text.trim(),
                        );
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ok
                                ? 'Withdrawal Request Submitted! Status: Pending Admin Review'
                                : 'Failed to submit withdrawal.'),
                            backgroundColor: ok ? const Color(0xFF10B981) : Colors.red,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit Request', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodTile(PaymentMethod method, String title, IconData icon) {
    bool isSelected = selectedMethod == method;

    return InkWell(
      onTap: () => setState(() => selectedMethod = method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB).withOpacity(0.2) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF334155)),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8), size: 20),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
