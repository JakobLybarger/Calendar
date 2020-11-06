import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> _colors = [
    "Deep Purple Accent",
    "Deep Orange Accent",
    "Red",
    "Blue",
    "Green",
  ];
  String _primaryColor;
  String _accentColor;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // Initialize shared preferences.
  void initialize() async {
    prefs = await SharedPreferences.getInstance();
    _primaryColor =
        prefs.getString("primaryColorString") ?? "Deep Purple Accent";
    _accentColor = prefs.getString("accentColorString") ?? "Deep Orange Accent";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Color(
            prefs.getInt("primaryColor") ?? Colors.deepPurpleAccent.value),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text("Primary Color: "),
                DropdownButton<String>(
                  value: _primaryColor,
                  onChanged: (String value) {
                    int _color;
                    if (value == "Deep Purple Accent")
                      _color = 0xFF7C4DFF;
                    else if (value == "Deep Orange Accent")
                      _color = 0xFFFF6E40;
                    else if (value == "Red")
                      _color = 0xFFEF5350;
                    else if (value == "Blue")
                      _color = 0xFF2196F3;
                    else if (value == "Green") _color = 0xFF4CAF50;

                    setState(() {
                      _primaryColor = value;
                      prefs.setInt("primaryColor", _color);
                      prefs.setString("primaryColorString", value);
                    });
                  },
                  items: _colors.map(
                    (String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text("Accent Color: "),
                DropdownButton<String>(
                  value: _accentColor,
                  onChanged: (String value) {
                    int _color;
                    if (value == "Deep Purple Accent")
                      _color = 0xFF7C4DFF;
                    else if (value == "Deep Orange Accent")
                      _color = 0xFFFF6E40;
                    else if (value == "Red")
                      _color = 0xFFEF5350;
                    else if (value == "Blue")
                      _color = 0xFF2196F3;
                    else if (value == "Green") _color = 0xFF4CAF50;

                    setState(() {
                      _accentColor = value;
                      prefs.setInt("accentColor", _color);
                      prefs.setString("accentColorString", value);
                    });
                  },
                  items: _colors.map(
                    (String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
