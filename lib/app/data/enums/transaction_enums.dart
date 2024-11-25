// lib/app/data/enums/transaction_enums.dart
enum TransactionType {
  TRANSFER,         // Transfert simple
  MULTI_TRANSFER,   // Transfert multiple
  SCHEDULED_TRANSFER, // Transfert planifié
  DEPOSIT,          // Dépôt
  WITHDRAWAL,       // Retrait
  PLAFOND_REQUEST   // Demande déplafonnement
}

enum TransactionStatus {
  PENDING,    // En attente
  COMPLETED,  // Effectué
  CANCELLED,  // Annulé
  FAILED,      // Échoué
  PARTIALLY_COMPLETED
}

enum ScheduleInterval {
  DAILY,
  WEEKLY,
  MONTHLY
}
