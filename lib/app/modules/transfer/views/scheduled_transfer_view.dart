

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transfer_controller.dart';

class ScheduledTransferView extends GetView<TransferController> {
  const ScheduledTransferView({Key? key}) : super(key: key);

  String formatDate(DateTime? date) {
    if (date == null) return 'Choisir la date';
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${pad(date.day)}/${pad(date.month)}/${date.year}';
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'Choisir l\'heure';
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${pad(time.hour)}:${pad(time.minute)}';
  }

  Widget _buildDateTimeSelector({
    required String label,
    required DateTime? date,
    required TimeOfDay? time,
    required Function(DateTime?) onDateChanged,
    required Function(TimeOfDay?) onTimeChanged,
    required DateTime firstDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Sélecteur de date
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: date ?? DateTime.now(),
                    firstDate: firstDate,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.orange.shade400,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    onDateChanged(pickedDate);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                           size: 18,
                           color: Colors.orange.shade300),
                      const SizedBox(width: 8),
                      Text(
                        formatDate(date),
                        style: TextStyle(
                          color: date != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Sélecteur d'heure
            Expanded(
              child: InkWell(
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: Get.context!,
                    initialTime: time ?? TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.orange.shade400,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    onTimeChanged(pickedTime);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time,
                           size: 18,
                           color: Colors.orange.shade300),
                      const SizedBox(width: 8),
                      Text(
                        formatTime(time),
                        style: TextStyle(
                          color: time != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfert Planifié'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // En-tête avec animation
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.shade50,
                    Colors.orange.shade100,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WavePainter(color: Colors.orange),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 40,
                          color: Colors.orange.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Programmer vos transferts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card d'information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade50,
                          Colors.orange.shade50,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade400,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Programmez des transferts automatiques réguliers en toute simplicité.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section montant et destinataire
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Montant
                        Text(
                          'Montant par transfert',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Montant',
                            suffixText: 'FCFA',
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(Icons.attach_money, 
                                           color: Colors.orange.shade300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.orange.shade300,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            controller.amount.value = double.tryParse(value) ?? 0;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Destinataire
                        Text(
                          'Destinataire',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Numéro de téléphone',
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  prefixIcon: Icon(Icons.person_outline,
                                                 color: Colors.orange.shade300),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.orange.shade300,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.receiverPhone.value = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.qr_code_scanner,
                                         color: Colors.orange.shade700),
                                onPressed: () => Get.toNamed('/qr-scanner'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Section planification
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                 color: Colors.orange.shade300),
                            const SizedBox(width: 8),
                            Text(
                              'Planification',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Fréquence
                        const Text(
                          'Fréquence de transfert',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: controller.selectedInterval.value,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              border: InputBorder.none,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'daily',
                                child: Row(
                                  children: [
                                    Icon(Icons.replay_rounded,
                                         color: Colors.orange.shade300),
                                    const SizedBox(width: 8),
                                    const Text('Quotidien'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'weekly',
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_view_week,
                                         color: Colors.orange.shade300),
                                    const SizedBox(width: 8),
                                    const Text('Hebdomadaire'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'monthly',
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month,
                                         color: Colors.orange.shade300),
                                    const SizedBox(width: 8),
                                    const Text('Mensuel'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedInterval.value = value;
                              }
                            },
                          ),
                        )),

                        const SizedBox(height: 16),

                        // Dates et heures
                        Obx(() => _buildDateTimeSelector(
                          label: 'Date et heure de début',
                          date: controller.startDate.value,
                          time: controller.startTime.value,
                          onDateChanged: (date) => controller.startDate.value = date,
                          onTimeChanged: (time) => controller.startTime.value = time,
                          firstDate: DateTime.now(),
                        )),

                        const SizedBox(height: 16),

                        Obx(() => _buildDateTimeSelector(
                          label: 'Date et heure de fin',
                          date: controller.endDate.value,
                          time: controller.endTime.value,
                          onDateChanged: (date) => controller.endDate.value = date,
                          onTimeChanged: (time) => controller.endTime.value = time,
                          firstDate: controller.startDate.value ?? DateTime.now(),
                        )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bouton de confirmation
                  Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (controller.amount.value > 0 &&
                               controller.receiverPhone.isNotEmpty &&
                               controller.startDate.value != null &&
                               controller.endDate.value != null &&
                               controller.startTime.value != null &&
                               controller.endTime.value != null &&
                               !controller.isLoading.value)
                            ? [Colors.orange, Colors.orange.shade700]
                            : [Colors.grey, Colors.grey.shade600],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (controller.amount.value > 0 &&
                                 controller.receiverPhone.isNotEmpty &&
                                 controller.startDate.value != null &&
                                 controller.endDate.value != null &&
                                 controller.startTime.value != null &&
                                 controller.endTime.value != null &&
                                 !controller.isLoading.value
                              ? Colors.orange
                              : Colors.grey).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: (controller.amount.value > 0 &&
                               controller.receiverPhone.isNotEmpty &&
                               controller.startDate.value != null &&
                               controller.endDate.value != null &&
                               controller.startTime.value != null &&
                               controller.endTime.value != null &&
                               !controller.isLoading.value)
                            ? controller.scheduleTransfer
                            : null,
                        child: Center(
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.schedule_send_rounded,
                                             color: Colors.white),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Programmer le transfert',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe pour l'animation des vagues
class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.8,
        size.width * 0.5,
        size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.6,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);

    // Deuxième vague
    final secondPaint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final secondPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.7,
        size.width * 0.5,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.9,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(secondPath, secondPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}