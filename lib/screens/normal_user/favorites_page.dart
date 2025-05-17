import 'package:flutter/material.dart';
import '../../models/business.dart';
import '../../utils/app_colors.dart';
import 'business_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter favorites
    final favorites = mockBusinesses.where((business) => business.isFavorite).toList();
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Favorites',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add businesses to your favorites for quick access',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: Icon(Icons.search),
                            label: Text('Find Businesses'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: () {
                              // Navigate to search page - index 2
                              DefaultTabController.of(context).animateTo(2);
                            },
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final business = favorites[index];
                        return _buildFavoriteCard(context, business);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Business business) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        children: [
          // Business image header
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.business, size: 60, color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        business.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: AppColors.error,
                      ),
                      onPressed: () {
                        // Remove from favorites
                        // API call would go here
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  business.category,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' 4.5 (42)'),
                    Spacer(),
                    Icon(Icons.location_on, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      business.address.split(',')[0], // Just show the street part
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.info_outline),
                        label: Text('Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          // Navigate to business details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessDetailsPage(
                                businessId: business.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.calendar_today),
                        label: Text('Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: () {
                          // Navigate to book appointment page
                          // This would be implemented in real app
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessDetailsPage(
                                businessId: business.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}