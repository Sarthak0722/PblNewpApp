import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DocumentUploadScreen(),
    );
  }
}

class DocumentUploadScreen extends StatefulWidget {
  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _documentsCollection;

  @override
  void initState() {
    super.initState();
    _documentsCollection = _firestore.collection('documents');
  }

  Future<void> _addDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        String fileName = file.name;

        // Check if the document with the same name already exists
        QuerySnapshot querySnapshot = await _documentsCollection
            .where('name', isEqualTo: fileName)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Document already exists, show popup message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Document Already Exists'),
                content: Text(
                    'A document with name "$fileName" already exists.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return; // Exit if the document already exists
        }

        List<int> fileBytes = file.bytes ?? [];
        await _documentsCollection.add({
          'name': fileName,
          'bytes': fileBytes,
        });
        print('Document added successfully');
      } else {
        // User canceled the file picker
        print('File picker canceled');
      }
    } catch (e) {
      print('Error adding document: $e');
    }
  }

void _openDocument(String documentId) async {
  try {
    // Fetch document data from Firestore
    DocumentSnapshot documentSnapshot = await _documentsCollection.doc(documentId).get();
    Map<String, dynamic>? documentData = documentSnapshot.data() as Map<String, dynamic>?; // Explicit cast
    if (documentData != null) {
      List<int>? fileBytes = documentData['bytes'].cast<int>();
      if (fileBytes != null && fileBytes.isNotEmpty) {
        // Write the document bytes to a temporary file
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String filePath = '$tempPath/${documentData['name']}';
        File file = File(filePath);
        await file.writeAsBytes(fileBytes);

        // Open the temporary file using the default application
        if (await canLaunch(filePath)) {
          await launch(filePath);
        } else {
          print('Could not launch file');
        }
      } else {
        print('Error: Document bytes are null or empty');
      }
    } else {
      print('Error: Document data is null');
    }
  } catch (e) {
    print('Error opening document: $e');
  }
}




  Future<void> _deleteDocument(String documentId) async {
    try {
      await _documentsCollection.doc(documentId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Upload'),
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
      body: StreamBuilder(
        stream: _documentsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<DocumentSnapshot> documents =
              snapshot.data!.docs; // Add null check here
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = documents[index];
              String documentId = document.id;
              return ListTile(
                title: Text(document['name']),
                onTap: () => _openDocument(documentId),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteDocument(documentId),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDocument,
        tooltip: 'Upload Document',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
