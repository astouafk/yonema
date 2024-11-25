// // lib/app/data/models/scheduled_transfer_model.dart
// import '../enums/transaction_enums.dart';
// import 'transaction_model.dart';

// class ScheduledTransferModel extends TransactionModel {
//   final DateTime startDate;
//   final DateTime endDate;
//   final ScheduleInterval interval;
//   final List<DateTime> executionDates;

//   ScheduledTransferModel({
//     required super.id,
//     required super.amount,
//     required super.createdAt,
//     required super.status,
//     required super.senderId,
//     required super.receiverId,
//     super.senderPhone,
//     super.receiverPhone,
//     required this.startDate,
//     required this.endDate,
//     required this.interval,
//     required this.executionDates,
//   }) : super(type: TransactionType.SCHEDULED_TRANSFER);

//   @override
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = super.toJson();
//     data.addAll({
//       'start_date': startDate.toIso8601String(),
//       'end_date': endDate.toIso8601String(),
//       'interval': interval.toString(),
//       'execution_dates': executionDates.map((date) => date.toIso8601String()).toList(),
//     });
//     return data;
//   }

//   factory ScheduledTransferModel.fromJson(Map<String, dynamic> json) {
//     return ScheduledTransferModel(
//       id: json['id'],
//       amount: json['amount'].toDouble(),
//       createdAt: DateTime.parse(json['created_at']),
//       status: TransactionStatus.values.firstWhere(
//         (e) => e.toString() == json['status'],
//       ),
//       senderId: json['sender_id'],
//       receiverId: json['receiver_id'],
//       senderPhone: json['sender_phone'],
//       receiverPhone: json['receiver_phone'],
//       startDate: DateTime.parse(json['start_date']),
//       endDate: DateTime.parse(json['end_date']),
//       interval: ScheduleInterval.values.firstWhere(
//         (e) => e.toString() == json['interval'],
//       ),
//       executionDates: (json['execution_dates'] as List)
//           .map((date) => DateTime.parse(date))
//           .toList(),
//     );
//   }
// }




// // lib/app/data/models/scheduled_transfer_model.dart
import '../enums/transaction_enums.dart';
import 'transaction_model.dart';

class ScheduledTransferModel extends TransactionModel {
  final DateTime startDate;
  final DateTime endDate;
  final String interval;
  final List<DateTime> executionDates;
  String? lastExecution;

  ScheduledTransferModel({
    String? id,
    required double amount,
    required DateTime createdAt,
    required TransactionStatus status,
    required String senderId,
    required String senderPhone,
    required String receiverPhone,
    required this.startDate,
    required this.endDate,
    required this.interval,
    required this.executionDates,
    this.lastExecution,
  }) : super(
          id: id,
          type: TransactionType.SCHEDULED_TRANSFER,
          amount: amount,
          createdAt: createdAt,
          status: status,
          senderId: senderId,
          receiverId: '',  // Pas nécessaire pour le transfert planifié
          senderPhone: senderPhone,
          receiverPhone: receiverPhone,
        );

  factory ScheduledTransferModel.fromJson(Map<String, dynamic> json) {
    return ScheduledTransferModel(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TransactionStatus.PENDING,
      ),
      senderId: json['sender_id'].toString(),
      senderPhone: json['sender_phone'],
      receiverPhone: json['receiver_phone'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      interval: json['interval'],
      executionDates: (json['execution_dates'] as List)
          .map((date) => DateTime.parse(date.toString()))
          .toList(),
      lastExecution: json['last_execution'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'type': type.toString(),
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'sender_id': senderId,
      'sender_phone': senderPhone,
      'receiver_phone': receiverPhone,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'interval': interval,
      'execution_dates': executionDates.map((date) => date.toIso8601String()).toList(),
      'last_execution': lastExecution,
    };
    return data;
  }
}