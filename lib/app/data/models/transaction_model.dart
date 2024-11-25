// lib/app/data/models/transaction_model.dart
import 'package:yonema_get/app/data/enums/transaction_enums.dart';

class TransactionModel {
  String? id;
  final TransactionType type;
  final double amount;
  final DateTime createdAt;
  final TransactionStatus status;
  final String senderId;
  final String receiverId;
  String? senderPhone;
  String? receiverPhone;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.senderId,
    required this.receiverId,
    this.senderPhone,
    this.receiverPhone,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'amount': amount,
    'created_at': createdAt.toIso8601String(),
    'status': status.toString(),
    'sender_id': senderId,
    'receiver_id': receiverId,
    'sender_phone': senderPhone,
    'receiver_phone': receiverPhone,
  };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      senderPhone: json['sender_phone'],
      receiverPhone: json['receiver_phone'],
    );
  }

  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    DateTime? createdAt,
    TransactionStatus? status,
    String? senderId,
    String? receiverId,
    String? senderPhone,
    String? receiverPhone,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderPhone: senderPhone ?? this.senderPhone,
      receiverPhone: receiverPhone ?? this.receiverPhone,
    );
  }
}