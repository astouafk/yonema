// lib/app/widgets/user_qr_code.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQRCode extends StatelessWidget {
  final String phone;
  final double size;

  const UserQRCode({
    Key? key,
    required this.phone,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: phone,
              version: QrVersions.auto,
              size: size,
            ),
            const SizedBox(height: 16),
            Text(
              'Mon QR Code',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              phone,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}