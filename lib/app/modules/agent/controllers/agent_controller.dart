// lib/app/modules/agent/controllers/agent_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/services/transaction_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/enums/transaction_enums.dart';

class AgentController extends GetxController {
  final TransactionService _transactionService = TransactionService();
  
  // Contrôleurs de texte
  final clientPhoneController = TextEditingController();
  final amountController = TextEditingController();

  // États observables
  final RxBool isLoading = false.obs;
  final RxBool canSubmit = false.obs;
  final RxString error = ''.obs;
  final RxString successMessage = ''.obs;

  // Utilisateur actuel (l'agent)
  UserModel? get currentAgent => AuthService.to.getUser();

  @override
  void onInit() {
    super.onInit();
    // Écouter les changements dans les champs
    _setupListeners();
  }

  void _setupListeners() {
    clientPhoneController.addListener(_validateInputs);
    amountController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final phone = clientPhoneController.text.trim();
    final amount = double.tryParse(amountController.text) ?? 0;

    canSubmit.value = _isValidPhone(phone) && amount > 0;
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^(70|75|76|77|78)[0-9]{7}$').hasMatch(phone);
  }

  // Méthode pour le dépôt
  Future<void> makeDeposit() async {
    if (!canSubmit.value) return;
    
    try {
      isLoading.value = true;
      error.value = '';
      successMessage.value = '';

      final clientPhone = clientPhoneController.text.trim();
      final amount = double.parse(amountController.text);

      // Vérifier le solde de l'agent pour le dépôt
      if (currentAgent?.solde != null && currentAgent!.solde! < amount) {
        error.value = 'Solde insuffisant pour effectuer ce dépôt';
        return;
      }

      final result = await _transactionService.makeTransaction(
        transaction: TransactionModel(
          type: TransactionType.DEPOSIT,
          amount: amount,
          createdAt: DateTime.now(),
          status: TransactionStatus.PENDING,
          senderId: currentAgent!.id!,
          receiverId: '', // Sera rempli par le service
          senderPhone: currentAgent!.telephone,
          receiverPhone: clientPhone,
        ),
      );

      if (result.isSuccess) {
        successMessage.value = 'Dépôt effectué avec succès';
        _clearForm();
        Get.back(); // Retour à la vue précédente
        Get.snackbar(
          'Succès',
          'Dépôt effectué avec succès',
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

  // Méthode pour le retrait
  Future<void> makeWithdrawal() async {
    if (!canSubmit.value) return;
    
    try {
      isLoading.value = true;
      error.value = '';
      successMessage.value = '';

      final clientPhone = clientPhoneController.text.trim();
      final amount = double.parse(amountController.text);

      // Vérifier le solde du client avant le retrait
      final clientBalance = await _transactionService.getClientBalance(clientPhone);
      if (clientBalance < amount) {
        error.value = 'Solde client insuffisant pour ce retrait';
        return;
      }

      final result = await _transactionService.makeTransaction(
        transaction: TransactionModel(
          type: TransactionType.WITHDRAWAL,
          amount: amount,
          createdAt: DateTime.now(),
          status: TransactionStatus.PENDING,
          senderId: '', // Sera rempli par le service
          receiverId: currentAgent!.id!,
          senderPhone: clientPhone,
          receiverPhone: currentAgent!.telephone,
        ),
      );

      if (result.isSuccess) {
        successMessage.value = 'Retrait effectué avec succès';
        _clearForm();
        Get.back(); // Retour à la vue précédente
        Get.snackbar(
          'Succès',
          'Retrait effectué avec succès',
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

  // Méthode pour gérer le scan QR
  void onQRScanned(String phone) {
    if (_isValidPhone(phone)) {
      clientPhoneController.text = phone;
      Get.back(); // Retour à la vue précédente
      Get.snackbar(
        'Succès',
        'QR Code scanné avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erreur',
        'QR Code invalide',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _clearForm() {
    clientPhoneController.clear();
    amountController.clear();
    error.value = '';
    successMessage.value = '';
  }

  @override
  void onClose() {
    clientPhoneController.dispose();
    amountController.dispose();
    super.onClose();
  }
}