// ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_typing_uninitialized_variables, unused_field
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
// import 'package:path_provider/path_provider.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  late List<Map<String, dynamic>> _studentList;
  bool isLoaded = false;
  String date = '';
  String subject = '';
  String semester = '';
  String slot = '';
  var userCollection;
  var userStream;
  var currentDateCollection;
  var currentDateStream;
  var userData;
  List<List<String>> csvData = [];
  List<Map<String, dynamic>> user = [];

  _StudentListState() {
    subject = Get.arguments['subject'];
    semester = Get.arguments['semester'];
    date = Get.arguments['date'];
    slot = Get.arguments['slot'];
    // print(subject + " " + semester + " " + date);
    userCollection = FirebaseFirestore.instance.collection('Student');
    userStream = FirebaseFirestore.instance.collection('Student').snapshots();

    currentDateCollection =
        FirebaseFirestore.instance.collection(date).doc("$semester Slot $slot");

    currentDateStream = FirebaseFirestore.instance.collection(date).snapshots();
  }

  Widget studentListBody() {
    return Center(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Attendance").snapshots(),
              builder: (context, attendanceSnapshot) {
                if (attendanceSnapshot.hasError) {
                  return const Text("Error");
                }
                if (attendanceSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (attendanceSnapshot.hasData) {
                  List<dynamic> presentEmails = [];

                  attendanceSnapshot.data!.docs.forEach((element) {
                    if (element.id == "${date}_${semester}_${subject}_${slot}") {
                      Map<String, dynamic> data =
                          element.data()! as Map<String, dynamic>;
                      presentEmails = data["present"] as List<dynamic>? ?? [];
                    }
                  });

                  return StreamBuilder<QuerySnapshot>(
                    stream: userStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        user = [];
                        int presentCount = 0;
                        snapshot.data!.docs.forEach((element) {
                          if (element.id == "$semester Slot $slot") {
                            Map<String, dynamic> userLocal =
                                element.data() as Map<String, dynamic>;

                            for (var i = 0;
                                i < userLocal["Students"].length;
                                i++) {
                              if (presentEmails.contains(
                                  userLocal["Students"][i]["Email"])) {
                                userLocal["Students"][i]["Status"] = "Present";
                                presentCount++;
                              } else {
                                userLocal["Students"][i]["Status"] = "Absent";
                              }
                              user.add(userLocal["Students"][i]);
                            }
                          }
                        });
                        return Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                                "Present: $presentCount/${user.length} students"),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: ListView.separated(
                                  itemCount: user.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: user[index]['Status'] ==
                                                      'Present'
                                                  ? const Color.fromRGBO(
                                                      16, 142, 54, 0.8)
                                                  : const Color.fromRGBO(
                                                      185,
                                                      5,
                                                      5,
                                                      0.8),
                                              width: 8.0,
                                            ),
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                              user[index]['Register number']),
                                          subtitle: Text(user[index]['Name']),
                                          trailing: Text(user[index]['Status']),
                                        ));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider(
                                      color: Colors.black,
                                    );
                                  },
                                ),
                              ),
                            ),
                                SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    generateCSV();
                                  },
                                  child: const Text('Export CSV'),
                                ))
                          ],
                        );
                      }

                      return const Text("No Data");
                    },
                  );
                }
                return const Text("No data");
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: studentListBody(),
    );
    // return StudentListBody();
  }

  Future<void> generateCSV() async {
    List<String> rowHeader = ["Register Number", "Name", "Present/Absent"];
    List<List<dynamic>> rows = [];
    rows.add(rowHeader);
    for (int i = 0; i < user.length; i++) {
      List<dynamic> dataRow = [];
      dataRow.add(user[i]['Register number']);
      dataRow.add(user[i]['Name']);
      dataRow.add(user[i]['Status']);
      rows.add(dataRow);
    }

    try {
      String csv = const ListToCsvConverter().convert(rows);
      final String fileName = '${date}_${semester}_${subject}_Slot-${slot}.csv';
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(csv.codeUnits),
        ext: 'csv',
        mimeType: MimeType.csv,
      );
      print('CSV file saved as $fileName');
      await _showSnackBar('CSV file downloaded successfully');
    } catch (e) {
      print("Error creating file!");
      print(e);
      _showSnackBar('Error downloading CSV: $e');
    }
  }

  Future<void> _showSnackBar(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
