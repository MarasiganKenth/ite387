import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ite387/bloc/student_bloc.dart';
import 'package:ite387/bloc/student_event.dart';
import 'package:ite387/bloc/student_state.dart';
import 'package:ite387/models/student_model.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showStudentDialog(context, isUpdate: false),
          ),
        ],
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentLoaded) {
            return ListView.builder(
              itemCount: state.student.length,
              itemBuilder: (context, index) {
                final student = state.student[index];
                return ListTile(
                  title: Text(student.firstName),
                  subtitle: Text(student.lastName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showStudentDialog(context,
                            student: student, isUpdate: true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => BlocProvider.of<StudentBloc>(context)
                            .add(DeleteStudent(student.id)),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is StudentError) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
    );
  }
  
  void _showStudentDialog(BuildContext context, {Student? student, required bool isUpdate}) {
  final firstNameController = TextEditingController(text: student?.firstName ?? '');
  final lastNameController = TextEditingController(text: student?.lastName ?? '');
  final courseController = TextEditingController(text: student?.course ?? '');

  String dropdownValue = student?.yearLevel ?? 'First Year';
  bool isEnrolled = student?.isEnrolled ?? false;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(isUpdate ? 'Update Student' : 'Create Student'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: courseController,
                  decoration: const InputDecoration(labelText: 'Course'),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    }
                  },
                  items: <String>['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SwitchListTile(
                  title: const Text('Is Enrolled'),
                  value: isEnrolled,
                  onChanged: (bool value) {
                    setState(() {
                      isEnrolled = value;
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final studentBloc = BlocProvider.of<StudentBloc>(context);
              final newStudent = Student(
                id: isUpdate ? student!.id : 0,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                course: courseController.text,
                yearLevel: dropdownValue,
                isEnrolled: isEnrolled,
              );
              if (isUpdate) {
                studentBloc.add(UpdateStudent(newStudent.id, newStudent));
              } else {
                studentBloc.add(CreateStudent(newStudent));
              }
              Navigator.pop(dialogContext);
            },
            child: Text(isUpdate ? 'Update' : 'Create'),
          ),
        ],
      );
    },
  );
}

}