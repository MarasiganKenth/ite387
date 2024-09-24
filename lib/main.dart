import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ite387/bloc/student_bloc.dart';
import 'package:ite387/bloc/student_event.dart';
import 'package:ite387/repositories/student_repository.dart';
import 'screens/homePage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => StudentBloc(StudentRepository())..add(FetchStudent()),
        child: const Homepage(),
      ),
    );
  }
}