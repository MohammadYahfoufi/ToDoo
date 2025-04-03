import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService().initNotification();
  runApp(const Noti());
}

class Noti extends StatelessWidget {
  const Noti({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[100],
      ),
      home: const MyHomePage(title: 'Schedule a Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController notificationTitle = TextEditingController();
  final TextEditingController notificationDescription = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _scheduleNotification() async {
    final notificationService = NotificationService();
    await notificationService.initNotification();
    await notificationService.scheduleNotification(
      1,
      notificationTitle.text,
      notificationDescription.text,
      DateTime.now().add(const Duration(minutes: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Schedule a Notification"),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: notificationTitle,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Enter Title",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: notificationDescription,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Enter Description",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              child: Text('Select Date'),
            ),
            ElevatedButton(
              onPressed: () => _pickTime(context),
              child: Text('Select Time'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: _scheduleNotification,
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Schedule Notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    final bool? result = await _flutterLocalNotificationsPlugin
        .initialize(initializationSettings);
    if (result != null && result) {
      print('Notification plugin initialized successfully');
    } else {
      print('Notification plugin initialization failed');
    }
  }

  Future<void> scheduleNotification(
      int id, String title, String description, DateTime scheduledDate) async {
    final tz.TZDateTime scheduledTZDate =
        tz.TZDateTime.from(scheduledDate, tz.local);
    print('Notification scheduled for: $scheduledTZDate');

    await _flutterLocalNotificationsPlugin
        .zonedSchedule(
      id,
      title,
      description,
      scheduledTZDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your_channel_id', 'your_channel_name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    )
        .then((value) {
      print('Notification scheduled successfully');
    }).catchError((error) {
      print('Error scheduling notification: $error');
    });
  }
}
