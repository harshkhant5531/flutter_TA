import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';
import 'api.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  Future<void> register() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final url = Uri.parse('$apiBase/insert_data.php');
    try {
      final response = await http.post(
        url,
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey("success")) {
          Get.to(
            LoginScreen(userData: {'username': username, 'password': password}),
          );
          Get.snackbar(
            'Registration',
            'Successful',
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          );
        } else {
          Get.snackbar(
            'Registration Failed',
            data["error"] ?? 'Failed to register',
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to register: ${response.statusCode}',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _usernameController),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(onPressed: register, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
