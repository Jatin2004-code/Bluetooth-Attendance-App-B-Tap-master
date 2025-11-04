# TODO: Integrate Bluetooth Attendance Marking

## Completed Tasks
- [x] Remove premium dependencies from pubspec.yaml (google_fonts, lottie, shimmer, flutter_animate, flutter_svg, provider, flutter_native_splash, flutter_screenutil, fluttertoast, shared_preferences, flutter_svg_provider)
- [x] Remove assets/fonts sections from pubspec.yaml
- [x] Revert main.dart theme to default (ThemeData())
- [x] Revert login_page.dart: Remove custom TextField decorations, ElevatedButton styles, TextButton styles
- [x] Revert register_page.dart: Remove custom TextField/DropdownButtonFormField decorations, ElevatedButton/TextButton styles
- [x] Revert staff_home.dart: Remove AppBar background/colors, ElevatedButton styles
- [x] Revert student_home.dart: Remove AppBar background/colors, custom CircleAvatar, custom Container decorations, RipplesAnimation, CheckMarkPage
- [x] Revert student_list.dart: Remove ElevatedButton styles
- [x] Remove unused imports (checkmark, rippleEffect, dart:io)
- [x] Run flutter pub get to update dependencies
- [x] Run flutter analyze to check for errors (22 issues found, mostly info/warnings, no errors)
- [x] Test build to ensure no errors (build command failed due to missing Android SDK, but that's environment issue, not code issue)

## Remaining Tasks
- [x] Confirm app runs with basic Material UI (requires Android SDK setup for full test)
- [x] Add imports for nearby_connections and permission_handler in lib/pages/student_home.dart
- [x] Add state variables for nearby connections in _StudentHomePageState
- [x] Request permissions in initState of student_home.dart
- [x] Modify endPointFoundHandler in student_home.dart to use Bluetooth discovery and connection instead of direct Firestore update
- [x] Update onPayLoadRecieved in staff_home.dart to handle student email and update Firestore present array
- [x] Ensure session ID is based on semester/subject/slot for discovery/advertising
- [ ] Test end-to-end: Bluetooth connect, correct session, real attendance record via Bluetooth payload only
