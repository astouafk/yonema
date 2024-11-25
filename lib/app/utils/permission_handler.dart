// lib/app/utils/permission_handler.dart
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PermissionHandler {
  static Future<bool> handleCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    
    if (status.isPermanentlyDenied) {
      await Get.dialog(
        AlertDialog(
          title: const Text('Permission requise'),
          content: const Text('L\'accès à la caméra est nécessaire pour scanner les QR codes. Veuillez l\'activer dans les paramètres.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Paramètres'),
            ),
          ],
        ),
      );
      return false;
    }
    
    return status.isGranted;
  }
}