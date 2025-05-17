import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/appointment.dart';
import '../../utils/app_colors.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter upcoming appointments
    final upcomingAppointments = mockAppointments
        .where((appointment) => appointment.status == 'upcoming')
        .toList();
    
    // Filter completed appointments
    final completedAppointments = mockAppointments
        .where((appointment) => appointment.status == 'completed')
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointments',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            // Upcoming appointments section
            Text(
              'Upcoming',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            
            upcomingAppointments.isEmpty
                ? _buildNoAppointmentsMessage('No upcoming appointments')
                : Column(
                    children: upcomingAppointments.map((appointment) => 
                      _buildAppointmentCard(appointment)
                    ).toList(),
                  ),
            
            SizedBox(height: 24),
            
            // Completed appointments section
            if (completedAppointments.isNotEmpty) ...[
              Divider(color: AppColors.divider, thickness: 1),
              SizedBox(height: 16),
              Text(
                'Completed',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: completedAppointments.map((appointment) => 
                  _buildAppointmentCard(appointment)
                ).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoAppointmentsMessage(String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    // Format date and time
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');
    
    // Determine card color based on status
    Color statusColor;
    if (appointment.status == 'upcoming') {
      statusColor = AppColors.appointmentUpcoming;
    } else if (appointment.status == 'completed') {
      statusColor = AppColors.appointmentCompleted;
    } else {
      statusColor = AppColors.appointmentCancelled;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: statusColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    appointment.businessName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                _buildStatusChip(appointment.status),
              ],
            ),
            SizedBox(height: 8),
            Text(
              appointment.serviceType,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 8),
                Text(dateFormat.format(appointment.dateTime)),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 8),
                Text(timeFormat.format(appointment.dateTime)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timelapse, size: 16),
                SizedBox(width: 8),
                Text('${appointment.duration.inMinutes} minutes'),
              ],
            ),
            if (appointment.status == 'upcoming')
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('Reschedule'),
                      onPressed: () {
                        // Reschedule functionality
                        // API call would go here
                      },
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      child: Text('Cancel'),
                      onPressed: () {
                        // Cancel functionality
                        // API call would go here
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    IconData icon;
    Color color;
    
    switch (status) {
      case 'upcoming':
        icon = Icons.event_available;
        color = AppColors.info;
        break;
      case 'completed':
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      case 'cancelled':
        icon = Icons.cancel;
        color = AppColors.error;
        break;
      default:
        icon = Icons.event_note;
        color = Colors.grey;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            status.capitalize(),
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return isNotEmpty 
        ? '${this[0].toUpperCase()}${substring(1)}'
        : '';
  }
}