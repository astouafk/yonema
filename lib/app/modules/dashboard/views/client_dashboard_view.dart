import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../data/models/transaction_model.dart';
import '../../../routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../data/enums/transaction_enums.dart';
import '../../transfer/controllers/transfer_controller.dart';  // Ajoutez cette ligne


class ClientDashboardView extends GetView<DashboardController> {
   ClientDashboardView({Key? key}) : super(key: key);
   final transferController = Get.find<TransferController>();


  // Helper method to format date
  String formatDate(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${pad(date.day)}/${pad(date.month)}/${date.year} ${pad(date.hour)}:${pad(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, ${controller.user.value.prenom}',
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
                  icon: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => _showQRCode(context),
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Carte de solde
            // Carte de solde
Card(
  elevation: 2,
  margin: const EdgeInsets.only(bottom: 20),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Partie solde
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Solde disponible',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Obx(() => IconButton(
                        icon: Icon(
                          controller.isSoldeVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: controller.toggleSoldeVisibility,
                      )),
                    ],
                  ),
                  Obx(() => Text(
                    controller.isSoldeVisible.value
                        ? '${controller.user.value.solde?.toStringAsFixed(2)} FCFA'
                        : '• • • • • •',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ],
              ),
            ),
            // QR Code
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: QrImageView(
                data: controller.user.value.telephone ?? '',
                size: 80,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Bande jaune
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(20, (index) => 
              Container(
                width: 15,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: index % 2 == 0 
                      ? Colors.black.withOpacity(0.1)
                      : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),

            // Section Actions rapides
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Actions rapides',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Boutons d'action
           SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      _buildActionButton(
        icon: Icons.send,
        label: 'Transfert',
        color: Colors.blue,
        onTap: () => Get.toNamed(Routes.TRANSFER),
      ),
      const SizedBox(width: 8),
      _buildActionButton(
        icon: Icons.group,
        label: 'Transfert\nmultiple',
        color: Colors.purple,
        onTap: () => Get.toNamed(Routes.MULTIPLE_TRANSFER),
      ),
      const SizedBox(width: 8),
      _buildActionButton(
        icon: Icons.schedule,
        label: 'Transfert\nplanifié',
        color: Colors.orange,
        onTap: () => Get.toNamed(Routes.SCHEDULED_TRANSFER),
      ),
      const SizedBox(width: 8),
      _buildActionButton(
        icon: Icons.list_alt,
        label: 'Transferts\nprogrammés',
        color: Colors.teal,
        onTap: () => Get.toNamed(Routes.SCHEDULED_TRANSFERS_LIST),
      ),
    ],
  ),
),

             SizedBox(height: 24),

            // Section Transactions récentes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transactions récentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigation vers l'historique complet
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Voir tout',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Liste des transactions
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (controller.transactions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aucune transaction récente',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: controller.transactions.map((transaction) {
                  return _buildTransactionTile(transaction);
                }).toList(),
              );
            }),
          ],
        ),
      ),
      endDrawer: _buildDrawer(),
    );
  }
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildTransactionTile(TransactionModel transaction) {
  final isTransfer = transaction.type == TransactionType.TRANSFER;
  final isSender = transaction.senderId == controller.user.value.id;
  
  // Définir la couleur et l'icône selon le type de transaction
  Color getTransactionColor() {
    if (transaction.type == TransactionType.DEPOSIT) return Colors.green;
    if (transaction.type == TransactionType.WITHDRAWAL) return Colors.orange;
    return isSender ? Colors.red : Colors.green; // Pour les transferts
  }

  IconData getTransactionIcon() {
    switch (transaction.type) {
      case TransactionType.DEPOSIT:
        return Icons.arrow_circle_down;
      case TransactionType.WITHDRAWAL:
        return Icons.arrow_circle_up;
      case TransactionType.TRANSFER:
        return isSender ? Icons.arrow_upward : Icons.arrow_downward;
      default:
        return Icons.swap_horiz;
    }
  }

  String getTransactionLabel() {
    switch (transaction.type) {
      case TransactionType.DEPOSIT:
        return 'Dépôt par agent ${transaction.senderPhone}';
      case TransactionType.WITHDRAWAL:
        return 'Retrait chez agent ${transaction.receiverPhone}';
      case TransactionType.TRANSFER:
        return isSender 
            ? 'Envoyé à ${transaction.receiverPhone}'
            : 'Reçu de ${transaction.senderPhone}';
      default:
        return 'Transaction';
    }
  }

  final color = getTransactionColor();

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      dense: true,
      minLeadingWidth: 20,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          getTransactionIcon(),
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        getTransactionLabel(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        formatDate(transaction.createdAt),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${transaction.amount.toStringAsFixed(2)} FCFA',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              transaction.status.toString().split('.').last,
              style: TextStyle(
                fontSize: 10,
                color: _getStatusColor(transaction.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  void _showCancelConfirmation(TransactionModel transaction, TransferController transferController) {
  Get.dialog(
    AlertDialog(
      title: const Text('Annuler la transaction'),
      content: const Text(
        'Êtes-vous sûr de vouloir annuler cette transaction ? Cette action est irréversible.'
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Non'),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            // Afficher un indicateur de chargement
            Get.dialog(
              const Center(child: CircularProgressIndicator()),
              barrierDismissible: false,
            );
            
            // Tenter d'annuler la transaction
            final result = await transferController.cancelTransaction(transaction.id!);
            
            // Fermer l'indicateur de chargement
            Get.back();

            // Rafraîchir les données du dashboard immédiatement
            await controller.refreshData();  // Ajouter cette ligne

             if (result.isSuccess) {
              // Utiliser refreshDashboard qui est maintenant correctement typé
              await controller.refreshData();
            }
    
            
            
            // Afficher le résultat
            Get.snackbar(
              result.isSuccess ? 'Succès' : 'Erreur',
              result.message,
              backgroundColor: result.isSuccess ? Colors.green : Colors.red,
              colorText: Colors.white,
            );
          },
          child: const Text(
            'Oui, annuler',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.COMPLETED:
        return Colors.green;
      case TransactionStatus.PENDING:
        return Colors.orange;
      case TransactionStatus.FAILED:
        return Colors.red;
      case TransactionStatus.CANCELLED:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      '${controller.user.value.prenom?[0]}${controller.user.value.nom?[0]}'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${controller.user.value.prenom} ${controller.user.value.nom}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
              leading: const Icon(Icons.send),
              title: const Text('Transfert'),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.TRANSFER);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Transfert multiple'),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.MULTIPLE_TRANSFER);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Transfert planifié'),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.SCHEDULED_TRANSFER);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Mon QR Code'),
              onTap: () {
                Get.back();
                _showQRCode(Get.context!);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.red),
              ),
              onTap: controller.logout,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mon QR Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
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
            const SizedBox(height: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text('Fermer'),
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Partager'),
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      'Info',
                      'Fonctionnalité de partage à venir',
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}