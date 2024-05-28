import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No students found.'));
          }
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot student = snapshot.data!.docs[index];
              return StudentListItem(student: student);
            },
            separatorBuilder: (context, index) => Divider(),
          );
        },
      ),
    );
  }
}

class StudentListItem extends StatelessWidget {
  final DocumentSnapshot student;

  const StudentListItem({required this.student});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: CircleAvatar(
        child: Text(
          student['name'][0],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(student['name'], style: TextStyle(fontSize: 20)),
      subtitle: Text(
        'DOB: ${student['dob']} - Gender: ${student['gender']}',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
