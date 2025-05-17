import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/normal_user/recent_favorites_page.dart';
import 'screens/normal_user/appointments_page.dart';
import 'screens/normal_user/search_page.dart';
import 'screens/normal_user/favorites_page.dart';
import 'screens/normal_user/profile_page.dart';
import 'screens/business_user/schedule_page.dart';
import 'screens/business_user/schedule_settings_page.dart';
import 'screens/business_user/business_profile_page.dart';
import 'models/user_type.dart';
import 'providers/user_provider.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduling App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primaryColorLight: AppColors.primaryLight,
        primaryColorDark: AppColors.primaryDark,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        dividerColor: AppColors.divider,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
          titleLarge: TextStyle(color: AppColors.textPrimary),
          titleMedium: TextStyle(color: AppColors.textPrimary),
          labelLarge: TextStyle(color: AppColors.textPrimary),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // Define the pages for normal users
    final normalUserPages = [
      RecentFavoritesPage(),
      AppointmentsPage(),
      SearchPage(),
      FavoritesPage(),
      ProfilePage(),
    ];
    
    // Define the pages for business users
    final businessUserPages = [
      SchedulePage(),
      ScheduleSettingsPage(),
      BusinessProfilePage(),
    ];
    
    // Get the appropriate page list based on user type
    final pages = userProvider.userType == UserType.normal 
        ? normalUserPages 
        : businessUserPages;
    
    // Ensure the current index is valid for the current user type
    if (_currentIndex >= pages.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.userType == UserType.normal ? 'Scheduler' : 'Business Scheduler'),
        actions: [
          // Toggle switch between normal and business account
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Business', style: TextStyle(color: Colors.white)),
                Switch(
                  value: userProvider.userType == UserType.business,
                  onChanged: (bool value) {
                    userProvider.toggleUserType();
                    // Reset to first tab when switching user types
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  activeColor: AppColors.accent,
                  activeTrackColor: AppColors.accentLight,
                ),
              ],
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.bottomNavBackground,
        selectedItemColor: AppColors.bottomNavActiveItem,
        unselectedItemColor: AppColors.bottomNavInactiveItem,
        type: BottomNavigationBarType.fixed,
        items: userProvider.userType == UserType.normal
            ? [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Appointments',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ]
            : [
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Profile',
                ),
              ],
      ),
    );
  }
}