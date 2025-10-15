import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_pay/main.dart'; // Import to access appPrimaryColor
import 'package:flutter_pay/transaction_model.dart';

/// The main screen of the application, displaying a summary of the user's account.
class DashboardScreen extends StatelessWidget {
  final double totalBalance;
  final List<Transaction> transactions;

  const DashboardScreen({
    super.key,
    required this.totalBalance,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildBalanceCard(context),
            _buildActionButtons(context),
            _buildRecentTransactions(context),
          ],
        ),
      ),
    );
  }

  /// Builds the header section with a greeting and a notification button.
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  /// Builds the card that displays the user's total balance, formatted as currency.
  Widget _buildBalanceCard(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormatter.format(totalBalance),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the row of quick action buttons (e.g., Deposit, Withdraw, Send).
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(context, Icons.add, 'Deposit'),
          _buildActionButton(context, Icons.remove, 'Withdraw'),
          _buildActionButton(context, Icons.send, 'Send'),
          _buildActionButton(context, Icons.more_horiz, 'More'),
        ],
      ),
    );
  }

  /// A helper widget to build a single circular action button.
  Widget _buildActionButton(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: appPrimaryColor.withOpacity(0.1),
          child: Icon(icon, size: 30, color: appPrimaryColor),
        ),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  /// Builds the list of the user's most recent transactions.
  Widget _buildRecentTransactions(BuildContext context) {
    final recentTransactions = transactions.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (recentTransactions.isEmpty)
            const Center(
              child: Text('No recent transactions.', style: TextStyle(color: Colors.grey)),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) {
                final transaction = recentTransactions[index];
                final color = transaction.isSent ? Theme.of(context).colorScheme.error : appPrimaryColor;
                return _buildTransactionItem(
                  icon: transaction.isSent ? Icons.arrow_upward : Icons.arrow_downward,
                  color: color,
                  title: transaction.title,
                  subtitle: transaction.date,
                  amount: '${transaction.isSent ? '-' : '+'}\$${transaction.amount.abs().toStringAsFixed(2)}',
                );
              },
            ),
        ],
      ),
    );
  }

  /// A helper widget to build a single transaction list item.
  Widget _buildTransactionItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
        ),
      ),
    );
  }
}
