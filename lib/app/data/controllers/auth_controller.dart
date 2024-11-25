// lib/app/data/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  final UserProvider _userProvider = UserProvider();
  final RxBool isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final storage = GetStorage();

  Future<bool> loginWithPhone(String phone) async {
    try {
      isLoading.value = true;
      print('Tentative de connexion avec le numéro: $phone');

      final users = await _userProvider.getAllUsers();
      print('Nombre d\'utilisateurs trouvés: ${users.length}');
      
      // Afficher tous les numéros de téléphone pour déboguer
      users.forEach((user) {
        print('User dans la BD: ${user.telephone}');
      });

      final user = users.firstWhereOrNull(
        (user) => user.telephone == phone
      );

      print('Utilisateur trouvé: ${user?.nom ?? "Aucun"}');

      if (user != null) {
        currentUser.value = user;
        await storage.write('userId', user.id);
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur de connexion: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    await storage.remove('userId');
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> checkAuth() async {
    final userId = storage.read('userId');
    if (userId != null) {
      final user = await _userProvider.getUser(userId.toString());
      if (user != null) {
        currentUser.value = user;
        Get.offAllNamed(Routes.DASHBOARD);
      }
    }
  }
}