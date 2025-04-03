import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: FeedbackForm(),
    debugShowCheckedModeBanner: false,
  ));
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String feedback = '';
  String subject = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  void sendEmail(String userEmail) async {
    String username = 'medo246mmy@gmail.com';
    String password = 'zyqetkqjclbwipid';

    final smtpServer = gmail(username, password);

    String recipientEmail = 'medo246mmy@gmail.com';

    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = 'Name: $name\nEmail: $userEmail\nFeedback: $feedback';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            Icon(Icons.feedback),
            SizedBox(width: 10),
            Text(
              'Feedback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: Icon(Icons.subject, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
                onSaved: (value) => subject = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  prefixIcon: Icon(Icons.feedback, color: Colors.blue),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  alignLabelWithHint: false,
                ),
                maxLines: 3,
                textAlignVertical: TextAlignVertical.top,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
                onSaved: (value) => feedback = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    User? user = _auth.currentUser;
                    if (user != null) {
                      sendEmail(user.email!);
                      print('Form Submitted');
                    } else {
                      print('User not logged in');
                    }
                  }
                },
                child: Text('SUBMIT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
