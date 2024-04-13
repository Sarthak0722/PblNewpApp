import 'package:flutter/material.dart';
import 'dart:async';
import 'package:newp/usage.dart';
import 'timeroptions.dart';
import 'package:audioplayers/audioplayers.dart';

class timerservice extends ChangeNotifier {
  late Timer timer;
  double currentDuration = 1500;
  double selectedTime = 1500;
  bool timerplaying = false;
  int rounds = 0;
  int goals = 0;
  String currentstate = 'FOCUS';

  final Player = AudioPlayer();

  void start() {
    timerplaying = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (currentDuration == 0) {
        await playSound(); // Wait for the sound to finish playing
        handlenextround();
      } else {
        currentDuration--;
        notifyListeners();
      }
    });
  }

  handlenextround() {
    if (currentstate == 'FOCUS' && rounds != 3) {
      currentstate = 'BREAK';
      currentDuration = 300;
      rounds++;
      goals++;
    } else if (currentstate == 'BREAK') {
      currentstate = 'FOCUS';
      currentDuration = 1500;
      selectedTime = 1500;
    } else if (currentstate == 'FOCUS' && rounds == 3) {
      currentstate = 'LONGBREAK';
      currentDuration = 1500;
      selectedTime = 1500;
      rounds++;
      goals++;
    } else if (currentstate == 'LONGBREAK') {
      currentstate = 'FOCUS';
      currentDuration = 1500;
      selectedTime = 1500;
      rounds = 0;
    }
    notifyListeners();
  }

  void pause() {
    timerplaying = false;
    timer.cancel();
    notifyListeners();
  }

  void selectTime(double seconds) {
    selectedTime = seconds;
    currentDuration = seconds;
    notifyListeners();
  }

  Future<void> playSound() async {
    String audioPath = "sounds/alarm.mp3";
    await Player.play(AssetSource(audioPath));
  }
}
