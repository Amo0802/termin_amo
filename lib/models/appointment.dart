class Appointment {
  final String id;
  final String businessId;
  final String businessName;
  final String serviceType;
  final DateTime dateTime;
  final Duration duration;
  final String status; // 'upcoming', 'completed', 'cancelled'

  Appointment({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.serviceType,
    required this.dateTime,
    required this.duration,
    required this.status,
  });
}

// Mock appointments data
final List<Appointment> mockAppointments = [
  Appointment(
    id: 'app1',
    businessId: '1',
    businessName: 'Style Hair Salon',
    serviceType: 'Haircut',
    dateTime: DateTime.now().add(Duration(days: 2)),
    duration: Duration(minutes: 30),
    status: 'upcoming',
  ),
  Appointment(
    id: 'app2',
    businessId: '2',
    businessName: 'Bright Smile Dental',
    serviceType: 'Teeth Cleaning',
    dateTime: DateTime.now().add(Duration(days: 5)),
    duration: Duration(minutes: 60),
    status: 'upcoming',
  ),
  Appointment(
    id: 'app3',
    businessId: '4',
    businessName: 'City Spa & Massage',
    serviceType: 'Full Body Massage',
    dateTime: DateTime.now().subtract(Duration(days: 3)),
    duration: Duration(minutes: 90),
    status: 'completed',
  ),
  Appointment(
    id: 'app4',
    businessId: '3',
    businessName: 'Perfect Nails',
    serviceType: 'Manicure',
    dateTime: DateTime.now().add(Duration(hours: 5)),
    duration: Duration(minutes: 45),
    status: 'upcoming',
  ),
  Appointment(
    id: 'app5',
    businessId: '5',
    businessName: 'Dr. Smith Pediatrics',
    serviceType: 'Checkup',
    dateTime: DateTime.now().subtract(Duration(days: 1)),
    duration: Duration(minutes: 30),
    status: 'cancelled',
  ),
];