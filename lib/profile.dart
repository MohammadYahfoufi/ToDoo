import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last/login.dart';
import 'auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _notes;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _usernameController.text = _authService.getCurrentUser()?.displayName ?? '';
    _notes = await _authService.getBio();
    _notesController.text = _notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await _authService.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: currentUser == null
            ? Center(child: Text('No user is currently signed in.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          currentUser.displayName ?? 'No username available',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditUsernameDialog(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Email:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    currentUser.email ?? 'No email available',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Personal Note:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter your personal note',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _authService.updateBio(_notesController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Personal note updated successfully'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: Text('Save Personal Note'),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _authService.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                      ),
                      child: Text('Sign Out'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _showEditUsernameDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Username'),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(hintText: 'Enter new username'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newUsername = _usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  await _authService.updateUsername(newUsername);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Username updated successfully'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue,
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
