import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

const Color lightBlue = Color(0xFFB3E5FC);
const Color mediumBlue = Color(0xFF03A9F4);
const Color lightGrey = Color(0xFFF5F5F5);

class PomodoroTimerPage extends StatefulWidget {
  @override
  _PomodoroTimerPageState createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  static const int workTime = 25;
  static const int shortBreakTime = 5;
  static const int longBreakTime = 15;
  int workSessionCount = 0;
  int secondsRemaining = workTime * 60;
  Timer? timer;
  bool isRunning = false;
  bool isWorkTime = true;
  double _opacity = 1.0;
  final Duration _animationDuration = Duration(seconds: 1);

  void startTimer() {
    if (!isRunning) {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (secondsRemaining > 0) {
          setState(() => secondsRemaining--);
        } else {
          timer?.cancel();
          toggleSessionType();
        }
      });
      setState(() => isRunning = true);
    }
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      secondsRemaining = (isWorkTime
              ? workTime
              : (workSessionCount % 4 == 0 ? longBreakTime : shortBreakTime)) *
          60;
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void toggleSessionType() {
    setState(() {
      _opacity = 0.0;
    });

    Timer(_animationDuration, () {
      setState(() {
        isWorkTime = !isWorkTime;
        if (!isWorkTime) {
          workSessionCount++;
        }
        secondsRemaining = (isWorkTime
                ? workTime
                : (workSessionCount % 4 == 0
                    ? longBreakTime
                    : shortBreakTime)) *
            60;
        _opacity = 1.0;
      });
      startTimer();
    });
  }

  double get percentTimeRemaining =>
      secondsRemaining /
      ((isWorkTime
              ? workTime
              : (workSessionCount % 4 == 0 && !isWorkTime
                  ? longBreakTime
                  : shortBreakTime)) *
          60.0);

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: Text(
          'Pomodoro Timer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mediumBlue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _opacity,
              duration: _animationDuration,
              child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                animation: false,
                percent: 1.0 - percentTimeRemaining,
                center: Text(
                  formatTime(secondsRemaining),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mediumBlue,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: mediumBlue,
                backgroundColor: lightBlue,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildButton('Start', lightBlue, isRunning ? null : startTimer),
                SizedBox(width: 20),
                _buildButton('Pause', lightBlue, isRunning ? pauseTimer : null),
                SizedBox(width: 20),
                _buildButton('Reset', lightBlue, stopTimer),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, void Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
