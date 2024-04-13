import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Task {
  String title;
  bool isCompleted;
  DateTime? dueDate;
  TimeOfDay? dueTime;
  Priority priority;
  String id;

  Task({
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.dueTime,
    this.priority = Priority.low,
    required this.id,
  });
}

enum Priority { low, medium, high }

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  late CollectionReference tasksCollection;
  late String currentUserUID;
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tasksCollection = FirebaseFirestore.instance.collection('users');
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        currentUserUID = user.uid;
        _fetchTasks();
      }
    });
  }

  void _fetchTasks() {
    tasksCollection
        .doc(currentUserUID)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        tasks = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Task(
            title: data['title'],
            isCompleted: data['isCompleted'],
            dueDate: data['dueDate']?.toDate(),
            dueTime: data['dueTime'] != null
                ? TimeOfDay.fromDateTime(DateTime.parse(data['dueTime']))
                : null,
            priority: Priority.values
                .firstWhere((e) => e.toString() == data['priority']),
            id: doc.id,
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wd = MediaQuery.of(context).size.width;
    List<Task> highPriorityTasks = [];
    List<Task> mediumPriorityTasks = [];
    List<Task> lowPriorityTasks = [];

    for (Task task in tasks) {
      if (task.priority == Priority.high) {
        highPriorityTasks.add(task);
      } else if (task.priority == Priority.medium) {
        mediumPriorityTasks.add(task);
      } else {
        lowPriorityTasks.add(task);
      }
    }

    highPriorityTasks.sort((a, b) =>
        (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0)));
    mediumPriorityTasks.sort((a, b) =>
        (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0)));
    lowPriorityTasks.sort((a, b) =>
        (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.purple.shade50,
      body: tasks.isEmpty
          ? Center(
              child: Image.asset(
                'assets/images/waiting.png', // Path to your image asset
                width: wd * 0.7, // Adjust the width as needed
                height: ht * 0.7, // Adjust the height as needed
              ),
            )
          : ListView(
              children: [
                if (highPriorityTasks.isNotEmpty) ...[
                  _buildPrioritySection('High Priority', highPriorityTasks),
                  const Divider(),
                ],
                if (mediumPriorityTasks.isNotEmpty) ...[
                  _buildPrioritySection('Medium Priority', mediumPriorityTasks),
                  const Divider(),
                ],
                if (lowPriorityTasks.isNotEmpty) ...[
                  _buildPrioritySection('Low Priority', lowPriorityTasks),
                  const Divider(),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Task? newTask = await showDialog<Task>(
            context: context,
            builder: (context) => TaskDialog(),
          );
          if (newTask != null) {
            setState(() {
              _addTask(newTask);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPrioritySection(String title, List<Task> tasks) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              elevation: 3,
              shadowColor: Colors.grey,
              child: ListTile(
                title: Text(task.title),
                subtitle: task.dueDate != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Due Date: ${DateFormat('dd-MM-yyyy').format(task.dueDate!)}'),
                          if (task.dueTime != null)
                            Text('Due Time: ${task.dueTime!.format(context)}'),
                        ],
                      )
                    : null,
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      task.isCompleted = value!;
                      _updateTask(task);
                    });
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _deleteTask(task.id);
                    });
                  },
                ),
                onTap: () async {
                  Task? updatedTask = await showDialog<Task>(
                    context: context,
                    builder: (context) => TaskDialog(task: task),
                  );
                  if (updatedTask != null) {
                    setState(() {
                      _updateTask(updatedTask);
                    });
                  }
                },
              ),
            );
          },
        ),
      ],
    ));
  }

  void _addTask(Task newTask) {
    tasksCollection.doc(currentUserUID).collection('tasks').add({
      'title': newTask.title,
      'isCompleted': newTask.isCompleted,
      'dueDate': newTask.dueDate,
      'dueTime':
          newTask.dueTime != null ? newTask.dueTime!.format(context) : null,
      'priority': newTask.priority.toString(),
    }).then((docRef) {
      newTask.id = docRef.id;
      setState(() {
        tasks.add(newTask);
      });
    });
  }

  void _updateTask(Task task) {
    tasksCollection
        .doc(currentUserUID)
        .collection('tasks')
        .doc(task.id)
        .update({
      'title': task.title,
      'isCompleted': task.isCompleted,
      'dueDate': task.dueDate,
      'dueTime': task.dueTime != null ? task.dueTime!.format(context) : null,
      'priority': task.priority.toString(),
    });
  }

  void _deleteTask(String taskId) {
    tasksCollection
        .doc(currentUserUID)
        .collection('tasks')
        .doc(taskId)
        .delete()
        .then((_) {
      setState(() {
        tasks.removeWhere((task) => task.id == taskId);
      });
    });
  }
}

class TaskDialog extends StatefulWidget {
  final Task? task;

  TaskDialog({Key? key, this.task}) : super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late DateTime? _dueDate;
  late TimeOfDay? _dueTime;
  late Priority _priority;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _dueDate = widget.task?.dueDate;
    _dueTime = widget.task?.dueTime;
    _priority = widget.task?.priority ?? Priority.low;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(children: [
          const SizedBox(height: 120),
          AlertDialog(
            title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Task Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Due Date: '),
                      TextButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dueDate = pickedDate;
                            });
                          }
                        },
                        child: Text(_dueDate == null
                            ? 'Select Due Date'
                            : '${DateFormat('dd-MM-yyyy').format(_dueDate!)}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Due Time: '),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay? pickedTime =
                              await _showTimePicker(context);
                          if (pickedTime != null) {
                            setState(() {
                              _dueTime = pickedTime;
                            });
                          }
                        },
                        child: Text(_dueTime == null
                            ? 'Select Due Time'
                            : '${_dueTime!.hourOfPeriod}:${_dueTime!.minute} ${_dueTime!.period == DayPeriod.am ? 'AM' : 'PM'}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Priority>(
                    value: _priority,
                    onChanged: (value) {
                      setState(() {
                        _priority = value!;
                      });
                    },
                    items: Priority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(
                      context,
                      Task(
                        title: _titleController.text,
                        dueDate: _dueDate,
                        dueTime: _dueTime,
                        priority: _priority,
                        id: widget.task?.id ?? '',
                      ),
                    );
                  }
                },
                child: Text(widget.task == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Future<TimeOfDay?> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    return picked;
  }
}

void main() {
  runApp(MaterialApp(
    home: ToDoListPage(),
  ));
}
