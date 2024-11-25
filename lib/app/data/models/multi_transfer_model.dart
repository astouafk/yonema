// lib/app/data/models/multi_transfer_model.dart
import '../enums/transaction_enums.dart';
import 'transaction_model.dart';

class MultiTransferModel extends TransactionModel {
  final List<String> receiverIds;
  final List<String?> receiverPhones;
  final Map<String, TransactionStatus> receiverStatuses;

  MultiTransferModel({
    required super.id,
    required super.amount,
    required super.createdAt,
    required super.status,
    required super.senderId,
    required super.receiverId,
    super.senderPhone,
    super.receiverPhone,
    required this.receiverIds,
    required this.receiverPhones,
    required this.receiverStatuses,
  }) : super(type: TransactionType.MULTI_TRANSFER);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.addAll({
      'receiver_ids': receiverIds,
      'receiver_phones': receiverPhones,
      'receiver_statuses': receiverStatuses.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    });
    return data;
  }

  factory MultiTransferModel.fromJson(Map<String, dynamic> json) {
    return MultiTransferModel(
      id: json['id'],
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      senderPhone: json['sender_phone'],
      receiverPhone: json['receiver_phone'],
      receiverIds: List<String>.from(json['receiver_ids']),
      receiverPhones: List<String?>.from(json['receiver_phones']),
      receiverStatuses: Map<String, TransactionStatus>.from(
        json['receiver_statuses'].map(
          (key, value) => MapEntry(
            key,
            TransactionStatus.values.firstWhere(
              (e) => e.toString() == value,
            ),
          ),
        ),
      ),
    );
  }
}