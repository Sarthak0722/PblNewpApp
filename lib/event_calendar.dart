import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

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
        {"eventDescp": "11", "eventTitle": "111"},
        {"eventDescp": "22", "eventTitle": "22"}
      ],
      "2022-09-30": [
        {"eventDescp": "22", "eventTitle": "22"}
      ],
      "2022-09-20": [
        {"eventTitle": "ss", "eventDescp": "ss"}
      ]
    };
  }

  fetchEvents() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('events')
            .doc(userId)
            .collection('user_events')
            .get();

        Map<String, List> events = {};

        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> eventData = doc.data() as Map<String, dynamic>;
          String eventDate = eventData['eventDate'];
          String eventTitle = eventData['eventTitle'];
          String eventDescp = eventData['eventDescp'];
          String eventId = doc.id;

          events.putIfAbsent(eventDate, () => []);
          events[eventDate]!.add({
            'eventTitle': eventTitle,
            'eventDescp': eventDescp,
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _firestore
                  .collection('events')
                  .doc(_auth.currentUser!.uid)
                  .collection('user_events')
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
                  .collection('events')
                  .doc(_auth.currentUser!.uid)
                  .collection('user_events')
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Event Calendar Example'),
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
              subtitle: Text('Description:   ${myEvents['eventDescp']}'),
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
                  descpController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Required title and description'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                User? user = _auth.currentUser;

                if (user != null) {
                  String userId = user.uid;

                  _firestore
                      .collection('events')
                      .doc(userId)
                      .collection('user_events')
                      .add({
                    'eventDate': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    'eventTitle': titleController.text,
                    'eventDescp': descpController.text,
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

void main() {
  runApp(MaterialApp(
    home: EventCalendarScreen(),
  ));
}
