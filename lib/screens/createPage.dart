import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  String dropdownValue = 'First Year';
  bool switchValue = false;
  final List<String> dropdownMenuItems = [
    'First Year', 
    'Second Year', 
    'Third Year', 
    'Fourth Year', 
    'Fifth Year'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student Data'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(hintText: 'First Name'),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(hintText: 'Last Name'),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: courseController,
            decoration: const InputDecoration(hintText: 'Course'),
          ),
          const SizedBox(height: 20,),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.menu),
            items: dropdownMenuItems.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item)
                );
            }).toList(), 
            onChanged: (String? newDropdownValue) {
              setState(() {
                dropdownValue = newDropdownValue!;
              });
            },
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              const Text('Enrolled'),
              const SizedBox(width: 20,),
              Switch(
                value: switchValue, 
                onChanged: (newSwitchValue) {
                  setState(() {
                    switchValue = newSwitchValue;
                  });
                })
            ],
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: submitData, 
            child: const Text('Submit')
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final course = courseController.text;
    final yearLevel = dropdownValue;
    final isEnrolled = switchValue;
    
    final body = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "course": course,
      "yearLevel": yearLevel,
      "isEnrolled": isEnrolled,
      "isSuccess": false,
    });

    const url = 'http://localhost/crud/create.php';
    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully added student
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student successfully added!')),
        );
        // Optionally clear form after submission
        clearForm();
      } else {
        // Failed to add student
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add student')),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    courseController.clear();
    setState(() {
      dropdownValue = 'First Year';
      switchValue = false;
    });
  }
}
  