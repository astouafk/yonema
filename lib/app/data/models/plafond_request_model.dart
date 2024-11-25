// lib/app/data/models/plafond_request_model.dart
import '../enums/transaction_enums.dart';
import 'transaction_model.dart';

class PlafondRequestModel extends TransactionModel {
  final double currentPlafond;
  final double requestedPlafond;
  final String? agentId;
  final String? reason;
  final DateTime? processedAt;

  PlafondRequestModel({
    required super.id,
    required super.createdAt,
    required super.status,
    required super.senderId,
    required this.currentPlafond,
    required this.requestedPlafond,
    this.agentId,
    this.reason,
    this.processedAt,
  }) : super(
          type: TransactionType.PLAFOND_REQUEST,
          amount: 0,
          receiverId: '',  // Pas de récepteur pour une demande de plafond
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.addAll({
      'current_plafond': currentPlafond,
      'requested_plafond': requestedPlafond,
      'agent_id': agentId,
      'reason': reason,
      'processed_at': processedAt?.toIso8601String(),
    });
    return data;
  }

  factory PlafondRequestModel.fromJson(Map<String, dynamic> json) {
    return PlafondRequestModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      senderId: json['sender_id'],
      currentPlafond: json['current_plafond'].toDouble(),
      requestedPlafond: json['requested_plafond'].toDouble(),
      agentId: json['agent_id'],
      reason: json['reason'],
      processedAt: json['processed_at'] != null 
          ? DateTime.parse(json['processed_at']) 
          : null,
    );
  }
}
