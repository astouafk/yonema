// // import 'package:get/get.dart';
// // import '../../../data/providers/user_provider.dart';

// // class HomeController extends GetxController {
// //   //TODO: Implement HomeController

// //   final count = 0.obs;
// //   @override
// // void onInit() {
// //   super.onInit();
// //   print("DEBUG: HomeController onInit starting");
// //   UserProvider().getAllUsers().then((users) {
// //     print("DEBUG: Got response from getAllUsers");
// //     print("Nombre d'utilisateurs : ${users.length}");
// //     // Pour voir les données d'un utilisateur
// //     if (users.isNotEmpty) {
// //       print("Premier utilisateur : ${users.first.nom} ${users.first.prenom}");
// //     }
// //   }).catchError((error) {
// //     print("DEBUG: Error getting users: $error");
// //   });
// //   print("DEBUG: HomeController onInit completed");
// // }

// //   @override
// //   void onReady() {
// //     super.onReady();
// //   }

// //   @override
// //   void onClose() {
// //     super.onClose();
// //   }

// //   void increment() => count.value++;
// // }


// import 'package:get/get.dart';
// import '../../../data/providers/user_provider.dart';
// import '../../../data/models/user_model.dart';

// class HomeController extends GetxController {
//   final userProvider = UserProvider();
//   final users = <UserModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     print("=== Début chargement des utilisateurs ===");
//     loadUsers();
//   }

//   Future<void> loadUsers() async {
//     try {
//       final allUsers = await userProvider.getAllUsers();
//       users.value = allUsers;
//       print("Nombre d'utilisateurs trouvés: ${allUsers.length}");
//       for (var user in allUsers) {
//         print("Utilisateur: ${user.nom} ${user.prenom}");
//       }
//     } catch (e) {
//       print("Erreur lors du chargement des utilisateurs: $e");
//     }
//   }
// }

// lib/app/modules/home/controllers/home_controller.dart
import 'package:get/get.dart';

class HomeController extends GetxController {
  void goToLogin() {
    Get.toNamed('/login');
  }

  void goToRegister() {
    // Pour plus tard
    // Get.toNamed('/register');
  }
}