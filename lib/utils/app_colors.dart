import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF3F51B5);      // Indigo
  static const Color primaryLight = Color(0xFF7986CB); // Light Indigo
  static const Color primaryDark = Color(0xFF303F9F);  // Dark Indigo
  
  // Accent colors
  static const Color accent = Color(0xFFFF4081);       // Pink
  static const Color accentLight = Color(0xFFFF80AB);  // Light Pink
  static const Color accentDark = Color(0xFFC51162);   // Dark Pink
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);      // Green
  static const Color warning = Color(0xFFFF9800);      // Orange
  static const Color error = Color(0xFFF44336);        // Red
  static const Color info = Color(0xFF2196F3);         // Blue
  
  // Neutral colors
  static const Color background = Color(0xFFFAFAFA);   // Light Grey
  static const Color surface = Colors.white;
  static const Color divider = Color(0xFFBDBDBD);      // Grey
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);   // Almost Black
  static const Color textSecondary = Color(0xFF757575); // Medium Grey
  static const Color textDisabled = Color(0xFF9E9E9E);  // Light Grey
  
  // Bottom Navigation Bar colors
  static const Color bottomNavBackground = primary;
  static const Color bottomNavActiveItem = accent;
  static const Color bottomNavInactiveItem = Colors.white70;
  
  // Status-specific colors
  static const Color appointmentUpcoming = Color(0xFFE3F2FD);  // Light Blue
  static const Color appointmentCompleted = Color(0xFFE8F5E9); // Light Green
  static const Color appointmentCancelled = Color(0xFFFFEBEE); // Light Red
  
  static const Color slotAvailable = Color(0xFFE8F5E9);    // Light Green
  static const Color slotBooked = Color(0xFFE3F2FD);       // Light Blue
  static const Color slotBlocked = Color(0xFFF5F5F5);      // Light Grey
}