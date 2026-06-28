import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/student_model.dart';
import '../widgets/student_card.dart';
import '../widgets/confirm_delete_dialog.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final DBHelper _dbHelper = DBHelper();
  final TextEditingController _searchController = TextEditingController();

  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load all students from SQLite
  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    final students = await _dbHelper.getStudents();

    setState(() {
      _students = students;
      _isLoading = false;
    });
  }

  // Search students by name as the user types
  Future<void> _searchStudents(String keyword) async {
    setState(() {
      _isLoading = true;
    });

    final students = keyword.trim().isEmpty
        ? await _dbHelper.getStudents()
        : await _dbHelper.searchStudents(keyword.trim());

    setState(() {
      _students = students;
      _isLoading = false;
    });
  }

  // Navigate to Add Student screen, then refresh list on return
  Future<void> _goToAddStudent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddStudentScreen()),
    );

    if (result == true) {
      _loadStudents();
    }
  }

  // Navigate to Edit Student screen, then refresh list on return
  Future<void> _goToEditStudent(Student student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(student: student),
      ),
    );

    if (result == true) {
      _loadStudents();
    }
  }

  // Show confirmation dialog, then delete if confirmed
  Future<void> _deleteStudent(Student student) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      studentName: student.name,
    );

    if (confirmed == true) {
      await _dbHelper.deleteStudent(student.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${student.name} deleted successfully')),
      );

      _loadStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search students by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchStudents('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {}); // refresh suffix icon (clear button)
                _searchStudents(value);
              },
            ),
          ),

          // Student count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total Students: ${_students.length}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // List or empty state
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _students.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No students yet.\nTap + to add one.'
                                  : 'No students found.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          final student = _students[index];
                          return StudentCard(
                            student: student,
                            onEdit: () => _goToEditStudent(student),
                            onDelete: () => _deleteStudent(student),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddStudent,
        backgroundColor: Colors.indigo,
        tooltip: 'Add Student',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}