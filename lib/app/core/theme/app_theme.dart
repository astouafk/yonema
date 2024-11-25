// lib/app/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs
  static const Color primaryColor = Color(0xFF008B8B); // DarkCyan
  static const Color secondaryColor = Color(0xFF20B2AA); // LightSeaGreen
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF2C3E50);
  static const Color subtextColor = Color(0xFF7F8C8D);

  // Style des cards
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );

  // Styles de texte
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: subtextColor,
  );

  static const TextStyle balanceStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
}