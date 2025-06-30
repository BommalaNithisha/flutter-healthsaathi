import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String userId;
  final String doctorId;
  final DateTime dateTime;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'dateTime': dateTime,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> data, String id) {
    return Appointment(
      id: id,
      doctorId: data['doctorId'] ?? '',
      userId: data['userId'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }
}
