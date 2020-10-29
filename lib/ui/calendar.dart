import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<dynamic>>
      _events; // Map of each date and the events that day.
  List<dynamic> _addedEvents; // List of events to be added.

  // Controllers and shared preferences declaration
  CalendarController _calendarController;
  TextEditingController _eventController;
  SharedPreferences prefs;

  // Overridden to make initialize the controllers.
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _addedEvents = [];
    initialize();
  }

  initialize() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decode(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  // Overridden to ensure dispose of controllers.
  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
    _eventController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            _buildCalendar(),
            Expanded(child: _eventList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.deepOrangeAccent,
        ),
        backgroundColor: Colors.white,
        onPressed: _addEventDialog,
      ),
    );
  }

  // The calendar widget and its desired features/design.
  Widget _buildCalendar() {
    return TableCalendar(
      events: _events,
      calendarController: _calendarController,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
      ),
      onDaySelected: (day, events, holidays) {
        setState(() {
          _addedEvents = events;
        });
      },
      builders:
          CalendarBuilders(markersBuilder: (context, date, events, holidays) {
        final children = <Widget>[];

        if (events.isNotEmpty) {
          children.add(
            Positioned(
              right: 3,
              bottom: 0,
              child: _marker(date, events),
            ),
          );
        }

        if (holidays.isNotEmpty) {
          children.add(
            Positioned(
              left: 3,
              bottom: 0,
              child: _marker(date, holidays),
            ),
          );
        }
        return children;
      }, todayDayBuilder: (context, date, events) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }, selectedDayBuilder: (context, date, events) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }

  // Design for the event and holiday marker.
  Widget _marker(DateTime date, List events) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.deepOrangeAccent),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  // Show all of the events of the selected date.
  Widget _eventList() {
    return ListView(
      children: _addedEvents
          .map((event) => SafeArea(
                  child: Container(
                height: MediaQuery.of(context).size.height / 12,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 100,
                  left: MediaQuery.of(context).size.width / 60,
                  right: MediaQuery.of(context).size.width / 60,
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 45,
                  left: 5,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  event,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height / 40),
                  textAlign: TextAlign.left,
                ),
              )))
          .toList(),
    );
  }

  // Dialog to allow user to enter event for date.
  _addEventDialog() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _eventController,
        ),
        actions: [
          FlatButton(
            child: Text("Close"),
            onPressed: () {
              _eventController.clear();
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("Add"),
            onPressed: () {
              // If there is not text return and do not add anything to events.
              if (_eventController.text.isEmpty) return;

              // If the day selected is not in _addedEvents, add it to _addedEvents and add the event.
              if (_events[_calendarController.selectedDay] != null) {
                _events[_calendarController.selectedDay]
                    .add(_eventController.text);
              } else {
                // Add the event to _addedEvents.
                _events[_calendarController.selectedDay] = [
                  _eventController.text
                ];
              }
              // Save list to shared preferences
              prefs.setString("events", json.encode(encode(_events)));
              // Clear controller and close alert dialog.
              _eventController.clear();
              Navigator.pop(context);
              // Set _addedEvents equal to _events at selected day.
              setState(() {
                _addedEvents = _events[_calendarController.selectedDay];
              });
            },
          ),
        ],
      ),
    );
  }

  // Transform map of <DateTime, dynamic> to <String, dynamic>
  Map<String, dynamic> encode(Map<DateTime, dynamic> map) {
    Map<String, dynamic> result = {};
    map.forEach((key, value) {
      result[key.toString()] = map[key];
    });

    return result;
  }

  // Transform map of <String, dynamic> to <DateTime, dynamic>
  Map<DateTime, dynamic> decode(Map<String, dynamic> map) {
    Map<DateTime, dynamic> result = {};
    map.forEach((key, value) {
      result[DateTime.parse(key)] = map[key];
    });
    return result;
  }
}
