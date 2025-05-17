import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ProfilePage extends StatelessWidget {
  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'phone': '+1 123-456-7890',
    'profileImage': null, // Would be an image URL in a real app
    'notificationsEnabled': true,
  };

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header with photo, edit button, name and phone
              Center(
                child: Stack(
                  children: [
                    // Profile image
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 80, color: Colors.grey[600]),
                    ),
                    
                    // Edit photo button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // Name
              Center(
                child: Text(
                  _userData['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              
              // Phone number
              Center(
                child: Text(
                  _userData['phone'],
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
              ),
              SizedBox(height: 32),
              
              // Profile options
              Card(
                child: Column(
                  children: [
                    // Notifications toggle
                    SwitchListTile(
                      title: Text('Notifications'),
                      subtitle: Text('Receive booking confirmations and reminders'),
                      value: _userData['notificationsEnabled'],
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        // Toggle notification settings
                        // API call would go here
                      },
                    ),
                    
                    _buildDivider(),
                    
                    // Change name
                    _buildProfileOption(
                      icon: Icons.person_outline,
                      title: 'Change Name',
                      onTap: () {
                        // Navigate to change name screen
                      },
                    ),
                    
                    _buildDivider(),
                    
                    // Change number
                    _buildProfileOption(
                      icon: Icons.phone,
                      title: 'Change Number',
                      onTap: () {
                        // Navigate to change number screen
                      },
                    ),
                    
                    _buildDivider(),
                    
                    // Change password
                    _buildProfileOption(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {
                        // Navigate to change password screen
                      },
                    ),
                    
                    _buildDivider(),
                    
                    // About
                    _buildProfileOption(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        // Navigate to about screen or show about dialog
                        _showAboutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              
              // Logout button
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    // Logout functionality
                    // API call would go here
                  },
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.divider,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Scheduler'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scheduler App v1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'A scheduling app for businesses and customers to manage appointments efficiently.',
              ),
              SizedBox(height: 16),
              Text(
                '© 2025 Scheduler Inc.\nAll Rights Reserved',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Privacy Policy'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to privacy policy
              },
            ),
          ],
        );
      },
    );
  }
}