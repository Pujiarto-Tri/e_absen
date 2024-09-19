import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  const CountdownTimerWidget({super.key});

  @override
  CountdownTimerWidgetState createState() => CountdownTimerWidgetState();
}

class CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late DateTime _targetTime;
  String _countdown = "";

  @override
  void initState() {
    super.initState();
    _targetTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      16,
      0,
      0,
    );
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = _targetTime.difference(now);

      // If the countdown reaches zero, cancel the timer
      if (difference.isNegative) {
        setState(() {
          _countdown = "Time's up!";
        });
        _timer.cancel();
      } else {
        // Update the countdown string
        setState(() {
          _countdown = "${difference.inHours.toString().padLeft(2, '0')}:"
              "${(difference.inMinutes % 60).toString().padLeft(2, '0')}:"
              "${(difference.inSeconds % 60).toString().padLeft(2, '0')}";
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _countdown,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
