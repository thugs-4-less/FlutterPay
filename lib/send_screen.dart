import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter_pay/main.dart'; // Import to access appPrimaryColor
import 'package:flutter_pay/transaction_model.dart';

/// A screen for sending money to a recipient.
class SendScreen extends StatefulWidget {
  /// A callback function that is executed when a transaction is successfully sent.
  final Function(Transaction) onSend;

  /// The user's current total balance, used for validation.
  final double totalBalance;

  const SendScreen({
    super.key,
    required this.onSend,
    required this.totalBalance,
  });

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final _amountController = TextEditingController();
  String _selectedContact = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(),
            const SizedBox(height: 24),
            _buildContactsList(),
            const SizedBox(height: 32),
            _buildAmountField(),
            const Spacer(), // Pushes the send button to the bottom
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the search field for finding a recipient.
  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Email, phone or name',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }

  /// Builds the horizontal list of recent contacts.
  Widget _buildContactsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recents',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildContactAvatar('Jane D.', isSelected: _selectedContact == 'Jane D.'),
              _buildContactAvatar('John S.', isSelected: _selectedContact == 'John S.'),
              _buildContactAvatar('ACME', isSelected: _selectedContact == 'ACME'),
              _buildContactAvatar('Mom', isSelected: _selectedContact == 'Mom'),
            ],
          ),
        ),
      ],
    );
  }

  /// A helper widget to build a single contact avatar in the recent contacts list.
  Widget _buildContactAvatar(String name, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedContact = name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: isSelected ? appPrimaryColor : Theme.of(context).cardColor,
              child: Text(
                name.substring(0, 1),
                style: TextStyle(
                  fontSize: 24,
                  color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  /// Builds the text field for entering the transaction amount.
  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Amount',
        prefixText: '\$', // Persistent dollar sign
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        // Allows digits, a single decimal point, and up to 2 decimal places.
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  /// A helper function to show a standardized error dialog.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid Action'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  /// Builds the main action button to send the money.
  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // --- Input Validation ---
          if (_selectedContact.isEmpty) {
            _showErrorDialog('Please select a recipient.');
            return;
          }
          if (_amountController.text.isEmpty) {
            _showErrorDialog('Please enter an amount.');
            return;
          }

          final amount = double.tryParse(_amountController.text) ?? 0.0;

          if (amount <= 0) {
            _showErrorDialog('Please enter an amount greater than zero.');
            return;
          }

          if (amount > widget.totalBalance) {
            _showErrorDialog('Insufficient funds. You cannot send more than your current balance.');
            return;
          }

          // --- Create and Send Transaction ---
          final newTransaction = Transaction(
            title: 'Sent to $_selectedContact',
            date: DateFormat('MMMM d, yyyy').format(DateTime.now()),
            amount: -amount,
            isSent: true,
          );
          widget.onSend(newTransaction);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sent \$$amount to $_selectedContact'),
              backgroundColor: appPrimaryColor,
            ),
          );

          // --- Reset State ---
          setState(() {
            _selectedContact = '';
            _amountController.clear();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: appPrimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        child: const Text('Continue'),
      ),
    );
  }
}
