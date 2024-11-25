// lib/app/modules/transfer/controllers/transfer_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Added Flutter material package import
import '../../../data/services/transaction_service.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/services/auth_service.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/scheduled_transfer_model.dart';
import '../../../data/enums/transaction_enums.dart';
import 'dart:async';  

class TransferController extends GetxController {
  final TransactionService _transactionService = TransactionService();
   Timer? _messageTimer;
    // Ajouter cette propriété pour stocker les transferts planifiés
  final RxList<ScheduledTransferModel> scheduledTransfers = <ScheduledTransferModel>[].obs;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();  // Ajout de cette ligne


  
  // États observables
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString successMessage = ''.obs;
  final RxDouble amount = 0.0.obs;
  final RxString receiverPhone = ''.obs;
  final RxList<String> multipleReceivers = <String>[].obs;
  final RxList<TransactionModel> recentTransactions = <TransactionModel>[].obs;
  final RxBool isQRScanMode = false.obs;

  // Pour transferts planifiés
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxString selectedInterval = 'daily'.obs;
  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);


  // Getters utiles
  UserModel? get currentUser => AuthService.to.getUser();
  bool get canMakeTransfer => !isLoading.value && amount.value > 0 && receiverPhone.isNotEmpty;

   @override
  void onInit() {
    super.onInit();
    loadScheduledTransfers(); // Charger les transferts planifiés au démarrage
  }

  // Transfert multiple
  Future<void> makeMultipleTransfer() async {
  if (multipleReceivers.isEmpty || amount.value <= 0) return;

  try {
    isLoading.value = true;
    error.value = '';
    successMessage.value = '';

    final result = await _transactionService.makeMultipleTransfer(
      sender: currentUser!,
      receiverPhones: multipleReceivers,
      amountPerPerson: amount.value,
    );

    if (result.isSuccess) {
      successMessage.value = result.message;
      _clearMultipleForm();
      
      // Mettre à jour le dashboard
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.refreshDashboard();
      }
    } else {
      error.value = result.message;
    }
  } catch (e) {
    error.value = 'Une erreur est survenue: $e';
  } finally {
    isLoading.value = false;
  }
}
  // Transfert planifié
   Future<void> scheduleTransfer() async {
    try {
      // Validation des champs
      if (amount.value <= 0 ||
          receiverPhone.isEmpty ||
          startDate.value == null ||
          endDate.value == null ||
          startTime.value == null ||
          endTime.value == null) {
        Get.snackbar(
          'Erreur',
          'Veuillez remplir tous les champs',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;
      error.value = '';
      successMessage.value = '';

      // Combiner les dates et les heures
      final fullStartDate = combineDateAndTime(startDate.value!, startTime.value!);
      final fullEndDate = combineDateAndTime(endDate.value!, endTime.value!);

      final result = await _transactionService.createScheduledTransfer(
        sender: currentUser!,
        receiverPhone: receiverPhone.value,
        amount: amount.value,
        startDate: fullStartDate,
        endDate: fullEndDate,
        interval: selectedInterval.value,
      );

      if (result.isSuccess) {
        successMessage.value = result.message;
        _clearScheduleForm();
        Get.back(); // Retour à la vue précédente
        Get.snackbar(
          'Succès',
          'Transfert planifié avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        error.value = result.message;
        Get.snackbar(
          'Erreur',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      error.value = 'Une erreur est survenue: $e';
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

   // Méthode helper pour combiner date et heure
  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  // Charger l'historique récent
 Future<void> loadRecentTransactions() async {
  try {
    final transactions = await _transactionService.getRecentTransactions(currentUser!.id!);
    recentTransactions.assignAll(transactions);
  } catch (e) {
    print('Erreur chargement transactions: $e');
  }
}

  // Annuler une transaction
  // Future<void> cancelTransaction(String transactionId) async {
  //   try {
  //     isLoading.value = true;
  //     error.value = '';
      
  //     final result = await _transactionService.cancelTransaction(transactionId);
      
  //     if (result.isSuccess) {
  //       successMessage.value = result.message;
  //       await loadRecentTransactions();
  //     } else {
  //       error.value = result.message;
  //     }
  //   } catch (e) {
  //     error.value = 'Erreur lors de l\'annulation: $e';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

 // Dans TransferController
void onQRScanned(String phone) {
  if (RegExp(r'^(70|75|76|77|78)[0-9]{7}$').hasMatch(phone)) {
    // Vérifier si c'est un nouveau numéro
    if (receiverPhone.value != phone) {
      receiverPhone.value = phone;
      Get.snackbar(
        'Succès',
        'Numéro scanné avec succès',
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  } else {
    Get.snackbar(
      'Format Invalide',
      'Le QR code ne contient pas un numéro valide',
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
    );
  }
}
  void openQRScanner() {
    Get.toNamed(Routes.QR_SCANNER);
  }
  // Ajouter un destinataire pour transfert multiple
 void addReceiver(String phone) {
  if (!multipleReceivers.contains(phone)) {
    if (RegExp(r'^(70|75|76|77|78)[0-9]{7}$').hasMatch(phone)) {
      multipleReceivers.add(phone);
      update(); // Forcer la mise à jour de l'UI
    } else {
      Get.snackbar(
        'Erreur',
        'Format de numéro invalide',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } else {
    Get.snackbar(
      'Information',
      'Ce numéro est déjà dans la liste',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}

  // Retirer un destinataire
  void removeReceiver(String phone) {
    multipleReceivers.remove(phone);
  }

  // Méthodes utilitaires privées
  void _clearForm() {
    amount.value = 0;
    receiverPhone.value = '';
    error.value = '';
  }

  void _clearMultipleForm() {
    amount.value = 0;
    multipleReceivers.clear();
    error.value = '';
  }

  void _clearScheduleForm() {
    amount.value = 0;
    receiverPhone.value = '';
    startDate.value = null;
    endDate.value = null;
    selectedInterval.value = 'daily';
    error.value = '';
  }


  void showMessage(String message, bool isError) {
    _messageTimer?.cancel();
    
    if (isError) {
      error.value = message;
    } else {
      successMessage.value = message;
    }
    
    _messageTimer = Timer(const Duration(seconds: 3), () {
      error.value = '';
      successMessage.value = '';
    });
  }

  // Transfert simple
   Future<void> makeTransfer() async {
    if (!canMakeTransfer) return;
    
    try {
      isLoading.value = true;
      final currentUser = AuthService.to.getUser();
      
      if (currentUser == null) {
        showMessage('Utilisateur non connecté', true);
        return;
      }

      final result = await _transactionService.makeTransfer(
        sender: currentUser,
        receiverPhone: receiverPhone.value,
        amount: amount.value,
      );

      if (result.isSuccess) {
        showMessage(result.message, false);
        _clearForm();
        
        // Mettre à jour le dashboard
        if (Get.isRegistered<DashboardController>()) {
          final dashboardController = Get.find<DashboardController>();
          dashboardController.refreshDashboard();
        }
      } else {
        showMessage(result.message, true);
      }
    } finally {
      isLoading.value = false;
    }
  }

   bool canCancelTransaction(TransactionModel transaction) {
  final now = DateTime.now();
  final timeDifference = now.difference(transaction.createdAt);
  return timeDifference.inMinutes <= 30 && 
         transaction.status == TransactionStatus.COMPLETED;
}

Future<TransferResult> cancelTransaction(String transactionId) async {
  try {
    isLoading.value = true;
    final result = await _transactionService.cancelTransaction(transactionId);
    if (result.isSuccess) {
      // Rafraîchir la liste des transactions
      await loadRecentTransactions();
    }
    return result;
  } finally {
    isLoading.value = false;
  }
}

// Méthode pour charger les transferts planifiés
  Future<void> loadScheduledTransfers() async {
  try {
    print('Chargement des transferts planifiés...');
    isLoading.value = true;
    final snapshot = await _db.child('scheduled_transfers')
        .orderByChild('sender_id')
        .equalTo(currentUser?.id)
        .once();

    print('Snapshot existe: ${snapshot.snapshot.exists}');
    if (snapshot.snapshot.exists) {
      final transfers = <ScheduledTransferModel>[];
      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      print('Données reçues: $data');
      
      data.forEach((key, value) {
        print('Traitement du transfert: $key');
        try {
          final transfer = ScheduledTransferModel.fromJson(
            Map<String, dynamic>.from(value)
          );
          transfer.id = key;
          transfers.add(transfer);
          print('Transfert ajouté avec succès');
        } catch (e) {
          print('Erreur lors du parsing du transfert: $e');
        }
      });
      
      scheduledTransfers.assignAll(transfers);
      print('Nombre de transferts chargés: ${transfers.length}');
    } else {
      scheduledTransfers.clear();
      print('Aucun transfert planifié trouvé');
    }
  } catch (e) {
    print('Erreur chargement des transferts planifiés: $e');
  } finally {
    isLoading.value = false;
  }
}

  // Méthode pour annuler un transfert planifié
  Future<void> cancelScheduledTransfer(String transferId) async {
    try {
      isLoading.value = true;
      await _transactionService.cancelScheduledTransfer(transferId);
      await loadScheduledTransfers(); // Recharger la liste
      Get.snackbar(
        'Succès',
        'Transfert planifié annulé avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'annulation: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _messageTimer?.cancel();
    super.onClose();
  }
}
