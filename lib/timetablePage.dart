import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timetable',
      home: TimetablePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<List<String>> timetable = [
    ['Time', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    ['9:00 AM - 10:00 AM', 'DMSL', 'PSDL', 'PA', 'CG', 'PBL'],
    ['10:00 AM - 11:00 AM', 'DMSL', 'PSDL', 'CG', 'SE', 'PBL'],
    ['11:00 AM - 11:15 AM', 'Break', 'Break', 'Break', 'Break', 'Break'],
    ['11:15 AM - 12:15 PM', 'PA', 'CG', 'CGL', 'DMS', 'DMS'],
    ['12:15 PM - 1:15 PM', 'DMS', 'M3', 'CGL', 'M3', 'SE'],
    ['1:15 PM - 2:00 PM', 'Lunch', 'Lunch', 'Lunch', 'Lunch', 'Lunch'],
    ['2:00 PM - 3:00 PM', 'PBL', 'SE', 'M3', 'DMSL', 'PA'],
    ['3:00 PM - 4:00 PM', 'PBL', 'TUT', '-', 'DMSL', '-'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable'),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Material(
                  elevation: 8.0, // Adjust elevation to give a 3D effect
                  borderRadius: BorderRadius.circular(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 151, 142, 135)),
                        columns: List.generate(
                          timetable[0].length,
                          (index) => DataColumn(
                            label: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text(
                                  timetable[0][index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        rows: List.generate(
                          timetable.length - 1,
                          (rowIndex) => DataRow(
                            cells: List.generate(
                              timetable[rowIndex + 1].length,
                              (cellIndex) => DataCell(
                                InkWell(
                                  onTap: () {
                                    _editCell(rowIndex + 1, cellIndex);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: cellIndex == 0 ? Colors.purple : Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        timetable[rowIndex + 1][cellIndex],
                                        style: TextStyle(
                                          color: cellIndex == 0 ? Colors.white : Colors.black,
                                          fontSize: 16.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editCell(int rowIndex, int cellIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController(text: timetable[rowIndex][cellIndex]);
        return AlertDialog(
          title: Center(child: Text('Edit Cell')),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter value',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Save',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                setState(() {
                  timetable[rowIndex][cellIndex] = controller.text.isEmpty ? '-' : controller.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
