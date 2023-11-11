import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend/theme_manager.dart';
import 'backend/task_manager.dart';
import 'frontend/pages/home_page.dart';
import 'frontend/pages/settings_page.dart';

final routes = {
  "/": (context) => const HomePage(),
  "/settings": (context) => const SettingsPage(),
};

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
        builder: (context, theme, child) => MaterialApp(
              title: "Task Manager",
              theme: theme.getTheme(),
              debugShowCheckedModeBanner: false,
              routes: routes,
              initialRoute: "/",
            ));
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager()),
        ChangeNotifierProvider<TaskManager>(create: (_) => TaskManager()),
      ],
      child: const App(),
    ),
  );
}
