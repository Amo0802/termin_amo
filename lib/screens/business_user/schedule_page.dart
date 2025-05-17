import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/schedule_slot.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_time_picker.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedMonth = DateTime.now();
  final dateFormat = DateFormat('EEE, MMM d');
  // Using 24-hour format
  final timeFormat = DateFormat('HH:mm');
  
  // View mode: 'day' or 'week'
  String _viewMode = 'day';

  @override
  Widget build(BuildContext context) {
    // Get slots for the selected date or week
    List<ScheduleSlot> filteredSlots = [];
    
    if (_viewMode == 'day') {
      // Filter slots for the selected date
      filteredSlots = mockScheduleSlots.where((slot) {
        return slot.dateTime.year == _selectedDate.year &&
            slot.dateTime.month == _selectedDate.month &&
            slot.dateTime.day == _selectedDate.day;
      }).toList();
    } else {
      // Filter slots for the selected week
      // Find the start of the week (Monday)
      DateTime startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      
      filteredSlots = mockScheduleSlots.where((slot) {
        return slot.dateTime.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            slot.dateTime.isBefore(endOfWeek.add(Duration(days: 1)));
      }).toList();
    }

    // Sort slots by time
    filteredSlots.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      body: Column(
        children: [
          // View selector and header
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                        // Today button
                        OutlinedButton.icon(
                          icon: Icon(Icons.today, size: 16),
                          label: Text('Today'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDate = DateTime.now();
                              _selectedMonth = DateTime.now();
                            });
                          },
                        ),
                        
                        // View mode toggle
                        SegmentedButton<String>(
                          segments: [
                            ButtonSegment<String>(
                              value: 'day',
                              label: Text('Day'),
                              icon: Icon(Icons.calendar_today, size: 16),
                            ),
                            ButtonSegment<String>(
                              value: 'week',
                              label: Text('Week'),
                              icon: Icon(Icons.calendar_view_week, size: 16),
                            ),
                          ],
                          selected: {_viewMode},
                          onSelectionChanged: (Set<String> selection) {
                            setState(() {
                              _viewMode = selection.first;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return AppColors.primary;
                                }
                                return Colors.transparent;
                              },
                            ),
                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.white;
                                }
                                return AppColors.textPrimary;
                              },
                            ),
                          ),
                        ),
                  ],
                ),
                SizedBox(height: 16),
                if (_viewMode == 'day')
                  _buildDateSelector()
                else
                  _buildMonthWeekSelector(),
              ],
            ),
          ),
          
          // Schedule view (day or week)
          Expanded(
            child: _viewMode == 'day'
                ? _buildDayView(filteredSlots)
                : _buildWeekView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          // Show dialog to add new time slot
          _showAddSlotDialog();
        },
        tooltip: 'Add Time Slot',
      ),
    );
  }

  Widget _buildMonthWeekSelector() {
    // Calculate the weeks in the selected month
    List<DateTime> weeksInMonth = [];
    
    // First day of the month
    DateTime firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    
    // Start with first Monday before or on the first day of the month
    DateTime currentWeekStart = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    
    // Last day of the month
    DateTime lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    
    // Add weeks until we go past the end of the month
    while (currentWeekStart.isBefore(lastDay) || currentWeekStart.month == lastDay.month) {
      weeksInMonth.add(currentWeekStart);
      currentWeekStart = currentWeekStart.add(Duration(days: 7));
      
      // Safety check to prevent infinite loop
      if (weeksInMonth.length > 6) break;
    }
    
    // Find if the selected date is in this month
    DateTime selectedWeekStart = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    bool isSelectedWeekInCurrentMonth = weeksInMonth.any((weekStart) => 
      weekStart.year == selectedWeekStart.year && 
      weekStart.month == selectedWeekStart.month && 
      weekStart.day == selectedWeekStart.day
    );
    
    // If not, adjust the selected date to the first week of the month
    if (!isSelectedWeekInCurrentMonth) {
      _selectedDate = weeksInMonth.first;
    }

    return Column(
      children: [
        // Month selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 16),
              onPressed: () {
                setState(() {
                  _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
                });
              },
            ),
            Text(
              DateFormat('MMMM yyyy').format(_selectedMonth),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {
                setState(() {
                  _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
                });
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        
        // Week selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: weeksInMonth.map((weekStart) {
              final weekEnd = weekStart.add(Duration(days: 6));
              
              // Check if this is the selected week
              final isSelected = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)).day == weekStart.day &&
                                _selectedDate.month == weekStart.month;
              
              // Check if this is the current week
              final now = DateTime.now();
              final isCurrentWeek = now.isAfter(weekStart.subtract(Duration(days: 1))) && 
                                  now.isBefore(weekEnd.add(Duration(days: 1)));
              
              // Format week label
              String weekLabel;
              if (weekStart.month != weekEnd.month) {
                // Week spans two months
                weekLabel = '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd)}';
              } else {
                // Week in same month
                weekLabel = '${DateFormat('d').format(weekStart)} - ${DateFormat('d').format(weekEnd)}';
              }
              
              return Container(
                margin: EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDate = weekStart;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primary 
                          : (isCurrentWeek ? AppColors.primaryLight.withOpacity(0.2) : Colors.white),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.primary 
                            : (isCurrentWeek ? AppColors.primaryLight : AppColors.divider),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Week ${weeksInMonth.indexOf(weekStart) + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          weekLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white.withOpacity(0.9) : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // Show two weeks
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          // For week view, highlight the whole week
          bool isInSelectedWeek = false;
          if (_viewMode == 'week') {
            // Find the start of the selected week (Monday)
            DateTime startOfSelectedWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
            DateTime startOfCurrentWeek = date.subtract(Duration(days: date.weekday - 1));
            isInSelectedWeek = startOfSelectedWeek.year == startOfCurrentWeek.year &&
                startOfSelectedWeek.month == startOfCurrentWeek.month &&
                startOfSelectedWeek.day == startOfCurrentWeek.day;
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 60,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primary 
                    : (isInSelectedWeek ? AppColors.primaryLight.withOpacity(0.3) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isInSelectedWeek ? AppColors.primaryLight : Colors.grey[300]!),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : (isInSelectedWeek ? AppColors.primary : Colors.grey[600]),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : (isInSelectedWeek ? AppColors.primary : Colors.black),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _hasAppointments(date)
                          ? (isSelected ? Colors.white : AppColors.primary)
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _hasAppointments(DateTime date) {
    return mockScheduleSlots.any((slot) =>
        slot.dateTime.year == date.year &&
        slot.dateTime.month == date.month &&
        slot.dateTime.day == date.day &&
        slot.status == 'booked');
  }

  Widget _buildDayView(List<ScheduleSlot> slots) {
    if (slots.isEmpty) {
      return Center(
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
              'No appointments for this day',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Time Slot'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _showAddSlotDialog();
              },
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return _buildSlotCard(slot);
      },
    );
  }

  Widget _buildWeekView() {
    // Find the start of the week (Monday)
    DateTime startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    
    // Generate a list of 7 days starting from Monday
    List<DateTime> daysOfWeek = List.generate(
      7, 
      (index) => startOfWeek.add(Duration(days: index))
    );
    
    // Business hours
    final int startHour = 6; // 6 AM
    final int endHour = 24; // 12 AM (midnight)
    
    // Get current date and time for current time indicator
    final now = DateTime.now();
    final isCurrentWeek = now.isAfter(startOfWeek.subtract(Duration(days: 1))) && 
                          now.isBefore(startOfWeek.add(Duration(days: 7)));
    
    // Calculate the current hour fraction (for time indicator)
    // ignore: unused_local_variable
    final double currentHourFraction = isCurrentWeek && daysOfWeek.any((d) => 
        d.day == now.day && d.month == now.month && d.year == now.year)
        ? now.hour + (now.minute / 60.0)
        : -1;
      
    // Fixed height per hour
    final double hourHeight = 72.0;
    
    return Column(
      children: [
        // Week days header
        Container(
          color: AppColors.primaryLight.withOpacity(0.1),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Empty top-left cell
              Container(
                width: 50,
                margin: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.schedule,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              // Days of week
              ...daysOfWeek.map((day) {
                final isToday = day.year == now.year && 
                              day.month == now.month && 
                              day.day == now.day;
                
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isToday ? AppColors.primary : AppColors.divider,
                          width: isToday ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(day),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isToday ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                            color: isToday ? AppColors.primary : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(isToday ? 4 : 0),
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: isToday ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        
        // Schedule grid with hours and slots
        Expanded(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (endHour - startHour) * hourHeight,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hours column
                  Column(
                    children: List.generate(endHour - startHour, (index) {
                      final hour = startHour + index;
                      return Container(
                        height: hourHeight,
                        width: 50,
                        padding: EdgeInsets.only(right: 8),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$hour:00',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }),
                  ),
                  
                  // Days columns
                  ...daysOfWeek.map((day) {
                    final isToday = day.year == now.year && 
                                  day.month == now.month && 
                                  day.day == now.day;
                    
                    // Find all appointments for this day
                    final dayAppointments = mockScheduleSlots.where((slot) => 
                      slot.dateTime.year == day.year &&
                      slot.dateTime.month == day.month &&
                      slot.dateTime.day == day.day
                    ).toList();
                    
                    return Expanded(
                      child: Column(
                        children: List.generate(endHour - startHour, (hourIndex) {
                          final hour = startHour + hourIndex;
                          
                          // Find appointments at this hour
                          final hourAppointments = dayAppointments.where((slot) => 
                            slot.dateTime.hour == hour
                          ).toList();
                          
                          // Check if this is the current hour
                          final isCurrentHour = isToday && hour == now.hour;
                          
                          return Stack(
                            children: [
                              // Time slot cell
                              Container(
                                height: hourHeight,
                                decoration: BoxDecoration(
                                  color: isToday ? Colors.grey[50] : Colors.white,
                                  border: Border.all(
                                    color: AppColors.divider.withOpacity(0.5),
                                    width: 0.5,
                                  ),
                                ),
                                child: hourAppointments.isEmpty
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedDate = day;
                                        });
                                        _showAddSlotDialog(
                                          preselectedTime: TimeOfDay(hour: hour, minute: 0),
                                        );
                                      },
                                      child: Container(),
                                    )
                                  : Column(
                                      children: hourAppointments.map((slot) => 
                                        InkWell(
                                          onTap: () {
                                            _showSlotDetailsDialog(slot);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(2),
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: _getSlotColor(slot.status),
                                              borderRadius: BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  timeFormat.format(slot.dateTime),
                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                if (slot.status == 'booked')
                                                  Text(
                                                    slot.clientName,
                                                    style: TextStyle(fontSize: 10),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).toList(),
                                    ),
                              ),
                              
                              // Current time indicator
                              if (isCurrentHour)
                                Positioned(
                                  top: (now.minute / 60) * hourHeight,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 2,
                                    color: AppColors.accent,
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for slot color
  Color _getSlotColor(String status) {
    switch (status) {
      case 'booked':
        return AppColors.slotBooked;
      case 'available':
        return AppColors.slotAvailable;
      case 'blocked':
        return AppColors.slotBlocked;
      default:
        return Colors.grey[200]!;
    }
  }

  void _showSlotDetailsDialog(ScheduleSlot slot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          slot.status == 'booked' 
              ? 'Appointment Details'
              : '${slot.status.capitalize()} Time Slot',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat('EEEE, MMMM d').format(slot.dateTime)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${timeFormat.format(slot.dateTime)} - ${timeFormat.format(slot.dateTime.add(slot.duration))}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text('Duration: ${slot.duration.inMinutes} minutes'),
            SizedBox(height: 8),
            if (slot.status == 'booked') ...[
              Divider(),
              SizedBox(height: 8),
              Text(
                'Client Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Name: ${slot.clientName}'),
              SizedBox(height: 4),
              Text('Service: ${slot.serviceType}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          if (slot.status == 'booked')
            OutlinedButton.icon(
              icon: Icon(Icons.phone),
              label: Text('Call'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              onPressed: () {
                // Call client
                Navigator.of(context).pop();
              },
            ),
          ElevatedButton.icon(
            icon: Icon(
              slot.status == 'available' 
                  ? Icons.block 
                  : (slot.status == 'blocked' ? Icons.event_available : Icons.edit_calendar),
            ),
            label: Text(
              slot.status == 'available' 
                  ? 'Block' 
                  : (slot.status == 'blocked' ? 'Make Available' : 'Reschedule'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: slot.status == 'available' 
                  ? AppColors.error 
                  : (slot.status == 'blocked' ? AppColors.success : AppColors.primary),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Action based on status
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCard(ScheduleSlot slot) {
    // Determine card color based on status
    Color statusColor;
    if (slot.status == 'booked') {
      statusColor = AppColors.slotBooked;
    } else if (slot.status == 'available') {
      statusColor = AppColors.slotAvailable;
    } else {
      statusColor = AppColors.slotBlocked; // Blocked
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: statusColor,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeFormat.format(slot.dateTime),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                _buildStatusChip(slot.status),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Duration: ${slot.duration.inMinutes} minutes',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            if (slot.status == 'booked') ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),
              Text(
                'Client: ${slot.clientName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('Service: ${slot.serviceType}'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.phone),
                    label: Text('Call'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      // Call client
                    },
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: Icon(Icons.edit_calendar),
                    label: Text('Reschedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Reschedule appointment
                    },
                  ),
                ],
              ),
            ],
            if (slot.status == 'available') ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.block),
                    label: Text('Block'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    onPressed: () {
                      // Block time slot
                    },
                  ),
                ],
              ),
            ],
            if (slot.status == 'blocked') ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.event_available),
                    label: Text('Make Available'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.success,
                    ),
                    onPressed: () {
                      // Make time slot available
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    IconData icon;
    Color color;
    String label;
    
    switch (status) {
      case 'booked':
        icon = Icons.event_available;
        color = AppColors.info;
        label = 'Booked';
        break;
      case 'available':
        icon = Icons.event_available;
        color = AppColors.success;
        label = 'Available';
        break;
      case 'blocked':
        icon = Icons.block;
        color = AppColors.textSecondary;
        label = 'Blocked';
        break;
      default:
        icon = Icons.event_note;
        color = Colors.grey;
        label = status.capitalize();
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
  
  void _showAddSlotDialog({TimeOfDay? preselectedTime}) {
    final timeController = TextEditingController();
    final durationController = TextEditingController(text: '30');
    String status = 'available';
    
    // If preselected time is provided, set it
    TimeOfDay selectedTime = preselectedTime ?? TimeOfDay.now();
    if (preselectedTime != null) {
      final hour = preselectedTime.hour.toString().padLeft(2, '0');
      final minute = preselectedTime.minute.toString().padLeft(2, '0');
      timeController.text = '$hour:$minute';
    } else {
      final now = TimeOfDay.now();
      final hour = now.hour.toString().padLeft(2, '0');
      final minute = now.minute.toString().padLeft(2, '0');
      timeController.text = '$hour:$minute';
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Time Slot'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Date: ${DateFormat('EEE, MMM d, yyyy').format(_selectedDate)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  final pickedTime = await showCustomTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  
                  if (pickedTime != null) {
                    selectedTime = pickedTime;
                    final hour = pickedTime.hour.toString().padLeft(2, '0');
                    final minute = pickedTime.minute.toString().padLeft(2, '0');
                    timeController.text = '$hour:$minute';
                  }
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: status,
                items: [
                  DropdownMenuItem(
                    value: 'available',
                    child: Text('Available'),
                  ),
                  DropdownMenuItem(
                    value: 'blocked',
                    child: Text('Blocked'),
                  ),
                ],
                onChanged: (value) {
                  status = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Add the time slot logic would go here
              // This would call an API in a real app
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Time slot added')),
              );
              
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return this.isNotEmpty 
        ? '${this[0].toUpperCase()}${this.substring(1)}'
        : '';
  }
}