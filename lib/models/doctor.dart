class Doctor {
  final String id;
  final String name;
  final String specialization;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
  });

  // Updated factory with docId passed separately
  factory Doctor.fromFirestore(String docId, Map<String, dynamic> data) {
    return Doctor(
      id: docId,
      name: data['name'] ?? 'Unknown',
      specialization: data['specialization'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialization': specialization,
    };
  }
}
