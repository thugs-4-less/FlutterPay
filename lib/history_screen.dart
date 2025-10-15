import 'package:flutter/material.dart';

import 'package:flutter_pay/main.dart'; // Import to access appPrimaryColor
import 'package:flutter_pay/transaction_model.dart';

/// A screen that displays a detailed history of all transactions.
class HistoryScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const HistoryScreen({super.key, required this.transactions});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildTransactionList()),
        ],
      ),
    );
  }

  /// Builds the search bar for filtering transactions.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }

  /// Builds the row of filter chips.
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterChip('All'),
          _buildFilterChip('Sent'),
          _buildFilterChip('Received'),
        ],
      ),
    );
  }

  /// A helper widget to build a single filter chip.
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = label;
          });
        }
      },
      backgroundColor: Theme.of(context).cardColor,
      selectedColor: appPrimaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? appPrimaryColor : Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.bold,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? appPrimaryColor : Colors.grey[300]!,
        ),
      ),
    );
  }

  /// Builds the main list of transactions, applying the selected filter.
  Widget _buildTransactionList() {
    final filteredTransactions = widget.transactions.where((t) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Sent' && t.isSent) return true;
      if (_selectedFilter == 'Received' && !t.isSent) return true;
      return false;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        final color = transaction.isSent ? Theme.of(context).colorScheme.error : appPrimaryColor;

        return _buildTransactionItem(
          icon: transaction.isSent ? Icons.arrow_upward : Icons.arrow_downward,
          color: color,
          title: transaction.title,
          subtitle: transaction.date,
          amount: '${transaction.isSent ? '-' : '+'}\$${transaction.amount.abs().toStringAsFixed(2)}',
        );
      },
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
