import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Help"),
      ),
      body: Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  "Add an Event",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 15,
                  ),
                ),
                subtitle: Text(
                  "Tap on the day you want and click the Add button in the bottom right corner of the screen then enter event title.",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  "Delete an Event",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 15,
                  ),
                ),
                subtitle: Text(
                  "Go to the date of the event and long press on the event and it will disappear",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
