import 'package:flutter/material.dart';
import 'package:myevents/screens/bottom_screen/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardScreen> {
  String _selectedMenu = 'Home';

  @override
  Widget build(BuildContext context) {
    final purple = Color.fromARGB(252, 202, 60, 60);
    final lightGrey = Colors.grey.shade200;

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), backgroundColor: purple),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Image.asset('assets/image/logo.png', height: 60, width: 60),
                    SizedBox(width: 10),
                    Text(
                      'MY Events',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),

              _buildDrawerItem('Home', Icons.home, () {
                setState(() {
                  _selectedMenu = 'Home';
                });
                Navigator.pop(context);
              }),

              _buildDrawerItem('Bookings', Icons.book_online, () {}),
              _buildDrawerItem('Profile', Icons.person, () {}),
              _buildDrawerItem('Settings', Icons.settings, () {}),

              Spacer(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(lightGrey, purple),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    bool selected = (_selectedMenu == title);
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.blue : null),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.blue : null,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildBody(Color bgColor, Color accent) {
    if (_selectedMenu == 'Home') {
      return HomeScreen();
    }

    return Center(child: Text('$_selectedMenu '));
  }
}
