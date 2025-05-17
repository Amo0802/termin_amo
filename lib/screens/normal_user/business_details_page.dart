import 'package:flutter/material.dart';
import '../../models/business.dart';
import '../../utils/app_colors.dart';
import 'booking_page.dart';

class BusinessDetailsPage extends StatefulWidget {
  final String businessId;

  const BusinessDetailsPage({
    Key? key,
    required this.businessId,
  }) : super(key: key);

  @override
  _BusinessDetailsPageState createState() => _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends State<BusinessDetailsPage> {
  late Business _business;
  bool _isLoading = true;

  // Mock services data
  final List<Map<String, dynamic>> _services = [
    {'name': 'Haircut', 'duration': 30, 'price': 35.00},
    {'name': 'Hair Coloring', 'duration': 60, 'price': 85.00},
    {'name': 'Styling', 'duration': 45, 'price': 50.00},
    {'name': 'Beard Trim', 'duration': 15, 'price': 15.00},
    {'name': 'Full Hair Treatment', 'duration': 90, 'price': 120.00},
  ];

  // Mock business description
  final String _description = "Style Hair Salon is a professional hair salon offering premium services for men and women. Our team of experienced stylists provides exceptional haircuts, styling, coloring, and treatments in a welcoming environment. We use only high-quality products and stay up-to-date with the latest trends and techniques to ensure our clients always leave looking and feeling their best.";

  @override
  void initState() {
    super.initState();
    _loadBusinessData();
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              // App bar with business image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.business,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _business.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _business.isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        // This would make API call in real app
                        // For now just toggle the state locally
                        _business = Business(
                          id: _business.id,
                          name: _business.name,
                          category: _business.category,
                          address: _business.address,
                          phone: _business.phone,
                          imageUrl: _business.imageUrl,
                          isFavorite: !_business.isFavorite,
                        );
                      });
                    },
                  ),
                ],
              ),
              
              // Business details content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Business name and category
                      Text(
                        _business.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _business.category,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' 4.5 (42)'),
                        ],
                      ),
                      SizedBox(height: 12),
                      
                      // Address and contact
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: AppColors.primary),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(_business.address),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(_business.phone),
                        ],
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Services section
                      Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      ..._services.map((service) => _buildServiceItem(service, context)).toList(),
                      
                      SizedBox(height: 24),
                      
                      // Description section
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        _description,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      
                      // Extra space at bottom for the fixed book button
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Fixed "Book" button at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // Navigate to booking page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(
                        businessId: _business.id,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8),
      ),
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
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${service['duration']} minutes',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${service['price'].toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.calendar_today, color: AppColors.primary),
            onPressed: () {
              // Navigate to booking page with preselected service
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingPage(
                    businessId: _business.id,
                    preselectedService: service['name'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}