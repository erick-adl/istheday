import 'package:flutter/material.dart';

import 'features/date/presentation/pages/date_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In this day...',
      theme: ThemeData(
        primaryColor: Colors.deepPurple[400],
        accentColor: Colors.deepPurple[600],
      ),
      home: DatePage(),
    );
  }
}
