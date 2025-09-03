import 'package:flutter/material.dart';
import 'package:healthsaathi/screens/my_appointrments_screen.dart';
import 'package:healthsaathi/screens/profile_screen.dart';
import 'doctor_list_screen.dart';
import 'reminders_screen.dart';
import 'emergency_contacts_screen.dart';
import 'prescription_upload_screen.dart';
//import 'video_call_screen.dart';
import 'book_appointment_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'label': 'doctors'.tr, 'screen': const DoctorListScreen()},
      {'label': 'book_appointment'.tr, 'screen': const BookAppointmentScreen()},
      {
        'label': 'upload_prescription'.tr,
        'screen': const PrescriptionUploadScreen()
      },
      {'label': 'reminders'.tr, 'screen': const RemindersScreen()},
      {'label': 'emergency_contacts'.tr, 'screen': EmergencyContactsScreen()},
      //{'label': 'video_call'.tr, 'screen': const VideoCallScreen()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('healthsaathi'.tr),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueGrey),
              child: Text(
                'welcome'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('profile'.tr),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text('my_appointments'.tr),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyAppointmentsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/signup.jpg', // <- Change to your image path
              fit: BoxFit.cover,
            ),
          ),

          GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: buttons.map((btn) {
              final label = btn['label'] as String;
              final screen = btn['screen'] as Widget;

              IconData icon;
              if (label == 'doctors'.tr) {
                icon = Icons.medical_services;
              } else if (label == 'book_appointment'.tr) {
                icon = Icons.calendar_today;
              } else if (label == 'upload_prescription'.tr) {
                icon = Icons.upload_file;
              } else if (label == 'reminders'.tr) {
                icon = Icons.alarm;
              } else if (label == 'emergency_contacts'.tr) {
                icon = Icons.phone_in_talk;
              } else if (label == 'video_call'.tr) {
                icon = Icons.video_call;
              } else {
                icon = Icons.health_and_safety;
              }

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4FC3F7), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 40, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ); 
  }
}
