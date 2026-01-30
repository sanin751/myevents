import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myevents/app/routes/app_routes.dart';
import 'package:myevents/core/services/storage/token_service.dart';
import 'package:myevents/core/services/storage/user_session_service.dart';
import 'package:myevents/features/auth/presentation/pages/login_screen.dart';
import 'package:myevents/features/profile/presentation/pages/edit_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final lightYellow = const Color(0xFFFFF9C4);
    return Scaffold(
      backgroundColor: lightYellow,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Profile Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFFE1BEE7),
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ),

              const SizedBox(height: 50),

              /// Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _profileTile(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    _profileTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {},
                    ),
                    const Divider(),
                    _profileTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      iconColor: Colors.redAccent,
                      onTap: () async {
                        final userSession = ref.read(
                          userSessionServiceProvider,
                        );
                        final tokenSession = ref.read(tokenServiceProvider);
                        await userSession.clearSession();
                        await tokenSession.removeToken();

                        ref.invalidate(userSessionServiceProvider);

                        // Navigate to login
                        if (context.mounted) {
                          AppRoutes.pushReplacement(
                            context,
                            const LoginScreen(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// Bottom Buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
