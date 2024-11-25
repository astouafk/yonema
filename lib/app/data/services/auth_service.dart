// lib/app/data/services/auth_service.dart
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  void setUser(UserModel user) {
    currentUser.value = user;
  }

  UserModel? getUser() {
    return currentUser.value;
  }

  bool get isLoggedIn => currentUser.value != null;
}