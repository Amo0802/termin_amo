import 'package:flutter/material.dart';
import 'package:termin_amo/utils/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App logo
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // App name and version
            Center(
              child: Column(
                children: [
                  Text(
                    'Scheduler',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            
            // Description
            Text(
              'About The App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Scheduler is an appointment booking application that helps connect businesses and customers. Make appointments with your favorite service providers or manage your business schedule with ease.',
              style: TextStyle(
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            
            // Feature list
            Text(
              'Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8),
            _buildFeatureItem(
              icon: Icons.search,
              title: 'Find Businesses',
              description: 'Search for businesses by name or category',
            ),
            _buildFeatureItem(
              icon: Icons.calendar_today,
              title: 'Book Appointments',
              description: 'Schedule appointments with service providers',
            ),
            _buildFeatureItem(
              icon: Icons.favorite,
              title: 'Save Favorites',
              description: 'Mark your favorite businesses for quick access',
            ),
            _buildFeatureItem(
              icon: Icons.schedule,
              title: 'Business Management',
              description: 'Create and manage your business schedule',
            ),
            SizedBox(height: 24),
            
            // Links section
            Text(
              'Legal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8),
            _buildLinkItem(
              title: 'Terms of Service',
              onTap: () {
                _openLegalPage(context, 'Terms of Service');
              },
            ),
            _buildLinkItem(
              title: 'Privacy Policy',
              onTap: () {
                _openLegalPage(context, 'Privacy Policy');
              },
            ),
            _buildLinkItem(
              title: 'Contact Us',
              onTap: () {
                _showContactDialog(context);
              },
            ),
            
            // Copyright
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  '© 2025 Scheduler Inc. All rights reserved.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _openLegalPage(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _LegalPage(title: title),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Us'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Have questions or feedback? Reach out to us:'),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('support@scheduler-app.com'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.language, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('www.scheduler-app.com'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Legal pages (Terms, Privacy Policy)
class _LegalPage extends StatelessWidget {
  final String title;

  const _LegalPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Last Updated: May 17, 2025',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24),
            
            // Sample content
            if (title == 'Privacy Policy')
              _buildPrivacyPolicy()
            else
              _buildTermsOfService(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegalSection(
          title: '1. Introduction',
          content: 'This Privacy Policy explains how Scheduler ("we," "our," or "us") collects, uses, and shares your information when you use our mobile application and services. Please read this policy carefully to understand our practices regarding your personal data.',
        ),
        _buildLegalSection(
          title: '2. Information We Collect',
          content: 'We collect information that you provide directly to us, such as when you create an account, book appointments, or contact customer support. This may include your name, email address, phone number, and payment information. We also collect certain information automatically when you use our services, including device information and usage statistics.',
        ),
        _buildLegalSection(
          title: '3. How We Use Your Information',
          content: 'We use your information to provide and improve our services, process transactions, send notifications, and communicate with you. We may also use your information for analytics purposes and to personalize your experience.',
        ),
        _buildLegalSection(
          title: '4. Sharing Your Information',
          content: 'We may share your information with businesses you book with through our platform, service providers who help us operate our services, or as required by law. We do not sell your personal information to third parties.',
        ),
        _buildLegalSection(
          title: '5. Your Rights and Choices',
          content: 'You can access, update, or delete your account information at any time through the app settings. You may also opt out of certain communications from us.',
        ),
        _buildLegalSection(
          title: '6. Data Security',
          content: 'We implement appropriate security measures to protect your personal information from unauthorized access, alteration, or disclosure.',
        ),
        _buildLegalSection(
          title: '7. Changes to This Policy',
          content: 'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last Updated" date.',
        ),
        _buildLegalSection(
          title: '8. Contact Us',
          content: 'If you have any questions about this Privacy Policy, please contact us at privacy@scheduler-app.com.',
        ),
      ],
    );
  }

  Widget _buildTermsOfService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegalSection(
          title: '1. Acceptance of Terms',
          content: 'By accessing or using the Scheduler app, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services.',
        ),
        _buildLegalSection(
          title: '2. Description of Service',
          content: 'Scheduler is an appointment booking platform that connects users with service providers. We provide tools for scheduling, managing, and organizing appointments.',
        ),
        _buildLegalSection(
          title: '3. User Accounts',
          content: 'You must create an account to use certain features of our service. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
        ),
        _buildLegalSection(
          title: '4. User Conduct',
          content: 'You agree not to use our services for any unlawful purpose or in any way that could damage, disable, or impair our services. You also agree not to attempt to gain unauthorized access to any part of our services.',
        ),
        _buildLegalSection(
          title: '5. Business Subscriptions',
          content: 'Business users may purchase a subscription to access premium features. Subscriptions will automatically renew unless canceled before the renewal date. Refunds are provided in accordance with applicable law.',
        ),
        _buildLegalSection(
          title: '6. Intellectual Property',
          content: 'The Scheduler app, including its content and features, is owned by us and is protected by copyright, trademark, and other intellectual property laws.',
        ),
        _buildLegalSection(
          title: '7. Disclaimer of Warranties',
          content: 'Our services are provided "as is" and "as available" without any warranties of any kind, either express or implied.',
        ),
        _buildLegalSection(
          title: '8. Limitation of Liability',
          content: 'To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use or inability to use our services.',
        ),
        _buildLegalSection(
          title: '9. Changes to Terms',
          content: 'We may modify these Terms of Service at any time. We will notify you of any material changes by posting the updated terms on this page.',
        ),
        _buildLegalSection(
          title: '10. Governing Law',
          content: 'These Terms of Service shall be governed by and construed in accordance with the laws of the state/country in which our company is registered, without regard to its conflict of law provisions.',
        ),
      ],
    );
  }

  Widget _buildLegalSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}