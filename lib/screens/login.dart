import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:healthsaathi/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.withOpacity(
          0.8,
        ), // Semi-transparent background
        title: Text('LOGIN PAGE'.tr),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        //fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/images/signup.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.white.withOpacity(0.1), // Adjust darkness here
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LOGIN HERE'.tr,
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
                            "WELCOME, AGAIN".tr,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.teal,
                              ),
                            ),
                            validator: (value) =>
                                !value!.contains('@') ? 'Invalid email' : null,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password'.tr,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.teal[200],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  // Optional: print debug info
                                  print(
                                    'Logged in: ${userCredential.user!.email}',
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  String message;
                                  if (e.code == 'user-not-found') {
                                    message = 'No user found for that email.';
                                  } else if (e.code == 'wrong-password') {
                                    message = 'Incorrect password.';
                                  } else {
                                    message = 'Login failed. Please try again.';
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[200],
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'LOGIN'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
