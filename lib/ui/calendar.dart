import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // Controller required to update events, holidays, etc.
  CalendarController _calendarController;

  // Overridden to make initialize the calendar controller upon initialization
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  // Overridden to ensure dispose of calendar controller
  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              _buildCalendar(),
              _eventList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
      ),
    );
  }

  Widget _eventList() {
    return ListView(
      children: [
        ListTile(
          title: Text('monday'),
        ),
        ListTile(
          title: Text('Tuesday'),
        ),
        ListTile(
          title: Text('Wednesday'),
        ),
        ListTile(
          title: Text('Thursday'),
        ),
        ListTile(
          title: Text('Friday'),
        ),
        ListTile(
          title: Text('Saturday'),
        ),
        ListTile(
          title: Text('Sunday'),
        ),
      ],
    );
  }
}
