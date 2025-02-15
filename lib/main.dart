import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student App')),
      body: const FirestoreData(),
      floatingActionButton: const AddStudentButton(),
    );
  }
}

class AddStudentButton extends StatelessWidget {
  const AddStudentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AddEditStudentDialog();
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

class AddEditStudentDialog extends StatefulWidget {
  final Map<String, dynamic>? studentData;
  final String? docId;

  const AddEditStudentDialog({super.key, this.studentData, this.docId});

  @override
  State<AddEditStudentDialog> createState() => _AddEditStudentDialogState();
}

class _AddEditStudentDialogState extends State<AddEditStudentDialog> {
  late TextEditingController nameController;
  late TextEditingController studentIdController;
  late TextEditingController majorController;
  late TextEditingController yearController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    studentIdController = TextEditingController();
    majorController = TextEditingController();
    yearController = TextEditingController();

    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.studentData != null) {
      nameController.text = widget.studentData!['name'] ?? '';
      studentIdController.text = widget.studentData!['student_id'] ?? '';
      majorController.text = widget.studentData!['major'] ?? '';
      yearController.text = widget.studentData!['year'] ?? '';
    }
  }

  @override
  void didUpdateWidget(covariant AddEditStudentDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeControllers();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.studentData == null ? 'Add Student' : 'Edit Student'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameController, 'Name'),
            _buildTextField(studentIdController, 'Student ID'),
            _buildTextField(majorController, 'Major'),
            _buildTextField(yearController, 'Year'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            var data = {
              'name': nameController.text,
              'student_id': studentIdController.text,
              'major': majorController.text,
              'year': yearController.text,
            };

            if (widget.docId == null) {
              await FirebaseFirestore.instance.collection('students').add(data);
            } else {
              await FirebaseFirestore.instance
                  .collection('students')
                  .doc(widget.docId)
                  .update(data);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class FirestoreData extends StatelessWidget {
  const FirestoreData({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;

            final name = data['name'] ?? '';
            final studentId = data['student_id'] ?? '';
            final major = data['major'] ?? '';
            final year = data['year'] ?? '';

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('$studentId - $major - $year'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddEditStudentDialog(
                              studentData: data, docId: docId),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('students')
                            .doc(docId)
                            .delete();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
