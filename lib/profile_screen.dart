import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pay/main.dart'; // Import to access appPrimaryColor
import 'package:flutter_pay/theme_provider.dart';

/// A screen that displays the user's profile information and app settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            _buildMenuList(context),
          ],
        ),
      ),
    );
  }

  /// Builds the header section of the profile screen.
  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none, // Allows the avatar to overlap the banner
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        Positioned(
          top: 100, // Position the avatar to overlap the banner
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'), // Placeholder image
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'john.doe@example.com',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the list of menu items on the profile screen.
  Widget _buildMenuList(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 20), // Top padding to account for the overlapping header
      child: Column(
        children: [
          _buildMenuCard(
            context,
            icon: Icons.brightness_6_outlined,
            title: 'Dark Mode',
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          _buildMenuCard(
            context,
            icon: Icons.person_outline,
            title: 'Personal Info',
          ),
          _buildMenuCard(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
          ),
          _buildMenuCard(
            context,
            icon: Icons.credit_card_outlined,
            title: 'Payment Methods',
          ),
          _buildMenuCard(
            context,
            icon: Icons.lock_outline,
            title: 'Security',
          ),
          const SizedBox(height: 20),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  /// A helper widget to build a single card-based menu item.
  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: appPrimaryColor, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  /// Builds the logout button at the bottom of the profile screen.
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
