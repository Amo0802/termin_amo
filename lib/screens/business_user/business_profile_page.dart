import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class BusinessProfilePage extends StatefulWidget {
  @override
  _BusinessProfilePageState createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  // Mock business data
  final Map<String, dynamic> _businessData = {
    'name': 'Style Hair Salon',
    'category': 'Hairdresser',
    'address': '123 Main St, City',
    'phone': '+1 123-456-7890',
    'description': 'Professional hair salon offering cuts, colors, and styling services for men and women.',
    'openingSince': '2015',
    'subscription': {
      'plan': 'Premium',
      'expiresOn': '2025-12-31',
      'autoRenew': true,
    },
    'services': [
      {'name': 'Haircut', 'duration': 30, 'price': 35.00},
      {'name': 'Hair Coloring', 'duration': 60, 'price': 85.00},
      {'name': 'Styling', 'duration': 45, 'price': 50.00},
      {'name': 'Beard Trim', 'duration': 15, 'price': 15.00},
    ],
    'blockedUsers': 2, // Count of blocked users
  };

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Profile header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Business Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(_isEditing ? Icons.save : Icons.edit),
                    color: AppColors.primary,
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                        if (!_isEditing) {
                          // Save profile changes
                          // API call would go here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profile saved')),
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              
              // Business Logo/Image - Full width
              Stack(
                children: [
                  // Business image (full width)
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: AssetImage('assets/placeholder_business.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.business, size: 80, color: Colors.grey[400]),
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.photo_camera, color: Colors.white),
                          onPressed: () {
                            // Image upload functionality
                          },
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24),
              
              // Basic Info Section
              _buildSectionTitle('Basic Information'),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'Business Name',
                        value: _businessData['name'],
                        isEditing: _isEditing,
                        onChanged: (value) {
                          _businessData['name'] = value;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'Category',
                        value: _businessData['category'],
                        isEditing: _isEditing,
                        onChanged: (value) {
                          _businessData['category'] = value;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'Address',
                        value: _businessData['address'],
                        isEditing: _isEditing,
                        onChanged: (value) {
                          _businessData['address'] = value;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'Phone',
                        value: _businessData['phone'],
                        isEditing: _isEditing,
                        onChanged: (value) {
                          _businessData['phone'] = value;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'Description',
                        value: _businessData['description'],
                        isEditing: _isEditing,
                        maxLines: 3,
                        onChanged: (value) {
                          _businessData['description'] = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Services Section
              _buildSectionTitle('Services'),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...(_businessData['services'] as List).map((service) => 
                        _buildServiceItem(service, _isEditing),
                      ).toList(),
                      if (_isEditing)
                        TextButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Add Service'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                          onPressed: () {
                            // Add new service
                            setState(() {
                              (_businessData['services'] as List).add({
                                'name': 'New Service',
                                'duration': 30,
                                'price': 0.00,
                              });
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Subscription Info Section
              _buildSectionTitle('Subscription'),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.card_membership, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            '${_businessData['subscription']['plan']} Plan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Expires on: ${_businessData['subscription']['expiresOn']}'),
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            // Cancel subscription
                            // Show confirmation dialog
                            _showCancelSubscriptionDialog();
                          },
                          child: Text('Cancel Subscription'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Blocked Users Section
              _buildSectionTitle('User Management'),
              Card(
                child: ListTile(
                  leading: Icon(Icons.block, color: AppColors.error),
                  title: Text('Blocked Users'),
                  subtitle: Text('${_businessData['blockedUsers']} users blocked'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to blocked users screen
                    // This would be implemented in the real app
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Blocked users feature coming soon'),
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required bool isEditing,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return isEditing
        ? TextField(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            maxLines: maxLines,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ],
          );
  }

  Widget _buildServiceItem(Map<String, dynamic> service, bool isEditing) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: isEditing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: service['name']),
                  onChanged: (value) {
                    service['name'] = value;
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Duration (min)',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(text: service['duration'].toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          service['duration'] = int.tryParse(value) ?? 0;
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(text: service['price'].toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          service['price'] = double.tryParse(value) ?? 0.0;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: AppColors.error),
                    onPressed: () {
                      setState(() {
                        (_businessData['services'] as List).remove(service);
                      });
                    },
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('${service['duration']} minutes'),
                    ],
                  ),
                ),
                Text(
                  '\$${service['price'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }

  void _showCancelSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Subscription'),
          content: Text(
            'Are you sure you want to cancel your subscription? You will no longer be able to use business features after your current subscription period ends.',
          ),
          actions: [
            TextButton(
              child: Text('No, Keep Subscription'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Cancel subscription
                // API call would go here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Subscription will be canceled at the end of the current period'),
                  ),
                );
              },
              child: Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }
}