import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/doctor.dart';
import '../services/firestore_service.dart';
import 'book_appointment_screen.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  String _getEmoji(String specialization) {
    final emojiMap = {
      'General': '🩺',
      'Cardiologist': '❤️‍🩹',
      'Dentist': '🦷',
      'Eye': '👁',
      'Pediatrician': '🧒',
      'Orthopedic': '🦴',
      'Gynecologist': '👩‍🍼',
      'Dermatologist': '🧴',
      'Neurologist': '🧠',
      'Nephrologist': '🩸',
    };
    return emojiMap[specialization] ?? '👨‍⚕️';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('doctors_near_you'.tr), // 👨‍⚕️ Doctors Near You
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          // Background image (optional)
          /*
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/doctor.jpg',
              fit: BoxFit.cover,
            ),
          ),
          */
          Container(
            color: Colors.white.withOpacity(0.9),
            child: StreamBuilder<List<Doctor>>(
              stream: FirestoreService().getDoctors(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Firestore Error: ${snapshot.error}');
                  return Center(
                      child: Text('error_loading_doctors'
                          .trParams({'error': snapshot.error.toString()})));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final doctors = snapshot.data!;
                print('Number of doctors loaded: ${doctors.length}');

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    final doctorId = doctor.id ?? '';
                    final emoji = _getEmoji(doctor.specialization);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text(
                            doctor.name.isNotEmpty
                                ? doctor.name[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                        title: Text(
                          '$emoji ${doctor.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          doctor.specialization.tr,
                          style: const TextStyle(fontSize: 15),
                        ),
                        trailing: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BookAppointmentScreen(doctorId: doctorId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: Text('book'.tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
