/// A data model that represents a single financial transaction.
class Transaction {
  /// The title or description of the transaction (e.g., "Sent to John Doe").
  final String title;

  /// The date of the transaction, represented as a string.
  final String date;

  /// The monetary amount of the transaction.
  /// This value is negative for sent transactions and positive for received transactions.
  final double amount;

  /// A boolean indicating the direction of the transaction.
  /// `true` if money was sent, `false` if it was received.
  final bool isSent;

  /// Creates a new [Transaction] instance.
  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isSent,
  });
}
