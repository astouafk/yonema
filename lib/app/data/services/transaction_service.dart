// lib/app/data/services/transaction_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../enums/transaction_enums.dart';
import 'auth_service.dart';

class TransferResult {
  final bool isSuccess;
  final String message;
  final TransactionModel? transaction;
  final dynamic error;

  TransferResult({
    required this.isSuccess,
    required this.message,
    this.transaction,
    this.error,
  });

  factory TransferResult.success({TransactionModel? transaction, String? message}) {
    return TransferResult(
      isSuccess: true,
      message: message ?? 'Transaction réussie',
      transaction: transaction,
    );
  }

  factory TransferResult.failure(String message, {dynamic error}) {
    return TransferResult(
      isSuccess: false,
      message: message,
      error: error,
    );
  }
}

class TransactionService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final double MONTHLY_LIMIT = 200000;

  // Obtenir un utilisateur par téléphone
  Future<UserModel?> _getUserByPhone(String phone) async {
    try {
      final DatabaseEvent event = await _db.child('users')
          .orderByChild('telephone')
          .equalTo(phone)
          .once();

      if (!event.snapshot.exists || event.snapshot.value == null) {
        return null;
      }

      final values = event.snapshot.value as Map;
      final userData = Map<String, dynamic>.from(values.values.first);
      return UserModel.fromJson(userData);

    } catch (e) {
      print('Erreur recherche utilisateur: $e');
      return null;
    }
  }

  // Validation de transaction
  Future<TransferResult> validateTransaction({
    required UserModel sender,
    required String receiverPhone,
    required double amount,
  }) async {
    try {
      // Vérifier destinataire
      final receiver = await _getUserByPhone(receiverPhone);
      if (receiver == null) {
        return TransferResult.failure('Numéro de téléphone non trouvé');
      }

      // Vérifier envoi à soi-même
      if (sender.telephone == receiverPhone) {
        return TransferResult.failure('Impossible d\'effectuer une transaction vers soi-même');
      }

      // Vérifier solde
      if (sender.solde! < amount) {
        return TransferResult.failure('Solde insuffisant');
      }

      // Vérifier plafond
      if (sender.roleId == 2) {
        final monthlyTotal = await getMonthlyTransactionTotal(sender.id!);
        if (monthlyTotal + amount > MONTHLY_LIMIT) {
          return TransferResult.failure(
            'Cette transaction dépasserait votre plafond mensuel de ${MONTHLY_LIMIT.toStringAsFixed(2)} FCFA'
          );
        }
      }

      return TransferResult.success(message: 'Validation réussie');
    } catch (e) {
      return TransferResult.failure('Erreur lors de la validation', error: e);
    }
  }

  // Calcul total mensuel
  Future<double> getMonthlyTransactionTotal(String userId) async {
    try {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      
      final DatabaseEvent event = await _db.child('transactions')
          .orderByChild('sender_id')
          .equalTo(userId)
          .once();

      if (!event.snapshot.exists) return 0;

      double total = 0;
      final values = event.snapshot.value as Map;
      values.forEach((key, value) {
        if (value != null) {
          final transaction = TransactionModel.fromJson(Map<String, dynamic>.from(value));
          if (transaction.createdAt.isAfter(firstDayOfMonth) && 
              transaction.status == TransactionStatus.COMPLETED) {
            total += transaction.amount;
          }
        }
      });

      return total;
    } catch (e) {
      print('Erreur calcul mensuel: $e');
      return 0;
    }
  }

  // Faire un transfert
  Future<TransferResult> makeTransfer({
    required UserModel sender,
    required String receiverPhone,
    required double amount,
  }) async {
    try {
      // Validation
      final validation = await validateTransaction(
        sender: sender,
        receiverPhone: receiverPhone,
        amount: amount,
      );

      if (!validation.isSuccess) {
        return validation;
      }

      // Récupérer destinataire
      final receiver = await _getUserByPhone(receiverPhone);
      if (receiver == null) {
        return TransferResult.failure('Destinataire non trouvé');
      }

      // Créer la transaction
      final newRef = _db.child('transactions').push();
      final transaction = TransactionModel(
        id: newRef.key,
        type: TransactionType.TRANSFER,
        amount: amount,
        createdAt: DateTime.now(),
        status: TransactionStatus.PENDING,
        senderId: sender.id!,
        receiverId: receiver.id!,
        senderPhone: sender.telephone,
        receiverPhone: receiver.telephone,
      );

      // Sauvegarder et exécuter
      await newRef.set(transaction.toJson());
      
      try {
        await _updateBalances(
          senderId: sender.id!,
          receiverId: receiver.id!,
          amount: amount,
        );

        await newRef.update({
          'status': TransactionStatus.COMPLETED.toString()
        });

        return TransferResult.success(
          transaction: transaction,
          message: 'Transfert effectué avec succès'
        );
      } catch (e) {
        await newRef.update({
          'status': TransactionStatus.FAILED.toString()
        });
        throw e;
      }
    } catch (e) {
      return TransferResult.failure('Erreur lors du transfert', error: e);
    }
  }

  // Mise à jour des soldes
  Future<void> _updateBalances({
  required String senderId,
  required String receiverId,
  required double amount,
}) async {
  final senderRef = _db.child('users/$senderId/solde');
  final receiverRef = _db.child('users/$receiverId/solde');

  try {
    final senderSnapshot = await senderRef.get();
    final receiverSnapshot = await receiverRef.get();

    if (senderSnapshot.exists && receiverSnapshot.exists) {
      double senderBalance = (senderSnapshot.value as num).toDouble();
      double receiverBalance = (receiverSnapshot.value as num).toDouble();

      // Mettre à jour Firebase
      await senderRef.set(senderBalance - amount);
      await receiverRef.set(receiverBalance + amount);

      // Mettre à jour l'utilisateur courant si c'est l'expéditeur
      final currentUser = AuthService.to.getUser();
      if (currentUser?.id == senderId) {
        currentUser?.solde = senderBalance - amount;
        AuthService.to.setUser(currentUser!);
      }
    }
  } catch (e) {
    print('Erreur mise à jour soldes: $e');
    throw e;
  }
}

  // Vérifier possibilité d'annulation
  bool canCancelTransaction(TransactionModel transaction) {
    final now = DateTime.now();
    final timeDifference = now.difference(transaction.createdAt);
    return timeDifference.inMinutes <= 30 && 
           transaction.status == TransactionStatus.COMPLETED;
  }

  // Annuler une transaction
  Future<TransferResult> cancelTransaction(String transactionId) async {
    try {
      final snapshot = await _db.child('transactions/$transactionId').get();

      if (!snapshot.exists) {
        return TransferResult.failure('Transaction non trouvée');
      }

      final transactionData = Map<String, dynamic>.from(snapshot.value as Map);
      final transaction = TransactionModel.fromJson(transactionData);

      if (!canCancelTransaction(transaction)) {
        return TransferResult.failure(
          'Cette transaction ne peut plus être annulée (délai de 30 minutes dépassé)'
        );
      }

      await _updateBalances(
        senderId: transaction.receiverId,
        receiverId: transaction.senderId,
        amount: transaction.amount,
      );

      await _db.child('transactions/$transactionId').update({
        'status': TransactionStatus.CANCELLED.toString()
      });

      return TransferResult.success(
        transaction: transaction,
        message: 'Transaction annulée avec succès'
      );
    } catch (e) {
      return TransferResult.failure('Erreur lors de l\'annulation', error: e);
    }
  }


  Future<TransferResult> validateMultipleTransfer({
  required UserModel sender,
  required List<String> receiverPhones,
  required double amountPerPerson,
}) async {
  try {
    final totalAmount = amountPerPerson * receiverPhones.length;

    // Vérifier solde total nécessaire
    if (sender.solde! < totalAmount) {
      return TransferResult.failure(
        'Solde insuffisant pour effectuer tous les transferts'
      );
    }

    // Vérifier plafond mensuel si client
    if (sender.roleId == 2) {
      final monthlyTotal = await getMonthlyTransactionTotal(sender.id!);
      if (monthlyTotal + totalAmount > MONTHLY_LIMIT) {
        return TransferResult.failure(
          'Cette transaction dépasserait votre plafond mensuel'
        );
      }
    }

    // Vérifier chaque destinataire
    for (String phone in receiverPhones) {
      if (phone == sender.telephone) {
        return TransferResult.failure(
          'Vous ne pouvez pas vous inclure dans les destinataires'
        );
      }

      final receiver = await _getUserByPhone(phone);
      if (receiver == null) {
        return TransferResult.failure(
          'Numéro non trouvé: $phone'
        );
      }
    }

    return TransferResult.success(message: 'Validation réussie');
  } catch (e) {
    return TransferResult.failure('Erreur de validation', error: e);
  }
}

// Effectuer un transfert multiple

Future<TransferResult> makeMultipleTransfer({
  required UserModel sender,
  required List<String> receiverPhones,
  required double amountPerPerson,
}) async {
  try {
    // Validation
    final validation = await validateMultipleTransfer(
      sender: sender,
      receiverPhones: receiverPhones,
      amountPerPerson: amountPerPerson,
    );

    if (!validation.isSuccess) {
      return validation;
    }

    List<String> successfulTransfers = [];
    List<String> failedTransfers = [];

    // Effectuer chaque transfert individuel
    for (String phone in receiverPhones) {
      try {
        final result = await makeTransfer(
          sender: sender,
          receiverPhone: phone,
          amount: amountPerPerson,
        );

        if (result.isSuccess) {
          successfulTransfers.add(phone);
        } else {
          failedTransfers.add(phone);
        }
      } catch (e) {
        failedTransfers.add(phone);
        print('Erreur pour le destinataire $phone: $e');
      }
    }

    if (failedTransfers.isEmpty) {
      return TransferResult.success(
        message: 'Tous les transferts ont été effectués avec succès'
      );
    } else {
      return TransferResult.success(
        message: 'Certains transferts ont échoué: ${failedTransfers.join(", ")}'
      );
    }

  } catch (e) {
    return TransferResult.failure('Erreur lors du transfert multiple', error: e);
  }
}




Future<TransferResult> createScheduledTransfer({
  required UserModel sender,
  required String receiverPhone,
  required double amount,
  required DateTime startDate,
  required DateTime endDate,
  required String interval, // 'daily', 'weekly', 'monthly'
}) async {
  try {
    // Validation de base
    final validation = await validateTransaction(
      sender: sender,
      receiverPhone: receiverPhone,
      amount: amount,
    );

    if (!validation.isSuccess) {
      return validation;
    }

    // Vérifier les dates
    if (startDate.isBefore(DateTime.now())) {
      return TransferResult.failure('La date de début doit être future');
    }

    if (endDate.isBefore(startDate)) {
      return TransferResult.failure('La date de fin doit être après la date de début');
    }

    // Calculer dates d'exécution
    List<DateTime> executionDates = _calculateExecutionDates(
      startDate: startDate,
      endDate: endDate,
      interval: interval,
    );

    // Vérifier le montant total par rapport au plafond
    if (sender.roleId == 2) {
      final totalAmount = amount * executionDates.length;
      if (totalAmount > MONTHLY_LIMIT) {
        return TransferResult.failure(
          'Le montant total des transferts planifiés dépasse le plafond mensuel'
        );
      }
    }

    // Créer la planification
    final scheduleRef = _db.child('scheduled_transfers').push();
    final scheduledTransfer = {
      'sender_id': sender.id,
      'sender_phone': sender.telephone,
      'receiver_phone': receiverPhone,
      'amount': amount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'interval': interval,
      'execution_dates': executionDates.map((d) => d.toIso8601String()).toList(),
      'status': 'ACTIVE',
      'created_at': DateTime.now().toIso8601String(),
    };

    await scheduleRef.set(scheduledTransfer);

    return TransferResult.success(
      message: 'Transfert planifié créé avec succès'
    );
  } catch (e) {
    return TransferResult.failure('Erreur lors de la création du transfert planifié', error: e);
  }
}

// Calculer les dates d'exécution
List<DateTime> _calculateExecutionDates({
  required DateTime startDate,
  required DateTime endDate,
  required String interval,
}) {
  List<DateTime> dates = [];
  DateTime currentDate = startDate;

  while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    dates.add(currentDate);
    
    switch (interval.toLowerCase()) {
      case 'daily':
        currentDate = currentDate.add(const Duration(days: 1));
        break;
      case 'weekly':
        currentDate = currentDate.add(const Duration(days: 7));
        break;
      case 'monthly':
        currentDate = DateTime(
          currentDate.year,
          currentDate.month + 1,
          currentDate.day,
        );
        break;
      default:
        break;
    }
  }

  return dates;
}

// Annuler un transfert planifié
Future<TransferResult> cancelScheduledTransfer(String scheduleId) async {
  try {
    final ref = _db.child('scheduled_transfers/$scheduleId');
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      return TransferResult.failure('Planification non trouvée');
    }

    await ref.update({'status': 'CANCELLED'});

    return TransferResult.success(
      message: 'Transfert planifié annulé avec succès'
    );
  } catch (e) {
    return TransferResult.failure('Erreur lors de l\'annulation', error: e);
  }
}

Future<List<TransactionModel>> getRecentTransactions(String userId) async {
  try {
    final DatabaseEvent event = await _db.child('transactions')
        .orderByChild('created_at')  // Ordonner par date de création
        .limitToLast(10)  // Limiter aux 10 dernières
        .once();

    if (!event.snapshot.exists) return [];

    final transactions = <TransactionModel>[];
    final data = Map<String, dynamic>.from(event.snapshot.value as Map);
    
    // Convertir en liste de transactions
    data.forEach((key, value) {
      if (value != null) {
        final transaction = TransactionModel.fromJson(Map<String, dynamic>.from(value));
        // Ne garder que les transactions où l'utilisateur est impliqué
        if (transaction.senderId == userId || transaction.receiverId == userId) {
          transactions.add(transaction);
        }
      }
    });

    // Trier par date décroissante (plus récent au plus ancien)
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return transactions;
  } catch (e) {
    print('Erreur chargement transactions: $e');
    return [];
  }
}

 // Méthode pour effectuer une transaction (dépôt/retrait)
  Future<TransferResult> makeTransaction(
      {required TransactionModel transaction}) async {
    try {
      // Vérifier si c'est un dépôt ou retrait
      final isDeposit = transaction.type == TransactionType.DEPOSIT;
      final clientPhone = isDeposit ? transaction.receiverPhone : transaction.senderPhone;

      // Récupérer le client
      final client = await _getUserByPhone(clientPhone!);
      if (client == null) {
        return TransferResult.failure('Client non trouvé');
      }

      // Mettre à jour les ID manquants
      if (isDeposit) {
        transaction = transaction.copyWith(receiverId: client.id);
      } else {
        transaction = transaction.copyWith(senderId: client.id);
      }

      // Sauvegarder la transaction
      final newRef = _db.child('transactions').push();
      transaction = transaction.copyWith(id: newRef.key);
      await newRef.set(transaction.toJson());

      try {
        // Mise à jour des soldes
        if (isDeposit) {
          await _updateBalances(
            senderId: transaction.senderId,  // Agent
            receiverId: client.id!,          // Client
            amount: transaction.amount,
          );
        } else {
          await _updateBalances(
            senderId: client.id!,            // Client
            receiverId: transaction.receiverId,  // Agent
            amount: transaction.amount,
          );
        }

        await newRef.update({
          'status': TransactionStatus.COMPLETED.toString()
        });

        return TransferResult.success(
          transaction: transaction,
          message: '${isDeposit ? "Dépôt" : "Retrait"} effectué avec succès'
        );
      } catch (e) {
        await newRef.update({
          'status': TransactionStatus.FAILED.toString()
        });
        throw e;
      }
    } catch (e) {
      return TransferResult.failure('Erreur lors de la transaction: $e');
    }
  }

  // Méthode pour obtenir le solde d'un client
  Future<double> getClientBalance(String phone) async {
    try {
      final client = await _getUserByPhone(phone);
      if (client == null) {
        throw 'Client non trouvé';
      }
      return client.solde ?? 0;
    } catch (e) {
      print('Erreur lors de la récupération du solde: $e');
      throw e;
    }
  }

}