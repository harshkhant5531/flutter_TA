import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'admin_screen.dart';
import 'registration_screen.dart';
import 'user_screen.dart';
import 'api.dart';

class LoginScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  LoginScreen({super.key, this.userData});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = false;

  Future<void> login() async {
    final url = Uri.parse('$apiBase/get_data.php');

    try {
      final response = await http.post(
        url,
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode != 200) {
        return showError("Server Error: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);

      if (data["error"] != null) {
        return showError(data["error"]);
      }

      if (data["isAdmin"].toString() == "1") {
        Get.to(() => AdminScreen());
      } else {
        Get.to(() => UserScreen());
      }

      showSuccess("Login Successful!");
    } catch (e) {
      showError("Error: $e");
    }
  }

  void showError(String message) {
    Get.snackbar(
      "Login Failed",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: usernameController),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: !passwordVisible,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => Get.to(() => RegistrationScreen()),
                  child: const Text("Create new user"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
