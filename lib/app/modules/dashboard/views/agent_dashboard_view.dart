// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/dashboard_controller.dart';
// import '../../../utils/permission_handler.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../../../routes/app_pages.dart';

// class AgentDashboardView extends GetView<DashboardController> {
//   const AgentDashboardView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.blue,
//         title: Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Dashboard Agent',
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         )),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 8),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.logout),
//                   onPressed: controller.logout,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(context),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildBalanceCard(),
//                 const SizedBox(height: 24),
//                 _buildAgentActions(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBalanceCard() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Solde actuel',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Obx(() => Text(
//                     controller.isSoldeVisible.value
//                         ? '${controller.user.value.solde?.toStringAsFixed(2)} FCFA'
//                         : '• • • • • •',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   )),
//                   IconButton(
//                     icon: Obx(() => Icon(
//                       controller.isSoldeVisible.value
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     )),
//                     onPressed: controller.toggleSoldeVisibility,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey[300]!),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: QrImageView(
//                   data: controller.user.value.telephone ?? '',
//                   size: 100,
//                   version: QrVersions.auto,
//                   backgroundColor: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAgentActions() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Text(
//         'Actions rapides',
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       const SizedBox(height: 16),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildActionButton(
//             icon: Icons.add,
//             label: 'Dépôt',
//             onTap: () => Get.toNamed(Routes.AGENT_DEPOSIT),
//           ),
//           _buildActionButton(
//             icon: Icons.remove,
//             label: 'Retrait',
//             onTap: () => Get.toNamed(Routes.AGENT_WITHDRAWAL),
//           ),
//           _buildActionButton(
//             icon: Icons.qr_code_scanner,
//             label: 'Scanner',
//             onTap: _scanQRCode,
//           ),
//         ],
//       ),
//     ],
//   );
// }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return SizedBox(
//       width: 100,
//       child: InkWell(
//         onTap: onTap,
//         child: Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 Icon(icon, size: 32, color: Colors.blue),
//                 const SizedBox(height: 8),
//                 Text(
//                   label,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: SafeArea(
//         child: ListView(
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Obx(() => Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 40,
//                     child: Icon(Icons.person, size: 40, color: Colors.blue),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${controller.user.value.prenom} ${controller.user.value.nom}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               )),
//             ),
//             ListTile(
//               leading: const Icon(Icons.add),
//               title: const Text('Dépôt'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.remove),
//               title: const Text('Retrait'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.qr_code),
//               title: const Text('Mon QR Code'),
//               onTap: () => _showQRCode(context),
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
//               onTap: controller.logout,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _scanQRCode() async {
//     bool hasPermission = await PermissionHandler.handleCameraPermission();
//     if (hasPermission) {
//       Get.toNamed('/qr-scanner');
//     }
//   }

//   void _showQRCode(BuildContext context) {
//     Get.dialog(
//       Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Mon QR Code',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey[300]!),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: QrImageView(
//                   data: controller.user.value.telephone ?? '',
//                   version: QrVersions.auto,
//                   size: 200,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 controller.user.value.telephone ?? '',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () => Get.back(),
//                 child: const Text('Fermer'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/permission_handler.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/enums/transaction_enums.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AgentDashboardView extends GetView<DashboardController> {
  const AgentDashboardView({Key? key}) : super(key: key);

  String formatDate(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${pad(date.day)}/${pad(date.month)}/${date.year} ${pad(date.hour)}:${pad(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agent : ${controller.user.value.prenom}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              controller.user.value.telephone ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => controller.refreshData(),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: controller.logout,
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Solde et QR Code
              _buildBalanceCard(),

              // Stats du jour
              _buildDailyStats(),

              // Actions rapides
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actions rapides',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.add_circle_outline,
                          label: 'Dépôt',
                          color: Colors.green,
                          onTap: () => Get.toNamed(Routes.AGENT_DEPOSIT),
                        ),
                        _buildActionButton(
                          icon: Icons.remove_circle_outline,
                          label: 'Retrait',
                          color: Colors.orange,
                          onTap: () => Get.toNamed(Routes.AGENT_WITHDRAWAL),
                        ),
                        _buildActionButton(
                          icon: Icons.qr_code_scanner,
                          label: 'Scanner',
                          color: Colors.blue,
                          onTap: _scanQRCode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Liste des transactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Transactions récentes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigation vers l'historique complet
                      },
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              ),

              _buildTransactionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade500, Colors.blue.shade700],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solde actuel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      controller.isSoldeVisible.value
                          ? '${controller.user.value.solde?.toStringAsFixed(2)} FCFA'
                          : '• • • • • •',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
                    IconButton(
                      icon: Obx(() => Icon(
                        controller.isSoldeVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      )),
                      onPressed: controller.toggleSoldeVisibility,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: controller.user.value.telephone ?? '',
                  size: 100,
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Dépôts du jour',
              '${controller.dailyDeposits.value.toStringAsFixed(2)} FCFA',
              Icons.arrow_circle_up,
              Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Retraits du jour',
              '${controller.dailyWithdrawals.value.toStringAsFixed(2)} FCFA',
              Icons.arrow_circle_down,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.transactions.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune transaction',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.transactions.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          return _buildTransactionTile(transaction);
        },
      );
    });
  }

  Widget _buildTransactionTile(TransactionModel transaction) {
    final isDeposit = transaction.type == TransactionType.DEPOSIT;
    final color = isDeposit ? Colors.green : Colors.orange;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDeposit ? Icons.arrow_circle_up : Icons.arrow_circle_down,
            color: color,
          ),
        ),
        title: Text(
          isDeposit 
              ? 'Dépôt pour ${transaction.receiverPhone}'
              : 'Retrait par ${transaction.senderPhone}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(formatDate(transaction.createdAt)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.amount.toStringAsFixed(2)} FCFA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction.status.toString().split('.').last,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${controller.user.value.prenom} ${controller.user.value.nom}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    controller.user.value.telephone ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              )),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Dépôt'),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.AGENT_DEPOSIT);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('Retrait'),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.AGENT_WITHDRAWAL);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Mon QR Code'),
              onTap: () {
                Get.back();
                _showQRCode(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historique'),
              onTap: () {
                Get.back();
                // Navigation vers l'historique
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.red)
              ),
              onTap: controller.logout,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanQRCode() async {
    bool hasPermission = await PermissionHandler.handleCameraPermission();
    if (hasPermission) {
      Get.toNamed('/qr-scanner');
    }
  }

    void _showQRCode(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mon QR Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: controller.user.value.telephone ?? '',
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                controller.user.value.telephone ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${controller.user.value.prenom} ${controller.user.value.nom}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Partager'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Info',
                    'Fonctionnalité de partage à venir',
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
