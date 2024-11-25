// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/transfer/views/transfer_view.dart';
import '../modules/transfer/views/multiple_transfer_view.dart';
import '../modules/transfer/views/scheduled_transfer_view.dart';
import '../modules/transfer/views/qr_scanner_view.dart';
import '../modules/transfer/bindings/transfer_binding.dart';
import '../modules/transfer/views/scheduled_transfers_list_view.dart';
import '../modules/agent/bindings/agent_binding.dart';
import '../modules/agent/views/deposit_view.dart';
import '../modules/agent/views/withdrawal_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.TRANSFER,
      page: () => const TransferView(),
      binding: TransferBinding(),
    ),
    GetPage(
      name: _Paths.MULTIPLE_TRANSFER,
      page: () => const MultipleTransferView(),
      binding: TransferBinding(),
    ),
    GetPage(
      name: _Paths.SCHEDULED_TRANSFER,
      page: () => const ScheduledTransferView(),
      binding: TransferBinding(),
    ),
    GetPage(
      name: _Paths.QR_SCANNER,
      page: () => QRScannerView(),
      binding: TransferBinding(),  // Utilise le même binding que Transfer
    ),
     GetPage(
      name: _Paths.SCHEDULED_TRANSFERS_LIST,
      page: () => const ScheduledTransfersListView(),
      binding: TransferBinding(),
    ),
    GetPage(
      name: _Paths.AGENT_DEPOSIT,
      page: () => const DepositView(),
      binding: AgentBinding(),
    ),
    GetPage(
      name: _Paths.AGENT_WITHDRAWAL,
      page: () => const WithdrawalView(),
      binding: AgentBinding(),
    ),
  ];
}