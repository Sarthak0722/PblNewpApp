import 'package:flutter/material.dart';
import 'dart:async';
import 'package:newp/usage.dart';
import 'timeroptions.dart';

class timerservice extends ChangeNotifier {
  late Timer timer;
  double currentDuration = 1500;
  double selectedTime = 1500;
  bool timerplaying = false;
  int rounds = 0;
  int goals = 0;
  String currentstate = 'FOCUS';

  void start() {
    timerplaying = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentDuration == 0) {
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
}
