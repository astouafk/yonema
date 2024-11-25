// lib/app/modules/dashboard/bindings/dashboard_binding.dart
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../transfer/controllers/transfer_controller.dart';  // Ajoutez cette ligne

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
      
    );

     Get.lazyPut<TransferController>(
      () => TransferController(),
    );
  }
}