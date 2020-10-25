import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calendar/ui/calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Calendar',
      home: Calendar(),
    );
  }
}
