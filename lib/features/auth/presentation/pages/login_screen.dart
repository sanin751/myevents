import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/app/routes/app_routes.dart';
import 'package:myevents/core/utils/snackbar_utils.dart';
import 'package:myevents/features/auth/presentation/pages/signup_screen.dart';
import 'package:myevents/features/auth/presentation/state/auth_state.dart';
import 'package:myevents/features/auth/presentation/view_models/auth_viewmodel.dart';
import 'package:myevents/features/dashboard/presentation/pages/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {

const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Future<void> _handleLogin() async {

    if (formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(
            phoneNumber: phoneController.text.trim(),
            password: passwordController.text,
          );
    }
  }

   void _navigateToSignup() {
    AppRoutes.push(context, const SignupScreen());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        AppRoutes.pushReplacement(context, const DashboardScreen());
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });
    final purple = Color(0xFF4B0082);
    final green = Colors.greenAccent;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
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
                    onPressed: _handleLogin,
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
                    onPressed: _navigateToSignup,
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
      ),
    );
  }
}
