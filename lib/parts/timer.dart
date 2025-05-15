import 'package:boxk/providers/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CountdownTimer extends ConsumerStatefulWidget {
  const CountdownTimer({super.key});

  @override
  ConsumerState<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends ConsumerState<CountdownTimer> {
  late DateTime endTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute + 1,
    DateTime.now().second,
  );
  void _getNextPlay() async {
    var now = DateFormat("HH:mm:ss").format(DateTime.now());
    final play = await FirebaseFirestore.instance
        .collection('plays')
        .where('locked_from', isGreaterThan: now)
        .get()
        .then((snapshot) {
      return snapshot.docs[0];
    });

    if (play['name'] != null) {
      ref.read(nextPlayName.notifier).update((state) => play['name']);
      setState(() {
        endTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateFormat("HH:mm").parse(play['locked_from']).hour,
          DateFormat("HH:mm").parse(play['locked_from']).minute,
        );
      });
    } else {
      endTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second + 1,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getNextPlay();
  }

  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
      endTime: endTime,
      enableDescriptions: false,
      spacerWidth: 1,
      timeTextStyle: const TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
      onEnd: () {
        setState(() {
          _getNextPlay();
        });
      },
    );
  }
}
