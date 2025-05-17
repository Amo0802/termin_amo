import 'package:flutter/material.dart';
import 'package:termin_amo/utils/app_colors.dart';
import 'profile/change_name_page.dart';
import 'profile/change_number_page.dart';
import 'profile/change_password_page.dart';
import 'profile/about_page.dart';

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
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            // Would handle profile photo upload
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Profile photo functionality coming soon')),
                            );
                          },
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangeNamePage()),
                        );
                      },
                    ),
                    
                    _buildDivider(),
                    
                    // Change number
                    _buildProfileOption(
                      icon: Icons.phone,
                      title: 'Change Number',
                      onTap: () {
                        // Navigate to change number screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangeNumberPage()),
                        );
                      },
                    ),
                    
                    _buildDivider(),
                    
                    // Change password
                    _buildProfileOption(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {
                        // Navigate to change password screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                        );
                      },
                    ),
                    
                    _buildDivider(),
                    
                    // About
                    _buildProfileOption(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        // Navigate to about screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
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
                    // In a real app, this would call an API to logout
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Logout'),
                              onPressed: () {
                                // In a real app, navigate to login screen
                                Navigator.of(context).pop();
                                
                                // This is just for demo purposes
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Logged out successfully')),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
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
}