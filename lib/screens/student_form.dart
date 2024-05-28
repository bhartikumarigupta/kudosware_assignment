import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _gender = 'Male';

  IconData _genderIcon = Icons.man;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the student\'s name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dobController.text =
                        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                  });
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the date of birth';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                  _genderIcon = value == 'Male' ? Icons.man : Icons.woman;
                });
              },
              items: ['Male', 'Female'].map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(_genderIcon, color: Colors.blue),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select a gender';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.lightBlue,
                    Colors.lightBlueAccent,
                    Colors.blueAccent,
                  ],
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance.collection('students').add({
                      'name': _nameController.text,
                      'dob': _dobController.text,
                      'gender': _gender,
                    });
                    _nameController.clear();
                    _dobController.clear();
                    setState(() {
                      _gender = 'Male';
                    });
                  }
                },
                child: Center(
                  child: Text('Add Student',
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
