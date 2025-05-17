import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_time_picker.dart';

class ScheduleSettingsPage extends StatefulWidget {
  @override
  _ScheduleSettingsPageState createState() => _ScheduleSettingsPageState();
}

class _ScheduleSettingsPageState extends State<ScheduleSettingsPage> {
  // Mock business settings
  final Map<String, dynamic> _settings = {
    'businessHours': {
      'monday': {'start': '09:00', 'end': '17:00', 'enabled': true},
      'tuesday': {'start': '09:00', 'end': '17:00', 'enabled': true},
      'wednesday': {'start': '09:00', 'end': '17:00', 'enabled': true},
      'thursday': {'start': '09:00', 'end': '17:00', 'enabled': true},
      'friday': {'start': '09:00', 'end': '17:00', 'enabled': true},
      'saturday': {'start': '10:00', 'end': '15:00', 'enabled': true},
      'sunday': {'start': '00:00', 'end': '00:00', 'enabled': false},
    },
    'appointmentDuration': 30, // minutes
    'cancellationPeriod': 3, // hours
    'breakTime': {'start': '12:00', 'end': '13:00', 'enabled': true},
    'blockSpam': true,
    'allowRescheduling': true,
    'nonWorkingDays': [
      {'date': '2025-05-19', 'description': 'Holiday'},
      {'date': '2025-06-15', 'description': 'Vacation'},
      {'date': '2025-06-16', 'description': 'Vacation'},
      {'date': '2025-06-17', 'description': 'Vacation'},
    ],
  };

  final List<String> _daysOfWeek = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  final List<int> _availableDurations = [15, 30, 45, 60, 90, 120];
  final List<int> _cancellationPeriods = [1, 2, 3, 6, 12, 24, 48];
  
  DateTime? _selectedNonWorkingDate;
  final TextEditingController _nonWorkingDescriptionController = TextEditingController();

  @override
  void dispose() {
    _nonWorkingDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            
            // Business Hours Section
            _buildSectionTitle('Business Hours'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: _daysOfWeek.map((day) => _buildDayTimeSelector(day)).toList(),
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Break Time Section
            _buildSectionTitle('Daily Break Time'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text('Enable Break Time'),
                      value: _settings['breakTime']['enabled'],
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _settings['breakTime']['enabled'] = value;
                        });
                      },
                    ),
                    if (_settings['breakTime']['enabled']) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimeField(
                              label: 'Start',
                              value: _settings['breakTime']['start'],
                              onChanged: (value) {
                                setState(() {
                                  _settings['breakTime']['start'] = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildTimeField(
                              label: 'End',
                              value: _settings['breakTime']['end'],
                              onChanged: (value) {
                                setState(() {
                                  _settings['breakTime']['end'] = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Non-Working Days Section
            _buildSectionTitle('Non-Working Days'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set days when you won\'t be working (holidays, vacations, etc.)',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 16),
                    
                    // List of non-working days
                    if (_settings['nonWorkingDays'].isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'No non-working days set',
                            style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _settings['nonWorkingDays'].length,
                        itemBuilder: (context, index) {
                          final day = _settings['nonWorkingDays'][index];
                          return ListTile(
                            title: Text(day['description']),
                            subtitle: Text(day['date']),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: AppColors.error),
                              onPressed: () {
                                setState(() {
                                  _settings['nonWorkingDays'].removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 16),
                    
                    // Add non-working day
                    Text(
                      'Add Non-Working Day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Date picker
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedNonWorkingDate = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _selectedNonWorkingDate != null
                              ? '${_selectedNonWorkingDate!.year}-${_selectedNonWorkingDate!.month.toString().padLeft(2, '0')}-${_selectedNonWorkingDate!.day.toString().padLeft(2, '0')}'
                              : 'Select a date',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Description field
                    TextField(
                      controller: _nonWorkingDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description (e.g., Holiday, Vacation)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Add button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Add'),
                        onPressed: _selectedNonWorkingDate == null || _nonWorkingDescriptionController.text.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  _settings['nonWorkingDays'].add({
                                    'date': '${_selectedNonWorkingDate!.year}-${_selectedNonWorkingDate!.month.toString().padLeft(2, '0')}-${_selectedNonWorkingDate!.day.toString().padLeft(2, '0')}',
                                    'description': _nonWorkingDescriptionController.text,
                                  });
                                  _selectedNonWorkingDate = null;
                                  _nonWorkingDescriptionController.clear();
                                });
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Appointment Settings Section
            _buildSectionTitle('Appointment Settings'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Appointment Duration
                    ListTile(
                      title: Text('Default Appointment Duration'),
                      subtitle: Text('${_settings['appointmentDuration']} minutes'),
                      trailing: PopupMenuButton<int>(
                        icon: Icon(Icons.arrow_drop_down),
                        onSelected: (value) {
                          setState(() {
                            _settings['appointmentDuration'] = value;
                          });
                        },
                        itemBuilder: (context) {
                          return _availableDurations.map((duration) {
                            return PopupMenuItem<int>(
                              value: duration,
                              child: Text('$duration minutes'),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    Divider(),
                    
                    // Cancellation Period
                    ListTile(
                      title: Text('Cancellation Period'),
                      subtitle: Text('${_settings['cancellationPeriod']} hours before appointment'),
                      trailing: PopupMenuButton<int>(
                        icon: Icon(Icons.arrow_drop_down),
                        onSelected: (value) {
                          setState(() {
                            _settings['cancellationPeriod'] = value;
                          });
                        },
                        itemBuilder: (context) {
                          return _cancellationPeriods.map((period) {
                            return PopupMenuItem<int>(
                              value: period,
                              child: Text('$period hours'),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Other Settings Section
            _buildSectionTitle('Other Settings'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text('Block Users Who Cancel Frequently'),
                      subtitle: Text('Automatically block users who cancel more than 3 times in a month'),
                      value: _settings['blockSpam'],
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _settings['blockSpam'] = value;
                        });
                      },
                    ),
                    Divider(),
                    SwitchListTile(
                      title: Text('Allow Rescheduling'),
                      subtitle: Text('Let clients reschedule their appointments'),
                      value: _settings['allowRescheduling'],
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _settings['allowRescheduling'] = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            
            // Save button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save settings
                  // API call would go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Settings saved')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  backgroundColor: AppColors.primary,
                ),
                child: Text('Save Settings'),
              ),
            ),
            SizedBox(height: 32),
          ],
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

  Widget _buildDayTimeSelector(String day) {
    final daySettings = _settings['businessHours'][day];
    final capitalizedDay = day[0].toUpperCase() + day.substring(1);
    
    return Column(
      children: [
        SwitchListTile(
          title: Text(capitalizedDay),
          value: daySettings['enabled'],
          activeColor: AppColors.primary,
          onChanged: (value) {
            setState(() {
              _settings['businessHours'][day]['enabled'] = value;
            });
          },
        ),
        if (daySettings['enabled'])
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildTimeField(
                    label: 'Start',
                    value: daySettings['start'],
                    onChanged: (value) {
                      setState(() {
                        _settings['businessHours'][day]['start'] = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTimeField(
                    label: 'End',
                    value: daySettings['end'],
                    onChanged: (value) {
                      setState(() {
                        _settings['businessHours'][day]['end'] = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        if (_daysOfWeek.indexOf(day) < _daysOfWeek.length - 1)
          Divider(),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
      readOnly: true,
      onTap: () async {
        // Parse the time string to TimeOfDay
        final parts = value.split(':');
        final initialTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
        
        // Show custom time picker
        final selectedTime = await showCustomTimePicker(
          context: context,
          initialTime: initialTime,
        );
        
        if (selectedTime != null) {
          final formattedTime = _formatTimeOfDay(selectedTime);
          onChanged(formattedTime);
        }
      },
    );
  }

  // ignore: unused_element
  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}