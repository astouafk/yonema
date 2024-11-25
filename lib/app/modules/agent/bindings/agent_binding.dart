// lib/app/modules/agent/bindings/agent_binding.dart
import 'package:get/get.dart';
import '../controllers/agent_controller.dart';

class AgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AgentController());
  }
}