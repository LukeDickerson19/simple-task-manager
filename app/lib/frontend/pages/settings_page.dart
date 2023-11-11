import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../backend/theme_manager.dart';

class SettingsPage extends StatelessWidget {
  final double textLeftOffset = 15.0;
  final double tileHeight = 75.0;
  const SettingsPage({super.key});

  Widget themeButton(BuildContext context, ThemeManager theme) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(80),
      ),
      onPressed: () => changeThemeDialog(context, theme),
      child: SizedBox(
          height: tileHeight,
          child: Row(children: [
            SizedBox(width: textLeftOffset),
            const Text("Theme")
          ])),
    );
  }

  void changeThemeDialog(BuildContext context, ThemeManager theme) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
            title: const Text("Theme"),
            children: theme.themes.keys
                .toList()
                .map((name) => SimpleDialogOption(
                    onPressed: () => theme.setTheme(name),
                    child: SizedBox(
                        height: 35.0,
                        child: Row(
                          children: [
                            Text(name),
                            const Spacer(),
                            if (name == theme.getName()) const Icon(Icons.check)
                          ],
                        ))))
                .toList());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
        builder: (context, theme, child) => Scaffold(
            appBar: AppBar(
              title: const Text("Settings"),
            ),
            body: Column(children: <Widget>[
              themeButton(context, theme),
              const Divider(height: 1.0)
            ])));
  }
}
