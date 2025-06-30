/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsaathi/models/doctor.dart';
import 'package:healthsaathi/services/firestore_service.dart';
import '../models/appointment.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in.")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: FirestoreService().getUserAppointments(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final appointments = snapshot.data;

          if (appointments == null || appointments.isEmpty) {
            return const Center(child: Text("No appointments found."));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              final date = appt.dateTime.toLocal().toString().split(' ')[0];

              return FutureBuilder<Doctor?>(
                future: FirestoreService().getDoctorById(appt.doctorId),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      title: Text("Loading doctor info..."),
                      subtitle: Text("Please wait"),
                    );
                  }

                  final doctor = doctorSnapshot.data;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.teal),
                      title: Text(
                        doctor != null
                            ? "Dr. ${doctor.name}"
                            : "Doctor not found",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        doctor != null
                            ? "Specialization: ${doctor.specialization}\nDate: $date"
                            : "Date: $date",
                      ),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Appointment"),
                                content: const Text(
                                    "Are you sure you want to delete this appointment?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                  TextButton(
                                    child: const Text("Delete"),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              // ✅ Show loading spinner
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                    child: CircularProgressIndicator()),
                              );

                              try {
                                await FirestoreService()
                                    .deleteAppointment(appt.id);

                                // ✅ Close loading spinner
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Appointment deleted")),
                                );
                              } catch (e) {
                                Navigator.pop(
                                    context); // close loading if error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Error deleting appointment: $e")),
                                );
                              }
                            }
                          }),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsaathi/models/doctor.dart';
import 'package:healthsaathi/services/firestore_service.dart';
import '../models/appointment.dart';
import 'package:get/get.dart';
class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text("user_not_logged_in".tr)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("my_appointments".tr),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: FirestoreService().getUserAppointments(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'error'.trParams({'error': snapshot.error.toString()})));
          }

          final appointments = snapshot.data;

          if (appointments == null || appointments.isEmpty) {
            return Center(child: Text("no_appointments_found".tr));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              final date = appt.dateTime.toLocal().toString().split(' ')[0];

              return FutureBuilder<Doctor?>(
                future: FirestoreService().getDoctorById(appt.doctorId),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text("loading_doctor_info".tr),
                      subtitle: Text("please_wait".tr),
                    );
                  }

                  final doctor = doctorSnapshot.data;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.teal),
                      title: Text(
                        doctor != null
                            ? "${'dr'.tr} ${doctor.name}"
                            : "doctor_not_found".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        doctor != null
                            ? "${'specialization'.tr}: ${doctor.specialization.tr}\n${'date'.tr}: $date"
                            : "${'date'.tr}: $date",
                      ),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("delete_appointment".tr),
                                content: Text("delete_appointment_confirm".tr),
                                actions: [
                                  TextButton(
                                    child: Text("cancel".tr),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                  TextButton(
                                    child: Text("delete".tr),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              // ✅ Show loading spinner
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                    child: CircularProgressIndicator()),
                              );

                              try {
                                await FirestoreService()
                                    .deleteAppointment(appt.id);

                                // ✅ Close loading spinner
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("appointment_deleted".tr)),
                                );
                              } catch (e) {
                                Navigator.pop(
                                    context); // close loading if error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("error_deleting_appointment"
                                          .trParams({'error': e.toString()}))),
                                );
                              }
                            }
                          }),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsaathi/models/doctor.dart';
import 'package:healthsaathi/services/firestore_service.dart';
import '../models/appointment.dart';
import 'video_call_screen.dart';
import 'package:get/get.dart';
class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text("user_not_logged_in".tr)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("my_appointments".tr),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: FirestoreService().getUserAppointments(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'error'.trParams({'error': snapshot.error.toString()})));
          }

          final appointments = snapshot.data;

          if (appointments == null || appointments.isEmpty) {
            return Center(child: Text("no_appointments_found".tr));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              final date = appt.dateTime.toLocal().toString().split(' ')[0];

              return FutureBuilder<Doctor?>(
                future: FirestoreService().getDoctorById(appt.doctorId),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text("loading_doctor_info".tr),
                      subtitle: Text("please_wait".tr),
                    );
                  }

                  final doctor = doctorSnapshot.data;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: Colors.teal),
                          title: Text(
                            doctor != null
                                ? "${'dr'.tr} ${doctor.name}"
                                : "doctor_not_found".tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            doctor != null
                                ? "${'specialization'.tr}: ${doctor.specialization.tr}\n${'date'.tr}: $date"
                                : "${'date'.tr}: $date",
                          ),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("delete_appointment".tr),
                                    content:
                                        Text("delete_appointment_confirm".tr),
                                    actions: [
                                      TextButton(
                                        child: Text("cancel".tr),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                      TextButton(
                                        child: Text("delete".tr),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const Center(
                                        child: CircularProgressIndicator()),
                                  );

                                  try {
                                    await FirestoreService()
                                        .deleteAppointment(appt.id);

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("appointment_deleted".tr)),
                                    );
                                  } catch (e) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "error_deleting_appointment"
                                                  .trParams({
                                        'error': e.toString()
                                      }))),
                                    );
                                  }
                                }
                              }),
                        ),
                        // ADD JOIN VIDEO CALL BUTTON HERE
                        TextButton.icon(
                          icon: const Icon(Icons.video_call),
                          label: const Text("Join Video Call"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    VideoCallScreen(channelName: appt.id),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsaathi/models/doctor.dart';
import 'package:healthsaathi/services/firestore_service.dart';
import '../models/appointment.dart';
import 'video_call_screen.dart';
import 'package:get/get.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  bool _canJoinCall(DateTime scheduledTime) {
    final now = DateTime.now();
    final diff = scheduledTime.difference(now).inMinutes;
    return diff <= 10 && diff >= -30; // allow 10 min before, 30 min after
  }

  void _deleteAppointment(BuildContext context, String appointmentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("delete_appointment".tr),
        content: Text("delete_appointment_confirm".tr),
        actions: [
          TextButton(
            child: Text("cancel".tr),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("delete".tr),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await FirestoreService().deleteAppointment(appointmentId);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("appointment_deleted".tr)),
        );
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "error_deleting_appointment".trParams({'error': e.toString()})),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text("user_not_logged_in".tr)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("my_appointments".tr),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: FirestoreService().getUserAppointments(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child:
                  Text('error'.trParams({'error': snapshot.error.toString()})),
            );
          }

          final appointments = snapshot.data;

          if (appointments == null || appointments.isEmpty) {
            return Center(child: Text("no_appointments_found".tr));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              final date = appt.dateTime.toLocal().toString().split(' ')[0];

              return FutureBuilder<Doctor?>(
                future: FirestoreService().getDoctorById(appt.doctorId),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text("loading_doctor_info".tr),
                      subtitle: Text("please_wait".tr),
                    );
                  }

                  final doctor = doctorSnapshot.data;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: Colors.teal),
                          title: Text(
                            doctor != null
                                ? "${'dr'.tr} ${doctor.name}"
                                : "doctor_not_found".tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            doctor != null
                                ? "${'specialization'.tr}: ${doctor.specialization.tr}\n${'date'.tr}: $date"
                                : "${'date'.tr}: $date",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteAppointment(context, appt.id),
                          ),
                        ),
                        if (_canJoinCall(appt.dateTime))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.video_call),
                              label: Text('join_video_call'.tr),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        VideoCallScreen(channelName: appt.id),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'You can join the call at the appointment time.',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsaathi/models/doctor.dart';
import 'package:healthsaathi/services/firestore_service.dart';
import '../models/appointment.dart';
import 'video_call_screen.dart';
import 'package:get/get.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  bool _canJoinCall(DateTime scheduledTime) {
    final now = DateTime.now();
    final diff = scheduledTime.difference(now).inMinutes;
    return diff <= 10 && diff >= -30; // allow 10 min before to 30 min after
  }

  void _deleteAppointment(BuildContext context, String appointmentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("delete_appointment".tr),
        content: Text("delete_appointment_confirm".tr),
        actions: [
          TextButton(
            child: Text("cancel".tr),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("delete".tr),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await FirestoreService().deleteAppointment(appointmentId);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("appointment_deleted".tr)),
        );
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "error_deleting_appointment".trParams({'error': e.toString()}),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text("user_not_logged_in".tr)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("my_appointments".tr),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: FirestoreService().getUserAppointments(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child:
                  Text('error'.trParams({'error': snapshot.error.toString()})),
            );
          }

          final appointments = snapshot.data;

          if (appointments == null || appointments.isEmpty) {
            return Center(child: Text("no_appointments_found".tr));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              final date = appt.dateTime.toLocal().toString().split(' ')[0];

              return FutureBuilder<Doctor?>(
                future: FirestoreService().getDoctorById(appt.doctorId),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text("loading_doctor_info".tr),
                      subtitle: Text("please_wait".tr),
                    );
                  }

                  final doctor = doctorSnapshot.data;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: Colors.teal),
                          title: Text(
                            doctor != null
                                ? "${'dr'.tr} ${doctor.name}"
                                : "doctor_not_found".tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            doctor != null
                                ? "${'specialization'.tr}: ${doctor.specialization.tr}\n${'date'.tr}: $date"
                                : "${'date'.tr}: $date",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteAppointment(context, appt.id),
                          ),
                        ),
                        if (_canJoinCall(appt.dateTime))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.video_call),
                              label: Text('join_video_call'.tr),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        VideoCallScreen(channelName: appt.id),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'You can join the call at the appointment time.',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsaathi/models/doctor.dart';
import 'package:healthsaathi/services/firestore_service.dart';
import '../models/appointment.dart';
import 'video_call_screen.dart';
import 'package:get/get.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  bool _canJoinCall(DateTime scheduledTime) {
    final now = DateTime.now();
    final diff = scheduledTime.difference(now).inMinutes;
    return diff <= 10 && diff >= -30; // allow 10 min before, 30 min after
  }

  void _deleteAppointment(BuildContext context, String appointmentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("delete_appointment".tr),
        content: Text("delete_appointment_confirm".tr),
        actions: [
          TextButton(
            child: Text("cancel".tr),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("delete".tr),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Delete without blocking loading spinner
      try {
        await FirestoreService().deleteAppointment(appointmentId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("appointment_deleted".tr)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "error_deleting_appointment".trParams({'error': e.toString()}),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("user_not_logged_in".tr)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("my_appointments".tr),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: FirestoreService().getUserAppointments(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'error'.trParams({'error': snapshot.error.toString()}),
              ),
            );
          }

          final appointments = snapshot.data;

          if (appointments == null || appointments.isEmpty) {
            return Center(child: Text("no_appointments_found".tr));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              final date = appt.dateTime.toLocal().toString().split(' ')[0];

              return FutureBuilder<Doctor?>(
                future: FirestoreService().getDoctorById(appt.doctorId),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: Text("loading_doctor_info".tr),
                      subtitle: Text("please_wait".tr),
                    );
                  }

                  final doctor = doctorSnapshot.data;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: Colors.teal),
                          title: Text(
                            doctor != null
                                ? "${'dr'.tr} ${doctor.name}"
                                : "doctor_not_found".tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            doctor != null
                                ? "${'specialization'.tr}: ${doctor.specialization.tr}\n${'date'.tr}: $date"
                                : "${'date'.tr}: $date",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteAppointment(context, appt.id),
                          ),
                        ),
                        if (_canJoinCall(appt.dateTime))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.video_call),
                              label: Text('join_video_call'.tr),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        VideoCallScreen(channelName: appt.id),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'You can join the call at the appointment time.'
                                  .tr,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
