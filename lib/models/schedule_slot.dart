class ScheduleSlot {
  final String id;
  final DateTime dateTime;
  final Duration duration;
  final String clientName;
  final String serviceType;
  final String status; // 'booked', 'available', 'blocked'

  ScheduleSlot({
    required this.id,
    required this.dateTime,
    required this.duration,
    this.clientName = '',
    this.serviceType = '',
    required this.status,
  });
}

// Mock schedule slots for business view
final List<ScheduleSlot> mockScheduleSlots = [
  // Today slots
  ScheduleSlot(
    id: 'slot1',
    dateTime: DateTime.now().copyWith(hour: 9, minute: 0),
    duration: Duration(minutes: 30),
    clientName: 'John Smith',
    serviceType: 'Haircut',
    status: 'booked',
  ),
  ScheduleSlot(
    id: 'slot2',
    dateTime: DateTime.now().copyWith(hour: 9, minute: 30),
    duration: Duration(minutes: 30),
    status: 'available',
  ),
  ScheduleSlot(
    id: 'slot3',
    dateTime: DateTime.now().copyWith(hour: 10, minute: 0),
    duration: Duration(minutes: 60),
    clientName: 'Emma Johnson',
    serviceType: 'Hair Coloring',
    status: 'booked',
  ),
  ScheduleSlot(
    id: 'slot4',
    dateTime: DateTime.now().copyWith(hour: 11, minute: 0),
    duration: Duration(minutes: 30),
    status: 'available',
  ),
  ScheduleSlot(
    id: 'slot5',
    dateTime: DateTime.now().copyWith(hour: 11, minute: 30),
    duration: Duration(minutes: 30),
    status: 'blocked',
  ),
  ScheduleSlot(
    id: 'slot6',
    dateTime: DateTime.now().copyWith(hour: 12, minute: 0),
    duration: Duration(minutes: 60),
    status: 'blocked', // Lunch break
  ),
  ScheduleSlot(
    id: 'slot7',
    dateTime: DateTime.now().copyWith(hour: 13, minute: 0),
    duration: Duration(minutes: 45),
    clientName: 'Michael Brown',
    serviceType: 'Beard Trim & Haircut',
    status: 'booked',
  ),
  
  // Tomorrow slots
  ScheduleSlot(
    id: 'slot8',
    dateTime: DateTime.now().add(Duration(days: 1)).copyWith(hour: 9, minute: 0),
    duration: Duration(minutes: 30),
    status: 'available',
  ),
  ScheduleSlot(
    id: 'slot9',
    dateTime: DateTime.now().add(Duration(days: 1)).copyWith(hour: 9, minute: 30),
    duration: Duration(minutes: 60),
    clientName: 'Sarah Williams',
    serviceType: 'Full Hair Treatment',
    status: 'booked',
  ),
  ScheduleSlot(
    id: 'slot10',
    dateTime: DateTime.now().add(Duration(days: 1)).copyWith(hour: 10, minute: 30),
    duration: Duration(minutes: 30),
    status: 'available',
  ),
];