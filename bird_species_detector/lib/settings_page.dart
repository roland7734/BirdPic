import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            subtitle: const Text('Privacy, security'),
            onTap: () {
              // Handle tap on account settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Message, group & call tones'),
            onTap: () {
              // Handle tap on notifications settings
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: false,
            onChanged: (bool value) {
              // Handle switch for dark mode
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('Change the app language'),
            onTap: () {
              // Handle tap on language settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            subtitle: const Text('Manage your privacy settings'),
            onTap: () {
              // Handle tap on privacy settings
            },
          ),
        ],
      ),
    );
  }
}
