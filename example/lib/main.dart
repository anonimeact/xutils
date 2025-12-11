/*
==========================================================
🧩 Example App — XUtils Pack
==========================================================
*/

import 'package:example/example_xutils.dart';
import 'package:flutter/material.dart';
import 'package:xwidgets_pack/widgets/x_snackbar.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'XUtils_Pack Example',
      navigatorKey: XSnackbar.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ExampleXwidgets(),
    ),
  );
}
