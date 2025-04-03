import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Badges());
}

class Badges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achievement Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        dividerColor: Colors.grey[300],
      ),
      home: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Achievements', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue[800],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: AchievementsPage(),
        ),
      ),
    );
  }
}

class AchievementsPage extends StatefulWidget {
  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final List<Achievement> achievements = [
    Achievement(
      title: 'Post on Discussion',
      description: 'Post a message on the discussion board.',
      imagePath: 'assets/bronze.png',
    ),
    Achievement(
      title: 'Create a Task',
      description: 'Add a new task to your task list.',
      imagePath: 'assets/silver.png',
    ),
    Achievement(
      title: 'Create a Category',
      description: 'Create a new category for organizing tasks.',
      imagePath: 'assets/gold.png',
    ),
  ];

  int completedCount = 0;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _loadAchievements();
    }
  }

  Future<void> _loadAchievements() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            for (var achievement in achievements) {
              if (achievement.title == 'Setup your Profile') {
                var personalNote = data['personalNote'] as String? ?? '';
                achievement.isCompleted = personalNote.isNotEmpty;
              } else {
                achievement.isCompleted = data[achievement.title] ?? false;
              }
            }
            completedCount = achievements.where((a) => a.isCompleted).length;
          });
        }
      }
    } catch (e) {
      print("Error loading achievements: $e");
    }
  }

  void _toggleAchievement(Achievement achievement) async {
    setState(() {
      achievement.isCompleted = !achievement.isCompleted;
      completedCount = achievements.where((a) => a.isCompleted).length;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .set({
        achievement.title: achievement.isCompleted,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating achievement: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalAchievements = achievements.length.toInt();
    double progress = completedCount / totalAchievements;

    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/Achievement.png',
            width: 150,
            height: 150,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Text('Failed to load image');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "You've achieved ($completedCount/$totalAchievements)",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
            minHeight: 8.0,
          ),
        ),
        SizedBox(height: 40),
        Expanded(
          child: ListView.builder(
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              var achievement = achievements[index];
              return ListTile(
                leading: achievement.imagePath != null
                    ? Container(
                        width: 48,
                        height: 48,
                        child: Image.asset(
                          achievement.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                      )
                    : Icon(achievement.icon,
                        size: 48,
                        color: achievement.isCompleted
                            ? Colors.green
                            : Colors.blue[800]),
                title: Text(achievement.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: achievement.isCompleted
                            ? Colors.green
                            : Colors.blue[900])),
                subtitle: Text(achievement.description,
                    style: TextStyle(color: Colors.grey[800])),
                trailing: Icon(
                  achievement.isCompleted
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: achievement.isCompleted ? Colors.green : Colors.grey,
                  size: 30,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class Achievement {
  String title;
  String description;
  IconData? icon;
  String? imagePath;
  bool isCompleted = false;

  Achievement({
    required this.title,
    required this.description,
    this.icon,
    this.imagePath,
  }) : assert(icon != null || imagePath != null,
            'An icon or an image must be provided.');
}
