import 'dart:convert';
import 'package:ite387/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class StudentRepository{
  final String baseUrl = 'http://localhost/crud';
  final logger = Logger();

  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> createStudent(Student student) async {
    try {

      final response = await http.post(
        Uri.parse('$baseUrl/create.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to create student: ${response.body}');
      }
    } catch (error) {
      logger.e('Error occurred: ${error.toString()}');
      throw Exception('Failed to create student: ${error.toString()}');
    }
  }



  Future<void> deleteStudent(int id) async{
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'id': id})
      );
      
      if (response.statusCode != 200){
        throw Exception('Failed to delete student: $response.body');
      }
    }catch (e) {
      logger.e('Delete Error: $e');
      rethrow;
    }
  }

  Future<void> updateStudent(int id, Student student) async{
    final response = await http.put(
      Uri.parse('$baseUrl/update.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(student.toJson())
    );

    if (response.statusCode != 200){
      throw Exception('Failed to update student');
    }
  }
}