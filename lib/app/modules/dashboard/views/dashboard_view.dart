// // lib/app/modules/dashboard/views/dashboard_view.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../dashboard/controllers/dashboard_controller.dart';

// class DashboardView extends GetView<DashboardController> {
//   const DashboardView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: controller.logout,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Bienvenue ${controller.user.value.prenom} ${controller.user.value.nom}',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Téléphone: ${controller.user.value.telephone}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Solde: ${controller.user.value.solde?.toStringAsFixed(2)} FCFA',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
// }


// lib/app/modules/dashboard/views/dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'client_dashboard_view.dart';
import 'agent_dashboard_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isClient.value) {
        return ClientDashboardView();
      } else if (controller.isAgent.value) {
        return AgentDashboardView();
      } else {
        return Scaffold(
          body: Center(
            child: Text('Rôle non reconnu'),
          ),
        );
      }
    });
  }
}