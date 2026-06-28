class Student {
  int? id;
  String name;
  String studentId;
  String email;
  String department;

  Student({
    this.id,
    required this.name,
    required this.studentId,
    required this.email,
    required this.department,
  });

  // Convert a Student object into a Map.
  // Used when inserting or updating data in SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studentId': studentId,
      'email': email,
      'department': department,
    };
  }

  // Convert a Map (row from SQLite) into a Student object.
  // Used when reading data from the database.
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      studentId: map['studentId'],
      email: map['email'],
      department: map['department'],
    );
  }
}