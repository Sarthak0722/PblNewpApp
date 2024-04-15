import 'package:flutter/material.dart';
import 'package:newp/documentPage.dart';
import 'package:newp/login_page.dart';
import 'package:newp/notesPage.dart';
import 'package:newp/pomodoro.dart';
import 'package:newp/event_calendar.dart';
import 'package:newp/timetablePage.dart';
import 'package:newp/todolistPage.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
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
          title: const Text(
            'HOME',
            style: TextStyle(
              fontFamily: 'school',
              color: Colors.white,
              fontSize: 40,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('PRODUCTIVITY HUB'),
                _buildFeatureRow(
                  context,
                  [
                    _buildFeatureItem(
                      context,
                      title: 'To-Do List',
                      imageUrl: 'assets/images/todo.png',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ToDoListPage()),
                      ),
                    ),
                    _buildFeatureItem(
                      context,
                      title: 'Pomodoro Timer',
                      imageUrl: 'assets/images/pomo.png',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Pomodoro()),
                      ),
                    ),
                    _buildFeatureItem(
                      context,
                      title: 'Notes',
                      imageUrl: 'assets/images/note.png',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotesPage()),
                      ),
                    ),
                  ],
                ),
                _buildFeatureRow(
                  context,
                  [
                    _buildFeatureItem(
                      context,
                      title: 'Timetable',
                      imageUrl: 'assets/images/tt.png',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimetablePage()),
                      ),
                    ),
                    _buildFeatureItem(
                      context,
                      title: 'Documents',
                      imageUrl: 'assets/images/doc.png',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocumentUploadScreen()),
                      ),
                    ),
                    _buildFeatureItem(
                      context,
                      title: 'Event Calendar',
                      imageUrl: 'assets/images/sc.png',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventCalendarScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('STRESS MANAGEMENT '),
                _buildFeatureItem(
                  context,
                  title: 'Stress Relief',
                  imageUrl: 'assets/images/med.png',
                  onTap: () {
                    // Implement stress relief feature
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 3),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'school',
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context,
      {required String title,
      required String imageUrl,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.width * 0.28,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'school',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
