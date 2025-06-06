import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedUnit = 'Celsius';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text("Dark Mode", style: TextStyle(color: Colors.white)),
            subtitle: Text("Enable dark theme",
                style: TextStyle(color: Colors.white70)),
            value: _isDarkMode,
            activeColor: Colors.tealAccent,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              // TODO: Apply dark theme using provider or theme logic
            },
          ),
          Divider(color: Colors.white24),
          ListTile(
            title:
                Text("Temperature Unit", style: TextStyle(color: Colors.white)),
            trailing: DropdownButton<String>(
              value: _selectedUnit,
              dropdownColor: Colors.blueGrey[800],
              iconEnabledColor: Colors.white,
              style: TextStyle(color: Colors.white),
              underline: Container(),
              items: ['Celsius', 'Fahrenheit'].map((unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedUnit = value;
                  });
                  // TODO: Pass selected unit to weather API
                }
              },
            ),
          ),
          Divider(color: Colors.white24),
          SwitchListTile(
            title: Text("Enable Notifications",
                style: TextStyle(color: Colors.white)),
            subtitle: Text("Get daily weather alerts",
                style: TextStyle(color: Colors.white70)),
            value: _notificationsEnabled,
            activeColor: Colors.tealAccent,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: Handle enabling/disabling notifications
            },
          ),
          Divider(color: Colors.white24),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white),
            title: Text("App Info", style: TextStyle(color: Colors.white)),
            subtitle: Text(
              "Version 1.0.0\nDeveloped by Your Faizi",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
