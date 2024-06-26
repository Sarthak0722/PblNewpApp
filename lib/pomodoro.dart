import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newp/usage.dart';
import 'package:newp/widgets/timeroptions.dart';
import 'widgets/timercard.dart';
import 'widgets/timecontroller.dart';
import 'widgets/progress.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:audioplayers/audioplayers.dart';

class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Load the ringtone
    loadRingtone();
  }

  Future<void> loadRingtone() async {
    // No need to load the ringtone
  }

  Future<void> playRingtone() async {
    // Play the ringtone directly
    await audioPlayer.play(AssetSource('sounds/alarm.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text('Pomodoro Timer', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh, color: Colors.white),
          )
        ],
      ),
      drawer: Drawer(
        // Drawer content goes here
        child: ListView(
          children: [
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
            // Add more list items as needed
          ],
        ),
      ),
      //BODY
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: currentstate == 'FOCUS'
              ? AnimateGradient(
                  primaryColors: const [
                    Color.fromARGB(255, 252, 181, 218),
                    Color.fromARGB(255, 248, 136, 174),
                    // Colors.white,
                  ],
                  secondaryColors: const [
                    // Colors.white,
                    Color.fromARGB(255, 232, 159, 245),
                    Color.fromARGB(255, 228, 136, 244),
                  ],
                  child: Expanded(
                    child: Column(
                      children: [
                        timercard(),
                        const SizedBox(height: 25),
                        timeroptions(),
                        const SizedBox(height: 50),
                        timecontroller(),
                        const SizedBox(height: 170),
                        progress(),
                      ],
                    ),
                  ),
                )
              : AnimateGradient(
                  primaryColors: const [
                    Colors.blue,
                    Colors.blueAccent,
                    Colors.white,
                  ],
                  secondaryColors: const [
                    Colors.white,
                    Colors.lightBlue,
                    Colors.lightBlueAccent,
                  ],
                  child: Expanded(
                    child: Column(
                      children: [
                        timercard(),
                        const SizedBox(height: 50),
                        timeroptions(),
                        const SizedBox(height: 50),
                        timecontroller(),
                        const SizedBox(height: 170),
                        progress(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
