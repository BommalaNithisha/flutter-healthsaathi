import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthsaathi/screens/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Update user display name and Firestore
      await userCredential.user?.updateDisplayName(nameController.text.trim());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'createdAt': Timestamp.now(),
        'uid': userCredential.user?.uid,
      });

      // 3. Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('account_created_success'.tr),
            backgroundColor: Colors.green,
          ),
        );
      }

      // 4. Navigate to login page after delay
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'email_already_registered'.tr;
          break;
        case 'weak-password':
          errorMessage = 'password_too_weak'.tr;
          break;
        case 'invalid-email':
          errorMessage = 'invalid_email_address'.tr;
          break;
        default:
          errorMessage = 'registration_failed'.tr;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.withOpacity(0.8),
        title: Text('book_doctor_appointments'.tr),
        centerTitle: true,
        elevation: 0,
        actions: [
          DropdownButton<Locale>(
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: Colors.white),
            onChanged: (Locale? locale) {
              if (locale != null) {
                Get.updateLocale(locale);
              }
            },
            items: const [
              DropdownMenuItem(
                value: Locale('en', 'US'),
                child: Text('EN'),
              ),
              DropdownMenuItem(
                value: Locale('hi', 'IN'),
                child: Text('हिं'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/images/signup.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.white.withOpacity(0.1)),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'book_your_doctor_appointments'.tr,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "welcome".tr,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'name'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.teal[200],
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'enter_your_name'.tr : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'email'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.teal,
                              ),
                            ),
                            validator: (value) => !value!.contains('@')
                                ? 'invalid_email'.tr
                                : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'password'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.teal[200],
                              ),
                            ),
                            validator: (value) => value!.length < 6
                                ? 'password_too_short'.tr
                                : null,
                          ),
                          SizedBox(height: 24),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'confirm_password'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.teal[200],
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'confirm_your_password'.tr;
                              }
                              if (value != passwordController.text) {
                                return 'passwords_do_not_match'.tr;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: isLoading ? null : createUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[200],
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'sign_up'.tr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'already_have_account'.tr,
                                style: TextStyle(color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'login'.tr,
                                  style: TextStyle(
                                    color: Colors.teal[200],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
