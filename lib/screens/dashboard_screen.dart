import 'package:flutter/material.dart';
import 'package:myevents/screens/bottom_screen/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardScreen> {
  String _selectedMenu = 'Services';

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF4B0082);
    final lightGrey = Colors.grey.shade200;

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), backgroundColor: purple),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'MY Events',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Divider(),

              _buildDrawerItem('Services', Icons.event, () {
                setState(() {
                  _selectedMenu = 'Services';
                });
                Navigator.pop(context);
              }),
              _buildDrawerItem('Home', Icons.home, () {
                setState(() {
                  _selectedMenu = 'Home';
                });
                Navigator.pop(context); // closes drawer only
              }),

              _buildDrawerItem('Notification', Icons.notifications, () {}),
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
    if (_selectedMenu == 'Services') {
      return Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _serviceCard('Banquet'),
                _serviceCard('Decoration Packages'),
                _serviceCard('Photography / Video'),
              ],
            ),
          ],
        ),
      );
    }

    if (_selectedMenu == 'Home') {
      return HomeScreen();
    }

    return Center(child: Text('$_selectedMenu page — under construction'));
  }

  Widget _serviceCard(String title) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
