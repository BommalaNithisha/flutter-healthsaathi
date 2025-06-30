/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _profileImageUrl;
  File? _pickedImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true); // Start loading
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            _nameController.text = data['name'] ?? '';
            _emailController.text = data['email'] ?? user.email ?? '';
            _phoneController.text = data['phone'] ?? '';
            _addressController.text = data['address'] ?? '';
            setState(() => _profileImageUrl = data['photoUrl']);
          } else {
            print('No data found in document for UID: ${user.uid}');
          }
        } else {
          print('Document does not exist for UID: ${user.uid}');
        }
      } else {
        print('No authenticated user found');
      }
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); // End loading
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseStorage.instance.ref().child('profile_pics/$uid.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'photoUrl': url,
    });

    setState(() {
      _pickedImage = file;
      _profileImageUrl = url;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile picture updated')));
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _pickedImage != null
        ? FileImage(_pickedImage!)
        : (_profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade100,
                      backgroundImage: image as ImageProvider<Object>?,
                      child: image == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickAndUploadImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.edit, color: Colors.teal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Only numbers allowed
                    LengthLimitingTextInputFormatter(10), // Max 10 digits
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter phone number';
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  }),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.home),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _profileImageUrl;
  File? _pickedImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true); // Start loading
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            _nameController.text = data['name'] ?? '';
            _emailController.text = data['email'] ?? user.email ?? '';
            _phoneController.text = data['phone'] ?? '';
            _addressController.text = data['address'] ?? '';
            setState(() => _profileImageUrl = data['photoUrl']);
          } else {
            print('No data found in document for UID: ${user.uid}');
          }
        } else {
          print('Document does not exist for UID: ${user.uid}');
        }
      } else {
        print('No authenticated user found');
      }
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('error_loading_profile_data'
                .trParams({'error': e.toString()}))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); // End loading
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseStorage.instance.ref().child('profile_pics/$uid.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'photoUrl': url,
    });

    setState(() {
      _pickedImage = file;
      _profileImageUrl = url;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('profile_picture_updated'.tr)));
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('profile_updated_success'.tr)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _pickedImage != null
        ? FileImage(_pickedImage!)
        : (_profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null);

    return Scaffold(
      appBar: AppBar(
        title: Text('my_profile'.tr),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            tooltip: 'logout'.tr,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade100,
                      backgroundImage: image as ImageProvider<Object>?,
                      child: image == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickAndUploadImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.edit, color: Colors.teal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'name'.tr,
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'enter_name'.tr : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'phone'.tr,
                    prefixIcon: const Icon(Icons.phone),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter_phone_number'.tr;
                    } else if (value.length != 10) {
                      return 'phone_number_must_be_10_digits'.tr;
                    }
                    return null;
                  }),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'address'.tr,
                  prefixIcon: const Icon(Icons.home),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text('save_changes'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _profileImageUrl;
  File? _pickedImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use authStateChanges so we load only when signed in
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        print('AuthState: signed in as ${user.uid}');
        _loadUserData(user.uid);
      } else {
        print('AuthState: no user signed in');
        setState(() => _isLoading = false);
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    setState(() => _isLoading = true);
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        print('Firestore data for $uid: $data');
        if (data != null) {
          _nameController.text = data['name'] ?? '';
          _emailController.text =
              data['email'] ?? FirebaseAuth.instance.currentUser?.email ?? '';
          _phoneController.text = data['phone'] ?? '';
          _addressController.text = data['address'] ?? '';
          setState(() => _profileImageUrl = data['photoUrl']);
        }
      } else {
        print('No document found for UID: $uid');
      }
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('error_loading_profile_data'
                .trParams({'error': e.toString()}))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final file = File(picked.path);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      setState(() => _isLoading = true);

      final ref = FirebaseStorage.instance.ref().child('profile_pics/$uid.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'photoUrl': url}, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _pickedImage = file;
          _profileImageUrl = url;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('profile_picture_updated'.tr)),
      );
    } catch (e) {
      print('Error uploading profile image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('error_updating_profile_picture'
                .trParams({'error': e.toString()}))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('profile_updated_success'.tr)),
        );
      } catch (e) {
        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'error_updating_profile'.trParams({'error': e.toString()}))),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _pickedImage != null
        ? FileImage(_pickedImage!)
        : (_profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null);

    return Scaffold(
      appBar: AppBar(
        title: Text('my_profile'.tr),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            tooltip: 'logout'.tr,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.teal.shade100,
                          backgroundImage: image as ImageProvider<Object>?,
                          child: image == null
                              ? const Icon(Icons.person,
                                  size: 50, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.edit, color: Colors.teal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'name'.tr,
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'enter_name'.tr : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'email'.tr,
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'phone'.tr,
                      prefixIcon: const Icon(Icons.phone),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter_phone_number'.tr;
                      } else if (value.length != 10) {
                        return 'phone_number_must_be_10_digits'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'address'.tr,
                      prefixIcon: const Icon(Icons.home),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text('save_changes'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: _saveProfile,
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}*/
