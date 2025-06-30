import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user profile
  Future<void> saveUserProfile(UserProfile profile) {
    return _db.collection('users').doc(profile.uid).set(profile.toMap());
  }

  // Get doctors
  Stream<List<Doctor>> getDoctors() {
    return _db.collection('doctors').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Doctor.fromFirestore(doc.id, data);
      }).toList();
    });
  }

  // Book appointment
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  Future<void> bookAppointment(Appointment appointment) async {
    await appointments.doc(appointment.id).set(appointment.toMap());
  }

  // Get appointments for user
  Stream<List<Appointment>> getUserAppointments(String uid) {
    return _db
        .collection('appointments')
        .where('userId', isEqualTo: uid)
        .orderBy('dateTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Appointment.fromMap(data, doc.id);
      }).toList();
    });
  }

  // DELETE appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      if (appointmentId.isEmpty) {
        throw Exception("Appointment ID is empty");
      }
      await _db.collection('appointments').doc(appointmentId).delete();
      print("✅ Appointment $appointmentId deleted successfully");
    } catch (e, stack) {
      print("❌ Error deleting appointment: $e");
      print(stack);
      rethrow;
    }
  }

  /*Future<void> deleteAppointment(String appointmentId) async {
    try {
      await _db.collection('appointments').doc(appointmentId).delete();
      print("✅ Appointment $appointmentId deleted successfully");
    } catch (e) {
      print("❌ Error deleting appointment: $e");
      rethrow; // throw again to catch in UI if needed
    }
  }*/

  //  Get doctor by ID
  Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final doc = await _db.collection('doctors').doc(doctorId).get();
      if (doc.exists) {
        final data = doc.data();
        return Doctor(
          id: doc.id,
          name: data?['name'] ?? 'Unknown',
          specialization: data?['specialization'] ?? 'Unknown',
        );
      }
    } catch (e) {
      print("Error fetching doctor by ID: $e");
    }
    return null;
  }
}
