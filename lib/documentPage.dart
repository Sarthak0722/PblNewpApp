import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HabitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      home: HabitTrackerPage(),
    );
  }
}

class HabitTrackerPage extends StatefulWidget {
  @override
  _HabitTrackerPageState createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final TextEditingController _habitController = TextEditingController();
  List<Map<String, dynamic>> _habits = [];

  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

 void _fetchHabits() {
  _database.child('habits').once().then((DatabaseEvent event) {
    final snapshot = event.snapshot;
    if (snapshot.value != null) {
      final habitData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
      setState(() {
        _habits = habitData.entries.map((entry) => {
          'name': entry.key,
          'completed': entry.value['completed'],
        }).toList();
      });
    } else {
      setState(() {
        _habits = [];
      });
    }
  });
}

  void _addHabit() {
    final String habitName = _habitController.text.trim();
    if (habitName.isNotEmpty) {
      _database.child('habits').push().set({
        'name': habitName,
        'completed': false,
      }).then((_) {
        _habitController.clear();
        _fetchHabits();
      });
    }
  }

  void _toggleHabitCompletion(int index) {
    final habit = _habits[index];
    final bool isCompleted = !habit['completed'];
    _database.child('habits/${_habits.indexOf(habit)}').update({
      'completed': isCompleted,
    }).then((_) {
      setState(() {
        _habits[index]['completed'] = isCompleted;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _habitController,
              decoration: InputDecoration(
                hintText: 'Enter a new habit',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addHabit,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return ListTile(
                  title: Text(habit['name']),
                  trailing: Checkbox(
                    value: habit['completed'],
                    onChanged: (_) => _toggleHabitCompletion(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
