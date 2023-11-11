import 'package:flutter/material.dart';
import 'storage_manager.dart';

class ThemeManager with ChangeNotifier {
  final themes = <String, ThemeData>{
    "light": ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.blue),
        primarySwatch: Colors.blue,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue, foregroundColor: Colors.grey[50]),
        primaryColor: Colors.grey[50],
        brightness: Brightness.light,
        textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16.0, color: Color(0xff303030))),
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.blue,
        ),
        dividerTheme:
            const DividerThemeData(color: Color.fromARGB(255, 116, 116, 116))),
    "dark": ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.blue),
        primarySwatch: Colors.blue,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue, foregroundColor: Color(0xff303030)),
        primaryColor: const Color(0xff303030),
        brightness: Brightness.dark,
        textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: 16.0, color: Colors.grey[50])),
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.blue,
        ),
        dividerTheme:
            const DividerThemeData(color: Color.fromARGB(255, 116, 116, 116))),
  };

  late String defaultName = 'light';
  late ThemeData _themeData = themes[defaultName] as ThemeData;
  ThemeData getTheme() => _themeData;
  late String _name = defaultName;
  String getName() => _name;

  ThemeManager() {
    StorageManager.readFile('theme').then((value) {
      var name = value ?? defaultName;
      setTheme(name, value == null);
    });
  }

  void setTheme(String name, [bool save = true]) async {
    _name = name;
    _themeData = themes[_name] as ThemeData;
    if (save) {
      StorageManager.saveFile('theme', _name);
    }
    notifyListeners();
  }
}
