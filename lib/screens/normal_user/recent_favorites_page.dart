import 'package:flutter/material.dart';
import '../../models/business.dart';
import '../../utils/app_colors.dart';

class RecentFavoritesPage extends StatelessWidget {
  const RecentFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get all businesses for recent
    final recent = mockBusinesses;
    
    // Mock recommendations (in a real app, this would be based on user preferences, location, etc.)
    final recommendations = List.of(mockBusinesses)..shuffle();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommendations',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildRecommendationsList(recommendations.take(5).toList()),
              SizedBox(height: 24),
              Text(
                'Recent',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildRecentList(recent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationsList(List<Business> recommendations) {
    if (recommendations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text('No recommendations available yet.'),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final business = recommendations[index];
          return _buildRecommendationCard(business);
        },
      ),
    );
  }

  Widget _buildRecommendationCard(Business business) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder image
            Container(
              height: 100,
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.business, size: 40, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    business.category,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentList(List<Business> recent) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recent.length,
      itemBuilder: (context, index) {
        final business = recent[index];
        return _buildRecentCard(business);
      },
    );
  }

  Widget _buildRecentCard(Business business) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.business, color: Colors.grey[600]),
        ),
        title: Text(business.name),
        subtitle: Text(business.category),
        trailing: IconButton(
          icon: Icon(
            business.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: business.isFavorite ? AppColors.error : null,
          ),
          onPressed: () {
            // Toggle favorite status
            // API call would go here in the real app
          },
        ),
        onTap: () {
          // Navigate to business details
          // This would be implemented in the real app
        },
      ),
    );
  }
}