import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Countdown24h extends StatefulWidget {
  const Countdown24h({super.key});

  @override
  State<Countdown24h> createState() => _Countdown24hState();
}

class _Countdown24hState extends State<Countdown24h> {
  static const String _keyTargetTime = 'countdown_target_time';

  DateTime? _targetTime;
  Duration _remaining = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadOrCreateTargetTime();
  }

  Future<void> _loadOrCreateTargetTime() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyTargetTime);

    if (stored != null) {
      _targetTime = DateTime.parse(stored);
    } else {
      _targetTime = DateTime.now().add(const Duration(hours: 24));
      await prefs.setString(
        _keyTargetTime,
        _targetTime!.toIso8601String(),
      );
    }

    _startTimer();
  }

  void _startTimer() {
    _updateRemaining();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    if (_targetTime == null) return;

    final diff = _targetTime!.difference(DateTime.now());

    if (diff.isNegative) {
      _timer?.cancel();
      setState(() {
        _remaining = Duration.zero;
      });
    } else {
      setState(() {
        _remaining = diff;
      });
    }
  }

  String _format(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _format(_remaining),
      style: Theme.of(context).textTheme.headlineSmall ?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
