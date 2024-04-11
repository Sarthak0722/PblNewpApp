import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Notes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notes')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No notes found.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return NoteCard(
                note: Note(
                  id: document.id,
                  title: data['title'],
                  content: data['content'],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteDetailsPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}

class Note {
  final String id;
  final String title;
  final String content;

  Note({
    required this.id,
    required this.title,
    required this.content,
  });
}

class NoteDetailsPage extends StatefulWidget {
  final Note? note;

  NoteDetailsPage({this.note});

  @override
  _NoteDetailsPageState createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
    _requestMicrophonePermission(); // Request microphone permission when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Create Note' : 'Edit Note'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Content',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.text, // Set keyboard type to text
              textInputAction:
                  TextInputAction.done, // Set text input action to done
              enableSuggestions: true, // Enable word suggestions
              autocorrect: true, // Enable autocorrect
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveNote();
                Navigator.pop(context);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      // Handle permission denied
      print('Microphone permission denied');
    }
  }

  void _saveNote() {
    if (widget.note == null) {
      FirebaseFirestore.instance
          .collection('students')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notes')
          .add({
        'title': _titleController.text,
        'content': _contentController.text,
      });
    } else {
      FirebaseFirestore.instance
          .collection('students')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notes')
          .doc(widget.note!.id)
          .update({
        'title': _titleController.text,
        'content': _contentController.text,
      });
    }
  }
}

class NoteCard extends StatefulWidget {
  final Note note;

  NoteCard({required this.note});

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool isEditing = false;
  late String editedTitle;
  late String editedContent;
  late TextEditingController _titleEditingController;
  late TextEditingController _contentEditingController;

  @override
  void initState() {
    super.initState();
    editedTitle = widget.note.title;
    editedContent = widget.note.content;
    _titleEditingController = TextEditingController(text: editedTitle);
    _contentEditingController = TextEditingController(text: editedContent);
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: ExpansionTile(
        title: isEditing
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleEditingController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              )
            : Text(
                editedTitle,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isEditing
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _contentEditingController,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Content',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              _saveChanges();
                            },
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        editedContent,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                            color: Colors.deepPurple,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteNote();
                            },
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _deleteNote() {
    FirebaseFirestore.instance
        .collection('students')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .doc(widget.note.id)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete note'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _saveChanges() {
    FirebaseFirestore.instance
        .collection('students')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .doc(widget.note.id)
        .update({
      'title': _titleEditingController.text,
      'content': _contentEditingController.text,
    }).then((value) {
      setState(() {
        isEditing = false;
        editedTitle = _titleEditingController.text;
        editedContent = _contentEditingController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update note'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: NotesPage(),
  ));
}
