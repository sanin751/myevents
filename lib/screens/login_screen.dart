import 'package:flutter/material.dart';
import 'package:myevents/screens/dashboard_screen.dart';
import 'package:myevents/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF4B0082);
    final green = Colors.greenAccent;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 60),

              Image.asset('assets/image/logo.png', height: 100),
              SizedBox(height: 40),

              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Login Successful')));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Log In', style: TextStyle(color: Colors.white)),
                ),
              ),

              SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgotten password?',
                  style: TextStyle(color: purple),
                ),
              ),

              SizedBox(height: 8),
              Text('or'),

              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Create New Account',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),

              Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: Text('About')),
                  Text('|'),
                  TextButton(onPressed: () {}, child: Text('Help')),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
