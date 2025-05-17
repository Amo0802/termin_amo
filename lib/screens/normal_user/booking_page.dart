import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/business.dart';
import '../../utils/app_colors.dart';
import '../../models/schedule_slot.dart';
import 'dart:math';

class BookingPage extends StatefulWidget {
  final String businessId;
  final String? preselectedService;

  const BookingPage({
    Key? key,
    required this.businessId,
    this.preselectedService,
  }) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late Business _business;
  bool _isLoading = true;
  
  // Selected booking parameters
  DateTime _selectedDate = DateTime.now();
  String? _selectedService;
  ScheduleSlot? _selectedTimeSlot;
  
  // Service data (would come from API)
  final List<Map<String, dynamic>> _services = [
    {'name': 'Haircut', 'duration': 30, 'price': 35.00},
    {'name': 'Hair Coloring', 'duration': 60, 'price': 85.00},
    {'name': 'Styling', 'duration': 45, 'price': 50.00},
    {'name': 'Beard Trim', 'duration': 15, 'price': 15.00},
    {'name': 'Full Hair Treatment', 'duration': 90, 'price': 120.00},
  ];
  
  // Mock available slots for selected date (would come from API)
  List<ScheduleSlot> _availableSlots = [];

  @override
  void initState() {
    super.initState();
    _loadBusinessData();
    
    // If a service was preselected, use it
    if (widget.preselectedService != null) {
      _selectedService = widget.preselectedService;
    }
    
    // Generate mock availability data
    _generateMockAvailability();
  }

  Future<void> _loadBusinessData() async {
    // Simulate API call
    await Future.delayed(Duration(milliseconds: 300));
    
    // Find business from mock data by ID
    try {
      _business = mockBusinesses.firstWhere((b) => b.id == widget.businessId);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to first business if ID not found (just for demo)
      _business = mockBusinesses.first;
      setState(() {
        _isLoading = false;
      });
    }
  }

  // This method would be replaced by an actual API call in a real app
  void _generateMockAvailability() {
    // Clear previous slots
    _availableSlots = [];
    
    // Get the start and end of business hours (9 AM - 5 PM)
    final startHour = 9;
    final endHour = 17;
    
    // Create a random number generator
    final random = Random();
    
    // Create slots at 30-minute intervals and randomly mark some as unavailable
    for (int hour = startHour; hour < endHour; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        // Skip some slots randomly to simulate unavailability (70% available)
        if (random.nextDouble() > 0.7) continue;
        
        _availableSlots.add(
          ScheduleSlot(
            id: 'slot-${_availableSlots.length}',
            dateTime: DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              hour,
              minute,
            ),
            duration: Duration(minutes: 30),
            status: 'available',
          ),
        );
      }
    }
    
    // Sort slots by time
    _availableSlots.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  // Calculate the total price based on selected service
  double get _totalPrice {
    if (_selectedService == null) return 0.0;
    
    final service = _services.firstWhere(
      (s) => s['name'] == _selectedService,
      orElse: () => {'price': 0.0},
    );
    
    return service['price'] as double;
  }

  // When date changes, update available slots
  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTimeSlot = null; // Clear selected time slot
      _generateMockAvailability(); // In real app, this would be an API call
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Book Appointment'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _business.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step 1: Select Service
                    _buildSectionTitle('1. Select Service'),
                    _buildServiceSelector(),
                    SizedBox(height: 24),
                    
                    // Step 2: Select Date
                    _buildSectionTitle('2. Select Date'),
                    _buildDateSelector(),
                    SizedBox(height: 24),
                    
                    // Step 3: Select Time
                    _buildSectionTitle('3. Select Time'),
                    _buildTimeSelector(),
                    SizedBox(height: 32),
                    
                    // Booking summary (only shown when all selections are made)
                    if (_selectedService != null && _selectedTimeSlot != null)
                      _buildBookingSummary(),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom booking button
          _buildBookingButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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

  Widget _buildServiceSelector() {
    return Column(
      children: _services.map((service) {
        final bool isSelected = _selectedService == service['name'];
        
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedService = service['name'];
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${service['duration']} minutes',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${service['price'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateSelector() {
    // Generate next 14 days for the date picker
    final List<DateTime> dates = List.generate(
      14,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _selectedDate.year == date.year &&
              _selectedDate.month == date.month &&
              _selectedDate.day == date.day;
          final isToday = date.day == DateTime.now().day &&
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year;

          return GestureDetector(
            onTap: () {
              _onDateChanged(date);
            },
            child: Container(
              width: 60,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey[300]!,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  if (isToday)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.3)
                            : AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? Colors.white
                              : AppColors.primary,
                        ),
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

  Widget _buildTimeSelector() {
    if (_availableSlots.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.event_busy,
                  size: 48,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No available slots for this date',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please select another date',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Group time slots by morning, afternoon, and evening for better organization
    final morningSlots = _availableSlots.where(
      (slot) => slot.dateTime.hour < 12
    ).toList();
    
    final afternoonSlots = _availableSlots.where(
      (slot) => slot.dateTime.hour >= 12 && slot.dateTime.hour < 17
    ).toList();
    
    final eveningSlots = _availableSlots.where(
      (slot) => slot.dateTime.hour >= 17
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (morningSlots.isNotEmpty) ...[
          _buildTimeOfDayLabel('Morning'),
          _buildTimeSlots(morningSlots),
          SizedBox(height: 16),
        ],
        
        if (afternoonSlots.isNotEmpty) ...[
          _buildTimeOfDayLabel('Afternoon'),
          _buildTimeSlots(afternoonSlots),
          SizedBox(height: 16),
        ],
        
        if (eveningSlots.isNotEmpty) ...[
          _buildTimeOfDayLabel('Evening'),
          _buildTimeSlots(eveningSlots),
        ],
      ],
    );
  }

  Widget _buildTimeOfDayLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTimeSlots(List<ScheduleSlot> slots) {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: slots.map((slot) {
        final bool isSelected = _selectedTimeSlot?.id == slot.id;
        
        // Format time display
        final hour = slot.dateTime.hour;
        final minute = slot.dateTime.minute.toString().padLeft(2, '0');
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final timeDisplay = '$displayHour:$minute $period';
        
        return InkWell(
          onTap: () {
            setState(() {
              _selectedTimeSlot = slot;
            });
          },
          child: Container(
            width: 85,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                timeDisplay,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBookingSummary() {
    // Format selected date and time
    final dateFormatter = new DateFormat('EEEE, MMMM d, yyyy');
    final timeFormatter = new DateFormat('h:mm a');
    
    // Get service details
    final selectedServiceDetails = _services.firstWhere(
      (s) => s['name'] == _selectedService,
      orElse: () => {'name': 'Unknown', 'duration': 0, 'price': 0.0},
    );
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            // Service
            _buildSummaryRow(
              icon: Icons.spa,
              label: 'Service',
              value: _selectedService ?? 'None selected',
            ),
            
            // Duration
            _buildSummaryRow(
              icon: Icons.schedule,
              label: 'Duration',
              value: '${selectedServiceDetails['duration']} minutes',
            ),
            
            // Date
            _buildSummaryRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: dateFormatter.format(_selectedDate),
            ),
            
            // Time
            _buildSummaryRow(
              icon: Icons.access_time,
              label: 'Time',
              value: _selectedTimeSlot != null
                  ? timeFormatter.format(_selectedTimeSlot!.dateTime)
                  : 'None selected',
            ),
            
            Divider(height: 32),
            
            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${_totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton() {
    final bool canBook = _selectedService != null && _selectedTimeSlot != null;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: canBook
            ? () {
                // Would trigger booking API in real app
                _showBookingConfirmationDialog();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          canBook
              ? 'Confirm Booking • \$${_totalPrice.toStringAsFixed(2)}'
              : 'Select service, date and time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showBookingConfirmationDialog() {
    // Format selected date and time for display
    final dateFormatter = new DateFormat('EEEE, MMMM d, yyyy');
    final timeFormatter = new DateFormat('h:mm a');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Please confirm your appointment details:'),
              SizedBox(height: 16),
              _buildConfirmationDetail(
                label: 'Business',
                value: _business.name,
              ),
              _buildConfirmationDetail(
                label: 'Service',
                value: _selectedService!,
              ),
              _buildConfirmationDetail(
                label: 'Date',
                value: dateFormatter.format(_selectedDate),
              ),
              _buildConfirmationDetail(
                label: 'Time',
                value: timeFormatter.format(_selectedTimeSlot!.dateTime),
              ),
              _buildConfirmationDetail(
                label: 'Price',
                value: '\$${_totalPrice.toStringAsFixed(2)}',
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text('Confirm'),
              onPressed: () {
                // In a real app, this would call an API to create the booking
                Navigator.of(context).pop(); // Close dialog
                
                // Show success message and return to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking confirmed! Check your Appointments tab.'),
                    duration: Duration(seconds: 4),
                  ),
                );
                
                // In a real app, navigate to appointments page or booking confirmation page
                Navigator.of(context).pop(); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmationDetail({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}