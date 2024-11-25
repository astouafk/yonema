// lib/app/modules/dashboard/controllers/dashboard_controller.dart
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/services/transaction_service.dart';
import '../../../data/enums/transaction_enums.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/transaction_service.dart';


class DashboardController extends GetxController {
  final TransactionService _transactionService = TransactionService();
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  
  late Rx<UserModel> user;
  final RxBool isSoldeVisible = true.obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isClient = false.obs;
  final RxBool isAgent = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user = (Get.arguments as UserModel).obs;
    AuthService.to.setUser(user.value);  // Sauvegarder l'utilisateur

    _initializeRole();
    loadTransactions();
  }

  void _initializeRole() {
    isClient.value = user.value.roleId == 2;
    isAgent.value = user.value.roleId == 3;
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      if (isClient.value) {
        await _loadClientTransactions();
      } else if (isAgent.value) {
        await _loadAgentTransactions();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadClientTransactions() async {
  final clientTransactions = await _transactionService.getRecentTransactions(user.value.id!);
  // Pas besoin de trier à nouveau car déjà trié dans le service
  transactions.assignAll(clientTransactions);
}

//  Future<void> _loadAgentTransactions() async {
//   final agentTransactions = await _transactionService.getRecentTransactions(user.value.id!);
//   transactions.assignAll(agentTransactions);
// }

  void toggleSoldeVisibility() {
    isSoldeVisible.toggle();
  }

  void logout() {
    Get.offAllNamed('/home');
  }

  // Méthodes utilitaires pour vérifier les types de transactions
  bool isDepositOrWithdrawal(TransactionModel transaction) {
    return transaction.type == TransactionType.DEPOSIT || 
           transaction.type == TransactionType.WITHDRAWAL;
  }

  bool isTransfer(TransactionModel transaction) {
    return transaction.type == TransactionType.TRANSFER || 
           transaction.type == TransactionType.MULTI_TRANSFER ||
           transaction.type == TransactionType.SCHEDULED_TRANSFER;
  }

  // Méthode pour recharger les données
  // Future<void> refreshData() async {
  //   await loadTransactions();
  // }

 
   void refreshDashboard() async {
    // Recharger les transactions
    await loadTransactions();
    
    // Recharger le solde de l'utilisateur
    final updatedUser = await _getUserData(user.value.id!);
    if (updatedUser != null) {
      user.value = updatedUser;
      AuthService.to.setUser(updatedUser); // Mettre à jour aussi dans AuthService
    }
  }

  Future<UserModel?> _getUserData(String userId) async {
    try {
      final snapshot = await _db.child('users/$userId').get();
      if (snapshot.exists) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(snapshot.value as Map)
        );
      }
    } catch (e) {
      print('Erreur lors du rechargement des données utilisateur: $e');
    }
    return null;
  }

  Future<void> _loadAgentTransactions() async {
  final agentTransactions = await _transactionService.getRecentTransactions(user.value.id!);
  transactions.assignAll(
    agentTransactions.where((t) => 
      t.type == TransactionType.DEPOSIT || 
      t.type == TransactionType.WITHDRAWAL
    ).toList()
  );
}

final RxDouble dailyDeposits = 0.0.obs;
  final RxDouble dailyWithdrawals = 0.0.obs;

  // Méthode pour calculer les statistiques du jour
  Future<void> calculateDailyStats() async {
    if (!isAgent.value) return;

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    double deposits = 0;
    double withdrawals = 0;

    for (var transaction in transactions) {
      if (transaction.createdAt.isAfter(startOfDay)) {
        if (transaction.type == TransactionType.DEPOSIT) {
          deposits += transaction.amount;
        } else if (transaction.type == TransactionType.WITHDRAWAL) {
          withdrawals += transaction.amount;
        }
      }
    }

    dailyDeposits.value = deposits;
    dailyWithdrawals.value = withdrawals;
  }

   void _calculateDailyStats() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    double deposits = 0;
    double withdrawals = 0;

    for (var transaction in transactions) {
      if (transaction.createdAt.isAfter(startOfDay)) {
        if (transaction.type == TransactionType.DEPOSIT) {
          deposits += transaction.amount;
        } else if (transaction.type == TransactionType.WITHDRAWAL) {
          withdrawals += transaction.amount;
        }
      }
    }

    dailyDeposits.value = deposits;
    dailyWithdrawals.value = withdrawals;
  }

    @override
  Future<void> refreshData() async {
    await loadTransactions();  // Gardons l'appel existant
    if (isAgent.value) {
      _calculateDailyStats();  // Ajout du calcul des stats après le chargement
    }
  }

}