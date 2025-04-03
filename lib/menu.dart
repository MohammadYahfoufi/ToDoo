import 'package:flutter/material.dart';
import 'package:last/PomodoroTimerPage.dart';
import 'package:last/category.dart';
import 'package:last/discussion.dart';
import 'package:last/helpcenter.dart';
import 'package:last/badges.dart';
import 'package:last/profile.dart';

class UnifiedDrawer extends StatefulWidget {
  @override
  _UnifiedDrawerState createState() => _UnifiedDrawerState();
}

class _UnifiedDrawerState extends State<UnifiedDrawer> {
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_showSettings ? 'Settings' : 'Menu',
              style: TextStyle(color: Colors.white)),
          leading: _showSettings
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => setState(() => _showSettings = false),
                )
              : null,
          backgroundColor: Colors.blue,
        ),
        body: _showSettings ? _buildSettings() : _buildMenu(),
      ),
    );
  }

  Widget _buildMenu() {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Discussion'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TodoDiscussionPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.badge),
          title: Text('Badges'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Badges()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.group),
          title: Text('PomOdoro Timer'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PomodoroTimerPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () => setState(() => _showSettings = true),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildSettings() {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help Center'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedbackForm()),
            );
          },
        ),
      ],
    );
  }
}
