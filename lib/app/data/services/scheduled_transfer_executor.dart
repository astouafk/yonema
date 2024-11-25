// lib/app/services/scheduled_transfer_executor.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'transaction_service.dart';
import '../models/user_model.dart';

class ScheduledTransferExecutor extends GetxService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final TransactionService _transactionService = TransactionService();
  Timer? _executionTimer;
  

   @override
  void onInit() {
    super.onInit();
    // Vérifie toutes les minutes
    _executionTimer = Timer.periodic(
      const Duration(minutes: 1), 
      (_) => _checkScheduledTransfers(),
    );
    // Vérification initiale immédiate
    _checkScheduledTransfers();
  }

  Future<void> _checkScheduledTransfers() async {
    try {
      print('Vérification des transferts planifiés...');
      final snapshot = await _db.child('scheduled_transfers')
          .orderByChild('status')
          .equalTo('ACTIVE')
          .once(); // Utiliser once() au lieu de get()

      if (!snapshot.snapshot.exists) return;

      final now = DateTime.now();
      final transfers = Map<String, dynamic>.from(snapshot.snapshot.value as Map);

      for (var entry in transfers.entries) {
        final scheduleId = entry.key;
        final scheduleData = Map<String, dynamic>.from(entry.value);
        try {
          await _processScheduledTransfer(scheduleId, scheduleData, now);
        } catch (e) {
          print('Erreur lors du traitement du transfert $scheduleId: $e');
        }
      }
    } catch (e) {
      print('Erreur lors de la vérification des transferts planifiés: $e');
    }
  }

  @override
  void onClose() {
    _executionTimer?.cancel();
    super.onClose();
  }

  void startScheduledTransferCheck() {
    // Vérifier toutes les minutes
    _executionTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkAndExecuteScheduledTransfers();
    });
  }

  Future<void> _checkAndExecuteScheduledTransfers() async {
    try {
      print('Vérification des transferts planifiés...');

      // Récupérer tous les transferts planifiés actifs
      final snapshot = await _db.child('scheduled_transfers')
          .orderByChild('status')
          .equalTo('ACTIVE')
          .get();

      if (!snapshot.exists) return;

      final now = DateTime.now();
      final transfers = Map<String, dynamic>.from(snapshot.value as Map);

      // Parcourir tous les transferts planifiés
      for (var entry in transfers.entries) {
        final scheduleId = entry.key;
        final scheduleData = Map<String, dynamic>.from(entry.value);
        
        try {
          await _processScheduledTransfer(scheduleId, scheduleData, now);
        } catch (e) {
          print('Erreur lors du traitement du transfert $scheduleId: $e');
          continue;
        }
      }
    } catch (e) {
      print('Erreur lors de la vérification des transferts planifiés: $e');
    }
  }

  Future<void> _processScheduledTransfer(
    String scheduleId,
    Map<String, dynamic> scheduleData,
    DateTime now
  ) async {
    // Récupérer les dates d'exécution prévues
    List<DateTime> executionDates = (scheduleData['execution_dates'] as List)
        .map((date) => DateTime.parse(date))
        .toList();

    // Récupérer les dates déjà exécutées
    List<String> executedDates = 
        List<String>.from(scheduleData['executed_dates'] ?? []);

    // Vérifier les dates d'exécution pour aujourd'hui
    for (DateTime executionDate in executionDates) {
      // Vérifier si c'est le moment d'exécuter et si ce n'est pas déjà fait
      if (_shouldExecuteTransfer(executionDate, now) && 
          !executedDates.contains(executionDate.toIso8601String())) {
        
        // Exécuter le transfert
        final result = await _executeScheduledTransfer(scheduleData);

        if (result.isSuccess) {
          // Marquer comme exécuté
          executedDates.add(executionDate.toIso8601String());
          await _updateScheduleExecutionStatus(scheduleId, executedDates);
        }

        // Vérifier si c'était le dernier transfert prévu
        if (executedDates.length == executionDates.length) {
          await _completeSchedule(scheduleId);
        }
      }
    }
  }

  bool _shouldExecuteTransfer(DateTime executionDate, DateTime now) {
    return executionDate.year == now.year &&
           executionDate.month == now.month &&
           executionDate.day == now.day &&
           executionDate.hour == now.hour &&
           executionDate.minute == now.minute;
  }

  Future<TransferResult> _executeScheduledTransfer(
    Map<String, dynamic> scheduleData
  ) async {
    try {
      // Récupérer l'expéditeur
      final senderSnapshot = await _db.child('users/${scheduleData['sender_id']}').get();
      if (!senderSnapshot.exists) {
        throw 'Expéditeur non trouvé';
      }

      final sender = UserModel.fromJson(
        Map<String, dynamic>.from(senderSnapshot.value as Map)
      );

      // Exécuter le transfert
      return await _transactionService.makeTransfer(
        sender: sender,
        receiverPhone: scheduleData['receiver_phone'],
        amount: scheduleData['amount'].toDouble(),
      );
    } catch (e) {
      return TransferResult.failure('Erreur d\'exécution: $e');
    }
  }

  Future<void> _updateScheduleExecutionStatus(
    String scheduleId,
    List<String> executedDates
  ) async {
    await _db.child('scheduled_transfers/$scheduleId').update({
      'executed_dates': executedDates,
      'last_execution': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _completeSchedule(String scheduleId) async {
    await _db.child('scheduled_transfers/$scheduleId').update({
      'status': 'COMPLETED',
      'completed_at': DateTime.now().toIso8601String(),
    });
  }
}