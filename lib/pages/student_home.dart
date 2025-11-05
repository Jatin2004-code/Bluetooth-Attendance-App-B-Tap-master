// ignore_for_file: avoid_print, use_build_context_synchronously

// import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:nearby_connections/nearby_connections.dart';  // Commented out for demo mode
// import 'package:permission_handler/permission_handler.dart';  // Commented out for demo mode

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int flag = 0;
  User? user = FirebaseAuth.instance.currentUser;
  late final String currEmail = user?.email.toString() ?? "null";

  String semesterChoosen = "Select an Option";
  String subjectChoosen = "Select an Option";
  String slotChoosen = "Select an Option";

  // final Strategy strategy = Strategy.P2P_STAR;  // Commented out for demo mode
  // Map<String, ConnectionInfo> endpointMap = {};  // Commented out for demo mode

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

  @override
  void initState() {
    super.initState();
    // _requestPermissions();  // Commented out for demo mode
  }

  // void _requestPermissions() async {  // Commented out for demo mode
  //   await [
  //     Permission.location,
  //     Permission.bluetooth,
  //     Permission.bluetoothScan,
  //     Permission.bluetoothConnect,
  //     Permission.bluetoothAdvertise,
  //   ].request();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          flag = 0;
        });
        // Allow the app to be closed
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student HomePage"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offNamed('/login');
              },
            )
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (flag == 0)
                    Column(
                      children: [
                        //Select Semester
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.02,
                              horizontal: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                onChanged: (String? newValue) {
                                  setState(() {
                                    slotChoosen = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: endPointFoundHandler,
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(20),
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(72),
                                          ),
                                          child: const Icon(Icons.check_circle,
                                              size: 84)),
                                    ],
                                  ),
                                  const Text(
                                    "Tap to mark attendance",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  if (flag == 1)
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          print("Ripple Animation");
                          setState(() {
                            flag = 0;
                          });
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                  if (flag == 2)
                    Center(
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle, size: 84, color: Colors.green),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Attendance recorded!",
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          const SizedBox(height: 30),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  flag = 0;
                                });
                              },
                              child: const Text("Back")),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void endPointFoundHandler() async {
    if (semesterChoosen == "Select an Option" ||
        subjectChoosen == "Select an Option" ||
        slotChoosen == "Select an Option") {
      showSnackbar("Please select all fields");
      return;
    }

    setState(() {
      flag = 1;
    });

    try {
      DateTime now = DateTime.now();
      String formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      // Check if attendance is started by teacher
      var attendanceDoc = await FirebaseFirestore.instance.collection("Attendance").doc("${formattedDate}_${semesterChoosen}_${subjectChoosen}_${slotChoosen}").get();
      if (!attendanceDoc.exists || !(attendanceDoc.data()?['attendanceStarted'] ?? false)) {
        showSnackbar("Attendance not started by teacher yet");
        setState(() {
          flag = 0;
        });
        return;
      }

      // Directly update Firestore with student's email for demo mode
      await FirebaseFirestore.instance.collection("Attendance").doc("${formattedDate}_${semesterChoosen}_${subjectChoosen}_${slotChoosen}").update({
        "present": FieldValue.arrayUnion([currEmail])
      });

      // Also update the old collection structure for compatibility
      var db = FirebaseFirestore.instance.collection(formattedDate).doc("$semesterChoosen Slot $slotChoosen");
      var data = await db.get();
      if (!data.exists) {
        await db.set({
          '$subjectChoosen': FieldValue.arrayUnion([currEmail]),
        });
      } else {
        await db.update({
          '$subjectChoosen': FieldValue.arrayUnion([currEmail]),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Attendance saved in Firestore (Demo Mode)")));
      setState(() {
        flag = 2;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        flag = 0;
      });
      showSnackbar("Error: $e");
    }
  }

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
  //                 onPayLoadRecieved: (endid, payload) async {},
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

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }
}
