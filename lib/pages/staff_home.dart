// ignore_for_file: use_build_context_synchronously, unnecessary_new, avoid_print, depend_on_referenced_packages, unused_import, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

// import 'dart:math';
// import 'package:att_deepPurple/pages/student_list.dart';
// import 'package:att_deepPurple/models/sub.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:nearby_connections/nearby_connections.dart';  // Commented out for demo mode
// import 'package:permission_handler/permission_handler.dart';  // Commented out for demo mode
import 'student_list.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StaffHomePage createState() => _StaffHomePage();
}

class _StaffHomePage extends State<StaffHomePage> {
  String semesterChoosen = "Select an Option";
  String subjectChoosen = "Select an Option";
  String slotChoosen = "Select an Option";
  TextEditingController dateController = TextEditingController();

  String userName = "";
  // final Strategy strategy = Strategy.P2P_STAR;  // Commented out for demo mode //1 to N
  // Map<String, ConnectionInfo> endpointMap = {};  // Commented out for demo mode //connection details

  String? tempFileUri; //reference to the file currently being transferred
  Map<int, String> map = {}; //store filename mapped to corresponding payloadId
  User? user = FirebaseAuth.instance.currentUser;
  //Current User Details from firebaseauth.instance

  late final String currEmail = user?.email.toString() ?? "null";

  // List of items in our dropdown menu
  var semester = [
    "Select an Option",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6"
  ];
  var subject = [
    "Select an Option",
    "OOPS",
    "DBMS",
    "CN",
    "OS"
  ];
  var slot = [
    "Select an Option",
    "A",
    "B",
    "C",
    "D"
  ];

  // bool isAdvertising = false;  // Commented out for demo mode

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

  Widget _takeAttendance() {
    bool isToday =
        dateController.text == DateFormat("dd-MM-yyyy").format(DateTime.now());
    if (isToday) {
      // if (!isAdvertising)  // Commented out for demo mode
      {
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
              child: const Text('Take Attendance'),
              onPressed: () async {
                if (!isToday) {
                  return;
                }
                if (semesterChoosen != "Select an Option" &&
                    subjectChoosen != "Select an Option" &&
                    slotChoosen != "Select an Option" &&
                    dateController.text.isNotEmpty) {
                  try {
                    String docId = "${dateController.text}_${semesterChoosen}_${subjectChoosen}_${slotChoosen}";
                    await FirebaseFirestore.instance.collection("Attendance").doc(docId).set({
                      "semester": semesterChoosen,
                      "subject": subjectChoosen,
                      "batch": slotChoosen,
                      "date": dateController.text,
                      "present": [],
                      "attendanceStarted": true
                    });
                    // Start advertising for Bluetooth connections  // Commented out for demo mode
                    // String serviceId = "${semesterChoosen}_${subjectChoosen}_${slotChoosen}";
                    // await Nearby().startAdvertising(
                    //   currEmail,
                    //   strategy,
                    //   serviceId: serviceId,
                    //   onConnectionInitiated: onConnectionInit,
                    //   onConnectionResult: (id, status) {
                    //     if (status == Status.CONNECTED) {
                    //       showSnackbar("Student connected: $id");
                    //     } else {
                    //       showSnackbar("Connection failed: $id");
                    //     }
                    //   },
                    //   onDisconnected: (id) {
                    //     showSnackbar("Student disconnected: $id");
                    //     setState(() {
                    //       endpointMap.remove(id);
                    //     });
                    //   },
                    // );
                    showSnackbar("Attendance started (Demo Mode)");
                    // setState(() {  // Commented out for demo mode
                    //   isAdvertising = true;
                    // });
                  } catch (exception) {
                    showSnackbar("Error saving attendance: $exception");
                  }
                } else {
                  showSnackbar("Please select all fields");
                }
              }),
        );
      }
      // else  // Commented out for demo mode
      // {
      //   return SizedBox(
      //     width: double.infinity,
      //     height: 48,
      //     child: ElevatedButton(
      //         onPressed: () async {
      //         // Stop advertising
      //         Nearby().stopAdvertising();
      //         setState(() {
      //           isAdvertising = false;
      //         });
      //         showSnackbar("Attendance stopped");
      //         },
      //         child: const Text('Stop Attendance')),
      //   );
      // }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("TCE Faculty"),
        actions: [
          GestureDetector(
              child: const CircleAvatar(
                radius: 20.0,
                child: Icon(Icons.logout_sharp),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offNamed('/login');
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            //Select Semester
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.height * 0.01),
              child: Row(
                children: [
                  const Text("Choose Semester ",
                      style: TextStyle(fontSize: 13)),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      value: semesterChoosen,
                      hint: const Text("Select an Option"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: semester.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          semesterChoosen = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            //Select Subject
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.height * 0.01),
              child: Row(
                children: [
                  const Text('Choose Subject', style: TextStyle(fontSize: 13)),
                  DropdownButton(
                    value: subjectChoosen, // Initial Value
                    icon: const Icon(
                        Icons.keyboard_arrow_down), // Down Arrow Icon
                    items: subject.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        subjectChoosen = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            //Select Batch
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.height * 0.01),
              child: Row(
                children: [
                  const Text('Choose Batch', style: TextStyle(fontSize: 13)),
                  DropdownButton(
                    value: slotChoosen, // Initial Value
                    icon: const Icon(
                        Icons.keyboard_arrow_down), // Down Arrow Icon
                    items: slot.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        slotChoosen = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            //Select Date
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.height * 0.01),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Enter Date"),
                  readOnly: true,
                  onTap: (() async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat("dd-MM-yyyy").format(pickedDate);
                      setState(() {
                        dateController.text = formattedDate.toString();
                      });
                    } else {
                      const Text("Not Selected Date!!!");
                    }
                  }),
                ),
              ),
            ),
            //Take Attendance Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _takeAttendance(),
            ),
            //Student List Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  onPressed: () {
                    // print("$semesterChoosen $subjectChoosen ${dateController.text}");

                    if (semesterChoosen == "Select an Option" ||
                        subjectChoosen == "Select an Option" ||
                        dateController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Select All Fields")));
                      return;
                    }

                    Get.toNamed('/studentList', arguments: {
                      "semester": semesterChoosen,
                      "subject": subjectChoosen,
                      "date": dateController.text,
                      "slot": slotChoosen
                    });
                  },
                  child: const Text("Student List")),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  //  Called upon Connection request (on both devices)
  // Both need to accept connection to start sending/receiving
  // void onConnectionInit(String id, ConnectionInfo info) {  // Commented out for demo mode
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (builder) {
  //       return Center(
  //         child: Column(
  //         children: <Widget>[
  //           Text("id: $id"),
  //           Text("Token: ${info.authenticationToken}"),
  //           Text("Name: ${info.endpointName}"),
  //           Text("Incoming: ${info.isIncomingConnection}"),
  //           ElevatedButton(
  //             child: const Text("Accept Connection"),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               setState(() {
  //                 endpointMap[id] = info;
  //               });
  //               Nearby().acceptConnection(
  //                 id,
  //                 onPayLoadRecieved: (endid, payload) async {
  //                   if (payload.type == PayloadType.BYTES) {
  //                     String studentEmail = String.fromCharCodes(payload.bytes!);
  //                     // Update attendance in Firestore
  //                     DateTime now = DateTime.now();
  //                     String formattedDate = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
  //                     String docId = "${formattedDate}_${semesterChoosen}_${subjectChoosen}_${slotChoosen}";
  //                     await FirebaseFirestore.instance.collection("Attendance").doc(docId).update({
  //                       "present": FieldValue.arrayUnion([studentEmail])
  //                     });
  //                     var db = FirebaseFirestore.instance.collection(formattedDate).doc("$semesterChoosen Slot $slotChoosen");
  //                     var data = await db.get();
  //                     if (!data.exists) {
  //                       await db.set({
  //                         '$subjectChoosen': FieldValue.arrayUnion([studentEmail]),
  //                       });
  //                     } else {
  //                       await db.update({
  //                         '$subjectChoosen': FieldValue.arrayUnion([studentEmail]),
  //                       });
  //                     }
  //                     showSnackbar("Attendance recorded for $studentEmail");
  //                   }
  //                 },
  //                 onPayloadTransferUpdate: (endid, payloadTransferUpdate) {},
  //               );
  //             },
  //           ),
  //           ElevatedButton(
  //             child: const Text("Reject Connection"),
  //             onPressed: () async {
  //               Navigator.pop(context);
  //               try {
  //                 await Nearby().rejectConnection(id);
  //               } catch (e) {
  //                 showSnackbar(e);
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
