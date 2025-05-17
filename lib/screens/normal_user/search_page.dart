import 'package:flutter/material.dart';
import '../../models/business.dart';
import 'business_details_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _categories = [
    'All',
    'Hairdresser',
    'Dentist',
    'Nail Salon',
    'Spa',
    'Doctor',
    'Fitness',
    'Barber',
  ];
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    // Filter businesses based on search query and selected category
    List<Business> filteredBusinesses = mockBusinesses.where((business) {
      bool matchesQuery = business.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          business.category.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesCategory = _selectedCategory == 'All' || 
          business.category == _selectedCategory;
      
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search businesses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),
            
            // Category filter chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(_categories[index]),
                      selected: _selectedCategory == _categories[index],
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = _categories[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            
            // Results count
            Text(
              '${filteredBusinesses.length} results',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            
            // Results list
            Expanded(
              child: filteredBusinesses.isEmpty
                  ? Center(
                      child: Text('No results found'),
                    )
                  : ListView.builder(
                      itemCount: filteredBusinesses.length,
                      itemBuilder: (context, index) {
                        final business = filteredBusinesses[index];
                        return _buildBusinessCard(context, business);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessCard(BuildContext context, Business business) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to business details page when card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusinessDetailsPage(
                businessId: business.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.business, color: Colors.grey[600], size: 40),
              ),
              SizedBox(width: 16),
              
              // Business details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      business.category,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(' 4.5 (42)', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey, size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            business.address,
                            style: TextStyle(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to business details for booking
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusinessDetailsPage(
                                  businessId: business.id,
                                ),
                              ),
                            );
                          },
                          child: Text('Book Now'),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            business.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: business.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            // Toggle favorite
                            // API call would go here
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}