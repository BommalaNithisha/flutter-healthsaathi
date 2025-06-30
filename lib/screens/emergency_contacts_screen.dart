import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class EmergencyContactsScreen extends StatelessWidget {
  EmergencyContactsScreen({super.key});

  final List<Map<String, String>> contacts = [
    {'name': 'ambulance'.tr, 'phone': '102'},
    {'name': 'fire'.tr, 'phone': '101'},
    {'name': 'police'.tr, 'phone': '100'},
  ];

  void _callNumber(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('could_not_launch_number'.trParams({'number': number}));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> localizedContacts = [
      {'name': 'ambulance'.tr, 'phone': '102'},
      {'name': 'fire'.tr, 'phone': '101'},
      {'name': 'police'.tr, 'phone': '100'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('emergency_contacts'.tr),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: localizedContacts.length,
        itemBuilder: (context, i) {
          final contact = localizedContacts[i];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: const Icon(Icons.local_phone, color: Colors.white),
              ),
              title: Text(
                contact['name']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                contact['phone']!,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () => _callNumber(contact['phone']!),
              ),
            ),
          );
        },
      ),
    );
  }
}
