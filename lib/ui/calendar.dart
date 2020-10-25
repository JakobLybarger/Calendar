import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<dynamic>> _events; // Map of each date and the events that day.
  List<dynamic> _addedEvents; // List of events to be added.

  // Controller required to update events, holidays, etc.
  CalendarController _calendarController;
  TextEditingController _eventController;


  // Overridden to make initialize the controllers.
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _addedEvents = [];
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
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              _buildCalendar(),
              Expanded(child: _eventList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
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
      builders: CalendarBuilders(
        
      ),
    );
  }

  // Show all of the events of the selected date.
  Widget _eventList() {
    return ListView(
      children: _addedEvents.map((event) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height/12,
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
              colors: [Colors.deepPurpleAccent, Colors.deepPurple,],
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          
          child: Text(
            event,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height / 40
            ),
            textAlign: TextAlign.left,
            
          ),
        )
      )).toList(),
    );
  }

  // Dialog to allow user to enter event for date.
   _addEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _eventController,
        ),
        actions: [
          FlatButton(
            child: Text("Add"),
            onPressed: () {
              // If there is not text return and do not add anything to events.
              if(_eventController.text.isEmpty) return;

              // If the day selected is not in _addedEvents, add it to _addedEvents and add the event.
              if(_events[_calendarController.selectedDay] != null) {
                _events[_calendarController.selectedDay].add(_eventController.text);
              }
              else { // Add the event to _addedEvents.
                _events[_calendarController.selectedDay] = [_eventController.text];
              }
              // Clear controller and close alert dialog.
              _eventController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );

    // Set _addedEvents equal to _events at selected day.
    setState(() {
      _addedEvents = _events[_calendarController.selectedDay];
    });
  }
}
