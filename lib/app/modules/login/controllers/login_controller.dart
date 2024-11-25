// // lib/app/modules/login/controllers/login_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../data/services/firebase_service.dart';
// import '../../../routes/app_pages.dart';

// class LoginController extends GetxController {
//   final FirebaseService _firebaseService = FirebaseService();
//   final phoneController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   final RxBool isLoading = false.obs;

//   Future<void> handlePhoneLogin() async {
//     if (!formKey.currentState!.validate()) return;

//     isLoading.value = true;
//     final user = await _firebaseService.loginWithPhone(phoneController.text.trim());
//     isLoading.value = false;

//     if (user != null) {
//       Get.offAllNamed(Routes.DASHBOARD, arguments: user);
//     } else {
//       Get.snackbar(
//         'Erreur',
//         'Numéro de téléphone non trouvé',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   String? validatePhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer un numéro de téléphone';
//     }
//     if (!RegExp(r'^(70|75|76|77|78)[0-9]{7}$').hasMatch(value)) {
//       return 'Format invalide (7X XXX XX XX)';
//     }
//     return null;
//   }

//   @override
//   void onClose() {
//     phoneController.dispose();
//     super.onClose();
//   }
// }




// lib/app/modules/login/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;

  Future<void> handlePhoneLogin() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final user = await _firebaseService.loginWithPhone(
      phoneController.text.trim(),
      pinController.text.trim()
    );
    isLoading.value = false;

    if (user != null) {
      Get.offAllNamed(Routes.DASHBOARD, arguments: user);
    } else {
      Get.snackbar(
        'Erreur',
        'Téléphone ou code PIN incorrect',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre code PIN';
    }
    if (value.length != 6) {
      return 'Le code PIN doit contenir 6 chiffres';
    }
    return null;
  }

  Future<void> handleGoogleLogin() async {
    try {
      isLoading.value = true;
      final user = await _firebaseService.signInWithGoogle();
      isLoading.value = false;

      if (user != null) {
        Get.offAllNamed(Routes.DASHBOARD, arguments: user);
      } else {
        Get.snackbar(
          'Erreur',
          'Compte Google non trouvé',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Erreur',
        'Erreur de connexion Google',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un numéro de téléphone';
    }
    if (!RegExp(r'^(70|75|76|77|78)[0-9]{7}$').hasMatch(value)) {
      return 'Format invalide (7X XXX XX XX)';
    }
    return null;
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> handleFacebookLogin() async {
  try {
    isLoading.value = true;
    print('Début de la tentative de connexion Facebook');
    
    final user = await _firebaseService.signInWithFacebook();
    
    if (user != null) {
      print('Connexion réussie pour: ${user.nom} ${user.prenom}');
      Get.offAllNamed(Routes.DASHBOARD, arguments: user);
    } else {
      print('Aucun utilisateur trouvé');
      Get.snackbar(
        'Erreur',
        'Compte Facebook non associé à un compte existant',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print('Erreur dans handleFacebookLogin: $e');
    Get.snackbar(
      'Erreur',
      'Erreur lors de la connexion Facebook',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}
}