import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xutils_pack/extensions/datetime_extension.dart';
import 'package:xutils_pack/extensions/string_extension.dart';
import 'package:xwidgets_pack/xwidgets.dart';

class ExampleXwidgets extends StatefulWidget {
  const ExampleXwidgets({super.key});

  @override
  State<ExampleXwidgets> createState() => _ExampleXwidgetsState();
}

class _ExampleXwidgetsState extends State<ExampleXwidgets> {
  final dateOrigin = '25/07/2000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XAppBar(
        title: 'XWidgets',
        backButton: Icon(Icons.logout),
        onTapBack: () => exit(0),
      ),
      body: Column(
        children: [
          XCard(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                XText(
                  'Date origin: $dateOrigin',
                  icon: Icon(Icons.date_range),
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                ),
                XText(
                  'Date formated: ${dateOrigin.toDateTime().formatDate(targetFormat: 'dd MMMM yyyy')}',
                  icon: Icon(Icons.date_range_outlined),
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: XText(
                  'Show more example in Test folder',
                  isUseUnderline: true,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
