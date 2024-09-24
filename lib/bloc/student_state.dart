import 'package:equatable/equatable.dart';
import 'package:ite387/models/student_model.dart';

abstract class StudentState extends Equatable{
  const StudentState();
  
  @override
  List<Object> get props => [];
}

class StudentLoading extends StudentState{}

class StudentLoaded extends StudentState{
    final List<Student> student;

    const StudentLoaded(this.student);

    @override
    List<Object> get props => [student];
}

class StudentError extends StudentState{
  final String message;

  const StudentError(this.message);

  @override
  List<Object> get props => [message];
}