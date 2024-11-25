// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/scheduled_transfer_executor.dart';
import 'app/data/services/auth_service.dart';
import 'package:intl/date_symbol_data_local.dart'; // Ajout de cet import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialiser l'internationalisation
  await initializeDateFormatting('fr_FR', null);
  await Firebase.initializeApp();

    Get.put(ScheduledTransferExecutor());
    await Get.putAsync(() async => AuthService());



  runApp(
    GetMaterialApp(
      title: "YonemaGet",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    ),
  );
}