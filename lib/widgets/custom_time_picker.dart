import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Time',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour picker
                _buildNumberPicker(
                  label: 'Hour',
                  value: _selectedHour,
                  minValue: 0,
                  maxValue: 23,
                  onChanged: (value) {
                    setState(() {
                      _selectedHour = value;
                    });
                  },
                ),
                
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                // Minute picker
                _buildNumberPicker(
                  label: 'Minute',
                  value: _selectedMinute,
                  minValue: 0,
                  maxValue: 59,
                  onChanged: (value) {
                    setState(() {
                      _selectedMinute = value;
                    });
                  },
                  step: 5, // 5-minute intervals
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Current selection
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Common times quick selection
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickTimeButton('08:00'),
                _buildQuickTimeButton('09:00'),
                _buildQuickTimeButton('10:00'),
                _buildQuickTimeButton('12:00'),
                _buildQuickTimeButton('14:00'),
                _buildQuickTimeButton('16:00'),
                _buildQuickTimeButton('18:00'),
                _buildQuickTimeButton('20:00'),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  child: Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    widget.onTimeSelected(TimeOfDay(
                      hour: _selectedHour,
                      minute: _selectedMinute,
                    ));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPicker({
    required String label,
    required int value,
    required int minValue,
    required int maxValue,
    required Function(int) onChanged,
    int step = 1,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 120,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListWheelScrollView(
            diameterRatio: 1.5,
            itemExtent: 40,
            physics: FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              onChanged(minValue + (index * step));
            },
            controller: FixedExtentScrollController(
              initialItem: ((value - minValue) ~/ step),
            ),
            children: List.generate(
              ((maxValue - minValue) ~/ step) + 1,
              (index) {
                final itemValue = minValue + (index * step);
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: itemValue == value ? AppColors.primaryLight.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    itemValue.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: itemValue == value ? FontWeight.bold : FontWeight.normal,
                      color: itemValue == value ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTimeButton(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    return OutlinedButton(
      child: Text(time),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedHour = hour;
          _selectedMinute = minute;
        });
      },
    );
  }
}

// Helper method to show the custom time picker
Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) async {
  TimeOfDay? selectedTime;
  
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomTimePicker(
        initialTime: initialTime,
        onTimeSelected: (time) {
          selectedTime = time;
        },
      );
    },
  );
  
  return selectedTime;
}