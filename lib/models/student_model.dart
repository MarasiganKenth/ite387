import 'package:equatable/equatable.dart';

class Student extends Equatable{
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final String yearLevel;
  final bool isEnrolled;

  const Student({ 
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.yearLevel,
    required this.isEnrolled
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      course: json['course'],
      yearLevel: json['yearLevel'],
      isEnrolled: json['isEnrolled'] == '1' || json['isEnrolled'] == true,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'firstName': firstName,
      'lastName': lastName,
      'course': course,
      'yearLevel': yearLevel,
      'isEnrolled': isEnrolled ? 1 : 0
    };
  }
  
  @override
  List<Object> get props => [id, firstName, lastName, course, yearLevel, isEnrolled];
}