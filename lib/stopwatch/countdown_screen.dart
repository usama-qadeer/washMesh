import 'dart:async';

import 'package:flutter/material.dart';

class CountDownScreen extends StatefulWidget {
  const CountDownScreen({Key? key}) : super(key: key);

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  static const countdownDuration = Duration(seconds: 0);
  Duration duration = const Duration();
  Timer? timer;
  bool isCountdown = false;

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 72,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          header,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;

    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isRunning) {
                    stopTimer(resets: false);
                  } else {
                    startTimer(resets: false);
                  }
                },
                child: Text(isRunning ? 'STOP' : 'RESUME'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  stopTimer();
                  Navigator.pop(context, 'working');
                },
                child: const Text('CANCEL'),
              ),
            ],
          )
        : ElevatedButton(
            onPressed: () {
              startTimer();
            },
            child: const Text('Start Timer!'),
          );
  }

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    if (isCountdown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = const Duration());
    }
  }

  void addTimer() {
    final addSeconds = isCountdown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTimer());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTime(),
            const SizedBox(height: 80),
            buildButtons(),
          ],
        ),
      ),
    );
  }
}
