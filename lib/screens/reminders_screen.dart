import 'package:flutter/material.dart';
import 'package:healthsaathi/services/notification_service.dart';
import 'package:healthsaathi/services/reminder_manager.dart';
import 'package:get/get.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  void _triggerReminder(BuildContext context) {
    NotificationService().showReminder(
      "Medicine Time".tr,
      "Please take your medicine.".tr,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder triggered'.tr)),
    );
  }

  void _editReminder(int index) async {
    final current = ReminderManager.instance.reminders[index];
    final picked = await showTimePicker(
      context: context,
      initialTime: current['time'] as TimeOfDay,
    );
    if (picked != null) {
      setState(() {
        ReminderManager.instance.reminders[index]['time'] = picked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Updated reminder for ${current['medicine']}"),
        ),
      );
    }
  }

  void _deleteReminder(int index) {
    final removed = ReminderManager.instance.reminders[index];
    setState(() {
      ReminderManager.instance.reminders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleted reminder for ${removed['medicine']}".tr)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = ReminderManager.instance.reminders;

    print('🟢 Medicines from ReminderManager: $reminders'.tr);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Reminders'.tr),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.alarm, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Text(
              "Scheduled Medicines".tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            reminders.isEmpty
                ? Text("No medicines scheduled yet.".tr)
                : Expanded(
                    child: ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];
                        final medicine = reminder['medicine'];
                        final time = reminder['time'] as TimeOfDay;
                        final formattedTime = time.format(context);

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.medication,
                                color: Colors.teal),
                            title: Text(
                              medicine,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Scheduled at $formattedTime".tr),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editReminder(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteReminder(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:healthsaathi/services/notification_service.dart';
import 'package:healthsaathi/services/reminder_manager.dart';
import 'package:get/get.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  void _triggerReminder(BuildContext context) {
    NotificationService().showReminder(
      "medicine_time".tr,
      "please_take_your_medicine".tr,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('reminder_triggered'.tr)),
    );
  }

  void _editReminder(int index) async {
    final current = ReminderManager.instance.reminders[index];
    final picked = await showTimePicker(
      context: context,
      initialTime: current['time'] as TimeOfDay,
    );
    if (picked != null) {
      setState(() {
        ReminderManager.instance.reminders[index]['time'] = picked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("updated_reminder_for"
              .trParams({'medicine': current['medicine']})),
        ),
      );
    }
  }

  void _deleteReminder(int index) {
    final removed = ReminderManager.instance.reminders[index];
    setState(() {
      ReminderManager.instance.reminders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("deleted_reminder_for"
              .trParams({'medicine': removed['medicine']}))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = ReminderManager.instance.reminders;

    print('🟢 Medicines from ReminderManager: $reminders');

    return Scaffold(
      appBar: AppBar(
        title: Text('medicine_reminders'.tr),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.alarm, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Text(
              "scheduled_medicines".tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            reminders.isEmpty
                ? Text("no_medicines_scheduled".tr)
                : Expanded(
                    child: ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];
                        final medicine = reminder['medicine'];
                        final time = reminder['time'] as TimeOfDay;
                        final formattedTime = time.format(context);

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.medication,
                                color: Colors.teal),
                            title: Text(
                              medicine,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("scheduled_at"
                                .trParams({'time': formattedTime})),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editReminder(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteReminder(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:healthsaathi/services/notification_service.dart';
import 'package:healthsaathi/services/reminder_manager.dart';
import 'package:get/get.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  void _triggerReminder(BuildContext context) {
    final reminders = ReminderManager.instance.reminders;

    if (reminders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no_medicines_scheduled'.tr)),
      );
      return;
    }

    for (var reminder in reminders) {
      final medicine = reminder['medicine'];
      final time = (reminder['time'] as TimeOfDay).format(context);

      NotificationService().showReminder(
        "Medicine Reminder",
        "Please take your $medicine medicine. It's scheduled at $time.",
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('reminder_triggered'.tr)),
    );
  }

  void _editReminder(int index) async {
    final current = ReminderManager.instance.reminders[index];
    final picked = await showTimePicker(
      context: context,
      initialTime: current['time'] as TimeOfDay,
    );
    if (picked != null) {
      setState(() {
        ReminderManager.instance.reminders[index]['time'] = picked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("updated_reminder_for"
              .trParams({'medicine': current['medicine']})),
        ),
      );
    }
  }

  void _deleteReminder(int index) {
    final removed = ReminderManager.instance.reminders[index];
    setState(() {
      ReminderManager.instance.reminders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("deleted_reminder_for"
              .trParams({'medicine': removed['medicine']}))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = ReminderManager.instance.reminders;

    print('🟢 Medicines from ReminderManager: $reminders');

    return Scaffold(
      appBar: AppBar(
        title: Text('medicine_reminders'.tr),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'trigger_reminder'.tr,
            onPressed: () => _triggerReminder(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.alarm, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Text(
              "scheduled_medicines".tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            reminders.isEmpty
                ? Text("no_medicines_scheduled".tr)
                : Expanded(
                    child: ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];
                        final medicine = reminder['medicine'];
                        final time = reminder['time'] as TimeOfDay;
                        final formattedTime = time.format(context);

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.medication,
                                color: Colors.teal),
                            title: Text(
                              medicine,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("scheduled_at"
                                .trParams({'time': formattedTime})),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editReminder(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteReminder(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}*/
