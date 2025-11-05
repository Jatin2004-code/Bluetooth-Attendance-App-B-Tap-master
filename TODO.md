# TODO List for Fixing Imports and Web Support

## 1. Fix Package Imports to Relative Paths
- [ ] Update lib/main.dart: Change 'package:att_blue/pages/...' to 'pages/...'
- [ ] Update lib/pages/login_page.dart: Change 'package:att_blue/pages/staff_home.dart' to 'staff_home.dart'
- [ ] Update lib/components/rippleEffect/ripple_animation.dart: Remove package imports for circle_painter.dart and curve_wave.dart, keep relative imports

## 2. Add Web Platform Checks for Bluetooth Code
- [ ] Update lib/pages/staff_home.dart: Add kIsWeb checks around nearby_connections usage
- [ ] Update lib/pages/student_home.dart: Add kIsWeb checks around nearby_connections usage
- [ ] Ensure import 'package:flutter/foundation.dart' is added where needed

## 3. Testing and Verification
- [ ] Run flutter pub get to update dependencies
- [ ] Run flutter run --web to verify the app compiles and runs on web
- [ ] Test Firestore connection in demo mode
