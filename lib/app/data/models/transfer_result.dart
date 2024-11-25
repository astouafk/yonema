// lib/app/data/models/transfer_result.dart
import 'transaction_model.dart';

class TransferResult {
  final bool isSuccess;  // Renommé de 'success' à 'isSuccess' pour éviter la confusion
  final String message;
  final TransactionModel? transaction;
  final dynamic error;

  const TransferResult({
    required this.isSuccess,
    required this.message,
    this.transaction,
    this.error,
  });

  static TransferResult success({TransactionModel? transaction, String? message}) {
    return TransferResult(
      isSuccess: true,
      message: message ?? 'Transaction réussie',
      transaction: transaction,
    );
  }

  static TransferResult failure(String message, {dynamic error}) {
    return TransferResult(
      isSuccess: false,
      message: message,
      error: error,
    );
  }
}