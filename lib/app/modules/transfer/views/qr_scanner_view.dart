// // lib/app/modules/transfer/views/qr_scanner_view.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import '../controllers/transfer_controller.dart';

// class QRScannerView extends GetView<TransferController> {
//   QRScannerView({Key? key}) : super(key: key);

//   final MobileScannerController scannerController = MobileScannerController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scanner QR Code'),
//         actions: [
//           // Bouton pour la lampe torche
//           IconButton(
//             icon: ValueListenableBuilder(
//               valueListenable: scannerController.torchState,
//               builder: (context, state, child) {
//                 return Icon(
//                   state == TorchState.off ? Icons.flash_off : Icons.flash_on,
//                 );
//               },
//             ),
//             onPressed: () => scannerController.toggleTorch(),
//           ),
//           // Bouton pour changer de caméra
//           IconButton(
//             icon: const Icon(Icons.switch_camera),
//             onPressed: () => scannerController.switchCamera(),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: scannerController,
//             onDetect: (capture) {
//               final List<Barcode> barcodes = capture.barcodes;
//               for (final barcode in barcodes) {
//                 // Vérifier que c'est bien un numéro de téléphone
//                 if (barcode.rawValue != null) {
//                   String phone = barcode.rawValue!;
//                   // Vérifier le format du numéro (format sénégalais)
//                   if (RegExp(r'^(70|75|76|77|78)[0-9]{7}$').hasMatch(phone)) {
//                     controller.onQRScanned(phone);
//                     Get.back(); // Retour à la page précédente
//                   } else {
//                     Get.snackbar(
//                       'Erreur',
//                       'QR Code invalide. Format de numéro incorrect.',
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                   }
//                 }
//               }
//             },
//           ),
//           // Overlay pour le viseur
//           CustomPaint(
//             painter: ScannerOverlay(),
//             child: const SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//             ),
//           ),
//           // Message d'instruction
//           Positioned(
//             bottom: 40,
//             left: 0,
//             right: 0,
//             child: Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: const Text(
//                 'Placez le QR code dans le cadre',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Custom Painter pour l'overlay du scanner
// class ScannerOverlay extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill;

//     const double scanAreaSize = 250;
//     final double left = (size.width - scanAreaSize) / 2;
//     final double top = (size.height - scanAreaSize) / 2;
//     final Rect scanArea = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);
//     final Path path = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..addRect(scanArea);

//     canvas.drawPath(path, paint..blendMode = BlendMode.srcOut);

//     // Dessiner les coins du cadre
//     final Paint cornerPaint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4;

//     const double cornerSize = 30;

//     // Coin supérieur gauche
//     canvas.drawLine(
//       Offset(left, top + cornerSize),
//       Offset(left, top),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(left, top),
//       Offset(left + cornerSize, top),
//       cornerPaint,
//     );

//     // Coin supérieur droit
//     canvas.drawLine(
//       Offset(left + scanAreaSize - cornerSize, top),
//       Offset(left + scanAreaSize, top),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(left + scanAreaSize, top),
//       Offset(left + scanAreaSize, top + cornerSize),
//       cornerPaint,
//     );

//     // Coin inférieur gauche
//     canvas.drawLine(
//       Offset(left, top + scanAreaSize - cornerSize),
//       Offset(left, top + scanAreaSize),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(left, top + scanAreaSize),
//       Offset(left + cornerSize, top + scanAreaSize),
//       cornerPaint,
//     );

//     // Coin inférieur droit
//     canvas.drawLine(
//       Offset(left + scanAreaSize - cornerSize, top + scanAreaSize),
//       Offset(left + scanAreaSize, top + scanAreaSize),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(left + scanAreaSize, top + scanAreaSize - cornerSize),
//       Offset(left + scanAreaSize, top + scanAreaSize),
//       cornerPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }



























// // lib/app/modules/transfer/views/qr_scanner_view.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import '../controllers/transfer_controller.dart';
// import 'transfer_view.dart';

// class QRScannerView extends GetView<TransferController> {
//   QRScannerView({Key? key}) : super(key: key);

//   final MobileScannerController scannerController = MobileScannerController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scanner QR Code'),
//         actions: [
//           IconButton(
//             icon: ValueListenableBuilder(
//               valueListenable: scannerController.torchState,
//               builder: (context, state, child) {
//                 return Icon(
//                   state == TorchState.off ? Icons.flash_off : Icons.flash_on,
//                 );
//               },
//             ),
//             onPressed: () => scannerController.toggleTorch(),
//           ),
//           IconButton(
//             icon: const Icon(Icons.switch_camera),
//             onPressed: () => scannerController.switchCamera(),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: scannerController,
//             onDetect: (capture) {
//   final List<Barcode> barcodes = capture.barcodes;
//   for (final barcode in barcodes) {
//     if (barcode.rawValue != null) {
//       String phone = barcode.rawValue!;
//       if (RegExp(r'^(70|75|76|77|78)[0-9]{7}$').hasMatch(phone)) {
//         controller.receiverPhone.value = phone;
//         Get.back(); // Retourne à la vue précédente
//       } else {
//         Get.snackbar(
//           'Erreur',
//           'Format de numéro incorrect',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     }
//   }
// },
//           ),
//           CustomPaint(
//             painter: ScannerOverlay(),
//             child: const SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//             ),
//           ),
//           Positioned(
//             bottom: 40,
//             left: 0,
//             right: 0,
//             child: Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: const Text(
//                 'Placez le QR code dans le cadre',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ScannerOverlay extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill;

//     const double scanAreaSize = 250;
//     final double left = (size.width - scanAreaSize) / 2;
//     final double top = (size.height - scanAreaSize) / 2;
//     final Rect scanArea = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);
//     final Path path = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..addRect(scanArea);

//     canvas.drawPath(path, paint..blendMode = BlendMode.srcOut);

//     final Paint cornerPaint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4;

//     const double cornerSize = 30;

//     // Coins
//     canvas.drawLine(
//       Offset(left, top + cornerSize),
//       Offset(left, top),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(left, top),
//       Offset(left + cornerSize, top),
//       cornerPaint,
//     );

//     canvas.drawLine(
//       Offset(left + scanAreaSize - cornerSize, top),
//       Offset(left + scanAreaSize, top),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(left + scanAreaSize, top),
//       Offset(left + scanAreaSize, top + cornerSize),
//       cornerPaint,
//     );

//     canvas.drawLine(
//       Offset(left, top + scanAreaSize - cornerSize),
//       Offset(left, top + scanAreaSize),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(left, top + scanAreaSize),
//       Offset(left + cornerSize, top + scanAreaSize),
//       cornerPaint,
//     );

//     canvas.drawLine(
//       Offset(left + scanAreaSize - cornerSize, top + scanAreaSize),
//       Offset(left + scanAreaSize, top + scanAreaSize),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(left + scanAreaSize, top + scanAreaSize - cornerSize),
//       Offset(left + scanAreaSize, top + scanAreaSize),
//       cornerPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }








import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/transfer_controller.dart';

class QRScannerView extends GetView<TransferController> {
  QRScannerView({Key? key}) : super(key: key);

  final MobileScannerController scannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  // Utiliser la méthode onQRScanned du contrôleur
                  controller.onQRScanned(barcode.rawValue!);
                }
              }
            },
          ),

          // Interface superposée
          SafeArea(
            child: Column(
              children: [
                // Barre d'outils
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        'Scanner QR Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          // Bouton flash
                          ValueListenableBuilder(
                            valueListenable: scannerController.torchState,
                            builder: (context, state, child) {
                              return IconButton(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    state == TorchState.off 
                                      ? Icons.flash_off 
                                      : Icons.flash_on,
                                    key: ValueKey(state),
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () => scannerController.toggleTorch(),
                              );
                            },
                          ),
                          // Bouton changement de caméra
                          IconButton(
                            icon: const Icon(Icons.cameraswitch, color: Colors.white),
                            onPressed: () => scannerController.switchCamera(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Zone de scan avec overlay animé
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              // Coins animés
                              ...buildCornerHighlights(),
                              
                              // Ligne de scan animée
                              const ScanLineAnimation(),
                            ],
                          ),
                        ),
                      ),
                      // Overlay semi-transparent
                      CustomPaint(
                        painter: ScannerOverlayPainter(),
                        child: const SizedBox.expand(),
                      ),
                    ],
                  ),
                ),

                // Instructions en bas
                Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.black26,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24, 
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Placez le QR code dans le cadre',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildCornerHighlights() {
    return [
      Positioned(
        top: 0,
        left: 0,
        child: CornerHighlight(color: Colors.blue.shade400),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: CornerHighlight(color: Colors.blue.shade400),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: CornerHighlight(color: Colors.blue.shade400),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: CornerHighlight(color: Colors.blue.shade400),
      ),
    ];
  }
}

// Widget pour les coins animés
class CornerHighlight extends StatefulWidget {
  final Color color;

  const CornerHighlight({Key? key, required this.color}) : super(key: key);

  @override
  State<CornerHighlight> createState() => _CornerHighlightState();
}

class _CornerHighlightState extends State<CornerHighlight> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: widget.color, width: 4),
                left: BorderSide(color: widget.color, width: 4),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Animation de la ligne de scan
class ScanLineAnimation extends StatefulWidget {
  const ScanLineAnimation({Key? key}) : super(key: key);

  @override
  State<ScanLineAnimation> createState() => _ScanLineAnimationState();
}

class _ScanLineAnimationState extends State<ScanLineAnimation> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 250)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.blue.shade400,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    const scanAreaSize = 250.0;
    final scanAreaLeft = (size.width - scanAreaSize) / 2;
    final scanAreaTop = (size.height - scanAreaSize) / 2;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(scanAreaLeft, scanAreaTop, scanAreaSize, scanAreaSize),
        const Radius.circular(20),
      ));

    canvas.drawPath(path, paint..blendMode = BlendMode.srcOut);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}