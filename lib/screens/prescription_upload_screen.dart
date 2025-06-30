/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthsaathi/screens/reminders_screen.dart';
import 'package:healthsaathi/services/notification_service.dart';
import 'package:healthsaathi/services/reminder_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  State<PrescriptionUploadScreen> createState() =>
      _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState extends State<PrescriptionUploadScreen> {
  File? _image;
  String _extractedText = '';
  bool _loading = false;
  List<String> _medicineNames = [];
  Map<String, TimeOfDay> _medicineTimes = {};

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final file = File(picked.path);
      setState(() {
        _image = file;
        _extractedText = '';
        _loading = true;
      });

      final text = await OCRService().extractTextFromImage(file);

      setState(() {
        _extractedText = text;
        _loading = false;
      });

      _processExtractedText(text);
    } catch (e) {
      setState(() {
        _loading = false;
        _extractedText = 'Failed to extract text.';
      });
    }
  }

  void _processExtractedText(String text) {
    final regex = RegExp(r'(?:Tab|Tablet|Cap|Capsule)\s+([A-Za-z0-9]+)',
        caseSensitive: false);
    final matches = regex.allMatches(text);
    final meds = matches.map((m) => m.group(1)!).toSet().toList();

    setState(() {
      _medicineNames = meds;
      _medicineTimes = {for (var med in meds) med: TimeOfDay.now()};
    });

    ReminderManager.instance.clear();
    for (final med in _medicineNames) {
      final time = _medicineTimes[med]!;
      ReminderManager.instance.addReminder(med, time);
    }
  }

  Future<void> _scheduleReminders() async {
    final now = DateTime.now();
    ReminderManager.instance.clear();

    for (final med in _medicineNames) {
      final selectedTime = _medicineTimes[med]!;
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final finalDateTime = scheduledDateTime.isAfter(now)
          ? scheduledDateTime
          : scheduledDateTime.add(const Duration(days: 1));

      await NotificationService().scheduleReminderAt(
        title: "Medicine Reminder",
        body:
            "Please take your $med medicine. It's scheduled at ${selectedTime.format(context)}",
        dateTime: finalDateTime,
      );

      ReminderManager.instance.addReminder(med, selectedTime);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reminders scheduled successfully")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RemindersScreen()),
    );
  }

  void _saveMedicinesOnly() {
    ReminderManager.instance.clear();
    for (final med in _medicineNames) {
      final time = _medicineTimes[med]!;
      ReminderManager.instance.addReminder(med, time);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Medicines saved successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Prescription'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file),
              label: const Text('Choose Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            if (_image != null)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_image!, height: 250, fit: BoxFit.cover),
                ),
              )
            else
              const Text("No image selected",
                  style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            if (_loading)
              const CircularProgressIndicator()
            else if (_extractedText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Extracted Text:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_extractedText, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            if (_medicineNames.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Set Reminder Time for Each Medicine:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._medicineNames.map((med) => Card(
                    child: ListTile(
                      title: Text(med),
                      subtitle: Text(
                          'Reminder: ${_medicineTimes[med]?.format(context) ?? 'Not set'}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _medicineTimes[med] ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _medicineTimes[med] = pickedTime;
                            });
                          }
                        },
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _scheduleReminders,
                icon: const Icon(Icons.alarm),
                label: const Text("Save & Schedule Reminders"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
    );
  }
}*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthsaathi/screens/reminders_screen.dart';
import 'package:healthsaathi/services/notification_service.dart';
import 'package:healthsaathi/services/reminder_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';
import 'package:get/get.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  State<PrescriptionUploadScreen> createState() =>
      _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState extends State<PrescriptionUploadScreen> {
  File? _image;
  String _extractedText = '';
  bool _loading = false;
  List<String> _medicineNames = [];
  Map<String, TimeOfDay> _medicineTimes = {};

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final file = File(picked.path);
      setState(() {
        _image = file;
        _extractedText = '';
        _loading = true;
      });

      final text = await OCRService().extractTextFromImage(file);

      setState(() {
        _extractedText = text;
        _loading = false;
      });

      _processExtractedText(text);
    } catch (e) {
      setState(() {
        _loading = false;
        _extractedText = 'failed_to_extract_text'.tr;
      });
    }
  }

  void _processExtractedText(String text) {
    final regex = RegExp(r'(?:Tab|Tablet|Cap|Capsule)\s+([A-Za-z0-9]+)',
        caseSensitive: false);
    final matches = regex.allMatches(text);
    final meds = matches.map((m) => m.group(1)!).toSet().toList();

    setState(() {
      _medicineNames = meds;
      _medicineTimes = {for (var med in meds) med: TimeOfDay.now()};
    });

    ReminderManager.instance.clear();
    for (final med in _medicineNames) {
      final time = _medicineTimes[med]!;
      ReminderManager.instance.addReminder(med, time);
    }
  }

  Future<void> _scheduleReminders() async {
    final now = DateTime.now();
    ReminderManager.instance.clear();

    for (final med in _medicineNames) {
      final selectedTime = _medicineTimes[med]!;
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final finalDateTime = scheduledDateTime.isAfter(now)
          ? scheduledDateTime
          : scheduledDateTime.add(const Duration(days: 1));

      await NotificationService().scheduleReminderAt(
        title: "medicine_reminder".tr,
        body: "please_take_medicine"
            .trParams({'medicine': med, 'time': selectedTime.format(context)}),
        dateTime: finalDateTime,
      );

      ReminderManager.instance.addReminder(med, selectedTime);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("reminders_scheduled_success".tr)),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RemindersScreen()),
    );
  }

  void _saveMedicinesOnly() {
    ReminderManager.instance.clear();
    for (final med in _medicineNames) {
      final time = _medicineTimes[med]!;
      ReminderManager.instance.addReminder(med, time);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("medicines_saved_success".tr)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload_prescription'.tr),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file),
              label: Text('choose_image'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            if (_image != null)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_image!, height: 250, fit: BoxFit.cover),
                ),
              )
            else
              Text("no_image_selected".tr,
                  style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            if (_loading)
              const CircularProgressIndicator()
            else if (_extractedText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'extracted_text'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_extractedText, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            if (_medicineNames.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'set_reminder_time'.tr,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._medicineNames.map((med) => Card(
                    child: ListTile(
                      title: Text(med),
                      subtitle: Text(
                          '${'reminder'.tr}: ${_medicineTimes[med]?.format(context) ?? 'not_set'.tr}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _medicineTimes[med] ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _medicineTimes[med] = pickedTime;
                            });
                          }
                        },
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _scheduleReminders,
                icon: const Icon(Icons.alarm),
                label: Text("save_and_schedule_reminders".tr),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
    );
  }
}
