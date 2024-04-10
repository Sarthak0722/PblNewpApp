import 'package:flutter/material.dart';
import 'package:newp/documentPage.dart';
import 'package:newp/login_page.dart';
import 'package:newp/notesPage.dart';
import 'package:newp/pomodoro.dart';
import 'package:newp/event_calendar.dart';
import 'package:newp/timetablePage.dart';
import 'package:newp/todolistPage.dart';
import 'package:newp/event_calendar.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF9139EF),
          title: const Text(
            'HOME',
            style: TextStyle(
              fontFamily: 'Readex Pro',
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Perform logout action and navigate to login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => loginScreen()),
              );
            },
          ),
          centerTitle: true,
          elevation: 4,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 25, 0, 0),
                child: Text(
                  'STUDY',
                  style: TextStyle(
                    fontFamily: 'Roboto Slab',
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // Change according to your theme
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ToDoListPage()),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://th.bing.com/th/id/OIP.A7sVZIbg-4T39zQmN6Ak5AHaHa?w=196&h=196&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Pomodoro()), // Navigate to Pomodoro Timer page
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            'https://th.bing.com/th/id/OIP.aR2rlMSlqQqrJytQJLuzswAAAA?w=182&h=181&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotesPage()), // Navigate to Notes page
                        );
                        // Navigation logic
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://th.bing.com/th/id/OIP.WsOyXysnvuLy2RO7G72t5QHaHZ?rs=1&pid=ImgDetMain',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'To-Do List',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                    Text(
                      'Pomodoro Timer',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                    Text(
                      'Notes',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
  padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
  child: Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImageUploadScreen()),
          );
        },
        child: Container(
          width: 120,
          height: 120,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.network(
            'https://th.bing.com/th/id/OIP.o1EUCY0lryB4IqNs4jadHAHaHa?w=175&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7',
            fit: BoxFit.cover,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DocumentUploadScreen()),
          );
        },
        child: Container(
          width: 120,
          height: 120,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.network(
            'https://th.bing.com/th/id/OIP.Od_LqdiuldcEnXh8ZZUSLQHaHa?w=201&h=201&c=7&r=0&o=5&dpr=1.5&pid=1.7',
            fit: BoxFit.cover,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCalendarScreen()),
          );
          // Navigation logic
        },
        child: Container(
          width: 120,
          height: 120,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.network(
            'https://th.bing.com/th/id/OIP.tmV4tdGt-3-ZucXd0JqlbgHaFj?w=272&h=203&c=7&r=0&o=5&dpr=1.5&pid=1.7',
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  ),
),



              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Timetable',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                    Text(
                      'Documents',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                    Text(
                      'Schedule',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Stress Management',
                  style: TextStyle(
                    fontFamily: 'Roboto Slab',
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // Change according to your theme
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://th.bing.com/th/id/OIP.LUxy_CA22wg3-LEpmANsEQHaID?w=163&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://th.bing.com/th/id/OIP.6jLKpYKHuRszNY0La9F2wAHaGo?w=193&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://th.bing.com/th/id/OIP.5cauMYIrsQyeCyDLEucp5QHaGc?w=231&h=202&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Meditation\nSounds',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                    Text(
                      'Meditation\nTimer',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                    Text(
                      'Stress Relief\nTechniques',
                      style: TextStyle(
                        // Adjust the style according to your theme
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
