import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ite387/bloc/student_event.dart';
import 'package:ite387/bloc/student_state.dart';
import 'package:ite387/repositories/student_repository.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState>{
  final StudentRepository studentRepository;

  StudentBloc(this.studentRepository) : super(StudentLoading()){
    on<FetchStudent>((event, emit) async {
      try{
        emit(StudentLoading());
        final student = await studentRepository.fetchStudents();
        emit(StudentLoaded(student));
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });

    on<CreateStudent>((event, emit) async {
      try{
        await studentRepository.createStudent(event.student);
        add(FetchStudent());
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });

    on<DeleteStudent>((event, emit) async {
      try{
        await studentRepository.deleteStudent(event.id);
        add(FetchStudent());
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });
    
    on<UpdateStudent>((event, emit) async {
      try{
        await studentRepository.updateStudent(event.id, event.student);
        add(FetchStudent());
      } catch (e) {
        emit(StudentError(e.toString()));
      }
    });
  }
}