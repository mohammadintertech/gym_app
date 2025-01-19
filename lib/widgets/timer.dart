import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_app/utils.dart';
import 'package:intl/intl.dart';

//0055d4ff main color
class AppClock extends StatefulWidget {
  static String routeName = 'home';
  @override
  _AppClockState createState() => _AppClockState();
}

class _AppClockState extends State<AppClock> {
  String? _timeString;

  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _timeString!,
            style: TextStyle(
                fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
