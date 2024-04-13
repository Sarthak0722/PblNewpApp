import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: EventCalendarScreen(),
  ));
}

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);
  static const route = '/eventCalendarScreen';

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  TimeOfDay? _selectedTime; // Added for event time

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;

    loadPreviousEvents();
    fetchEvents();
  }

  loadPreviousEvents() {
    mySelectedEvents = {
      "2022-09-13": [
        {"eventDescp": "11", "eventTitle": "111", "eventTime": "12:00"},
        {"eventDescp": "22", "eventTitle": "22", "eventTime": "13:00"}
      ],
      "2022-09-30": [
        {"eventDescp": "22", "eventTitle": "22", "eventTime": "14:00"}
      ],
      "2022-09-20": [
        {"eventTitle": "ss", "eventDescp": "ss", "eventTime": "15:00"}
      ]
    };
  }

  fetchEvents() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('events')
            .get();

        Map<String, List> events = {};

        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> eventData = doc.data() as Map<String, dynamic>;
          String eventDate = eventData['eventDate'];
          String eventTitle = eventData['eventTitle'];
          String eventDescp = eventData['eventDescp'];
          String eventTime = eventData['eventTime']; // Added for event time
          String eventId = doc.id;

          events.putIfAbsent(eventDate, () => []);
          events[eventDate]!.add({
            'eventTitle': eventTitle,
            'eventDescp': eventDescp,
            'eventTime': eventTime,
            'eventId': eventId,
          });
        });

        setState(() {
          mySelectedEvents = events;
        });
      } catch (e) {
        print('Error fetching events: $e');
      }
    }
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  _showEditDeleteEventDialog(Map event) async {
    titleController.text = event['eventTitle'];
    descpController.text = event['eventDescp'];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit/Delete Event',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            // Added for event time
            ListTile(
              title: Text(
                'Event Time: ${event['eventTime']}',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .collection('events')
                  .doc(event['eventId'])
                  .update({
                'eventTitle': titleController.text,
                'eventDescp': descpController.text,
              });

              fetchEvents();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event updated successfully'),
                  duration: Duration(seconds: 2),
                ),
              );

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () async {
              await _firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .collection('events')
                  .doc(event['eventId'])
                  .delete();

              fetchEvents();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event deleted successfully'),
                  duration: Duration(seconds: 2),
                ),
              );

              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 166, 19, 240),
                Color.fromARGB(255, 110, 23, 233)
              ], // Your gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2022),
            lastDay: DateTime(2024, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _listOfDayEvents,
          ),
          ..._listOfDayEvents(_selectedDate!).map(
            (myEvents) => ListTile(
              onTap: () => _showEditDeleteEventDialog(myEvents),
              leading: const Icon(
                Icons.done,
                color: Colors.teal,
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Event Title:   ${myEvents['eventTitle']}'),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description:   ${myEvents['eventDescp']}'),
                  Text('Time: ${myEvents['eventTime']}'),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        label: const Text('Add Event'),
      ),
    );
  }

  _showAddEventDialog() async {
    titleController.clear(); // Clear title field
    descpController.clear(); // Clear description field

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Event',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            // Added for event time
            ListTile(
              title: Text(
                _selectedTime != null
                    ? 'Event Time: ${_selectedTime!.format(context)}'
                    : 'Select Time',
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null && pickedTime != _selectedTime) {
                    setState(() {
                      _selectedTime = pickedTime;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            child: const Text('Add Event'),
            onPressed: () {
              if (titleController.text.isEmpty &&
                  descpController.text.isEmpty &&
                  _selectedTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Required title, description, and time'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                User? user = _auth.currentUser;

                if (user != null) {
                  String userId = user.uid;

                  _firestore
                      .collection('users')
                      .doc(userId)
                      .collection('events')
                      .add({
                    'eventDate':
                        DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    'eventTitle': titleController.text,
                    'eventDescp': descpController.text,
                    'eventTime':
                        _selectedTime!.format(context), // Added event time
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Event added successfully'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    fetchEvents();

                    titleController.clear();
                    descpController.clear();
                    _selectedTime = null; // Clear selected time
                    Navigator.pop(context);
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add event: $error'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                }
              }
            },
          )
        ],
      ),
    );
  }
}
