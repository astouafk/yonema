part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const TRANSFER = _Paths.TRANSFER;
  static const MULTIPLE_TRANSFER = _Paths.MULTIPLE_TRANSFER;
  static const SCHEDULED_TRANSFER = _Paths.SCHEDULED_TRANSFER;
  static const QR_SCANNER = _Paths.QR_SCANNER;
  static const SCHEDULED_TRANSFERS_LIST = _Paths.SCHEDULED_TRANSFERS_LIST;
  static const AGENT_WITHDRAWAL = _Paths.AGENT_WITHDRAWAL;
  static const AGENT_DEPOSIT = _Paths.AGENT_DEPOSIT;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const TRANSFER = '/transfer';
  static const MULTIPLE_TRANSFER = '/multiple-transfer';
  static const SCHEDULED_TRANSFER = '/scheduled-transfer';
  static const QR_SCANNER = '/qr-scanner';
  static const SCHEDULED_TRANSFERS_LIST = '/scheduled-transfers-list';
  static const AGENT_WITHDRAWAL = '/agent-withdrawal';
  static const AGENT_DEPOSIT = '/agent-deposit';

}
