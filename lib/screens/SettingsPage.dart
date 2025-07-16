// packages
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// providers
import 'package:buzz/provider/ThemeProvider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text("Theme Mode", style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              ListTile(
                leading: Icon(HugeIcons.strokeRoundedSun01),
                title: Text('Light Mode'),
                onTap: () {
                  themeProvider.setThemePreference(ThemePreference.light);
                  Navigator.pop(bc);
                },
              ),
              ListTile(
                leading: Icon(HugeIcons.strokeRoundedMoon01),
                title: Text('Dark Mode'),
                onTap: () {
                  themeProvider.setThemePreference(ThemePreference.dark);
                  Navigator.pop(bc);
                },
              ),
              ListTile(
                leading: Icon(HugeIcons.strokeRoundedDarkMode),
                title: Text('System Default'),
                onTap: () {
                  themeProvider.setThemePreference(ThemePreference.system);
                  Navigator.pop(bc);
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Listen to ThemeProvider changes

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            margin: EdgeInsets.only(top: 8, left: 8, right: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 16),
                    Text("General", style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Theme", style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        themeProvider.themePreferenceString, // Display current theme preference
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      HugeIcons.strokeRoundedDarkMode,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  trailing: Icon(HugeIcons.strokeRoundedArrowRight01),
                  onTap: () {
                    _showThemePicker(context); // Show the theme picker
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
