// lib/app/data/models/agent_transaction_model.dart
import '../enums/transaction_enums.dart';
import 'transaction_model.dart';

class AgentTransactionModel extends TransactionModel {
  final String agentId;
  final String? notes;
  final String? reference;

  AgentTransactionModel({
    required super.id,
    required TransactionType type,
    required super.amount,
    required super.createdAt,
    required super.status,
    required this.agentId,
    required super.senderId,
    required super.receiverId,
    this.notes,
    this.reference,
  }) : assert(
         type == TransactionType.DEPOSIT || 
         type == TransactionType.WITHDRAWAL,
         'AgentTransactionModel can only be of type DEPOSIT or WITHDRAWAL'
       ),
       super(type: type);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.addAll({
      'agent_id': agentId,
      'notes': notes,
      'reference': reference,
    });
    return data;
  }

  factory AgentTransactionModel.fromJson(Map<String, dynamic> json) {
    return AgentTransactionModel(
      id: json['id'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      agentId: json['agent_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      notes: json['notes'],
      reference: json['reference'],
    );
  }
}
