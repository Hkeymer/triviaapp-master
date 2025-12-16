import 'dart:async';
import 'package:flutter/material.dart';

class TimerBar extends StatefulWidget {
  final int durationSeconds;
  final VoidCallback onTimeUp;

  const TimerBar({
    super.key,
    required this.durationSeconds,
    required this.onTimeUp,
  });

  @override
  State<TimerBar> createState() => _TimerBarState();
}

class _TimerBarState extends State<TimerBar> {
  late double progress; // Valor 1.0 a 0.0
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(TimerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.durationSeconds != widget.durationSeconds) {
      _restart();
    }
  }

  void _startTimer() {
    progress = 1.0;
    final totalMillis = widget.durationSeconds * 1000;
    final interval = 50;

    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        progress -= interval / totalMillis;
        if (progress <= 0) {
          progress = 0;
          _timer?.cancel();
          widget.onTimeUp();
        }
      });
    });
  }

  void _restart() {
    _timer?.cancel();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 12,
        backgroundColor: Colors.grey.shade300,
        color: progress > 0.3 ? Colors.green : Colors.red,
      ),
    );
  }
}
