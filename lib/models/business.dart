class Business {
  final String id;
  final String name;
  final String category;
  final String address;
  final String phone;
  final String imageUrl;
  final bool isFavorite;

  Business({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.phone,
    required this.imageUrl,
    this.isFavorite = false,
  });
}

// Mock data
final List<Business> mockBusinesses = [
  Business(
    id: '1',
    name: 'Style Hair Salon',
    category: 'Hairdresser',
    address: '123 Main St, City',
    phone: '+1 123-456-7890',
    imageUrl: 'https://picsum.photos/200/300',
    isFavorite: true,
  ),
  Business(
    id: '2',
    name: 'Bright Smile Dental',
    category: 'Dentist',
    address: '456 Oak Ave, City',
    phone: '+1 987-654-3210',
    imageUrl: 'https://picsum.photos/200/301',
    isFavorite: true,
  ),
  Business(
    id: '3',
    name: 'Perfect Nails',
    category: 'Nail Salon',
    address: '789 Pine Rd, City',
    phone: '+1 456-789-0123',
    imageUrl: 'https://picsum.photos/200/302',
    isFavorite: false,
  ),
  Business(
    id: '4',
    name: 'City Spa & Massage',
    category: 'Spa',
    address: '101 Elm St, City',
    phone: '+1 321-654-9870',
    imageUrl: 'https://picsum.photos/200/303',
    isFavorite: false,
  ),
  Business(
    id: '5',
    name: 'Dr. Smith Pediatrics',
    category: 'Doctor',
    address: '202 Cedar Blvd, City',
    phone: '+1 789-123-4560',
    imageUrl: 'https://picsum.photos/200/304',
    isFavorite: true,
  ),
];