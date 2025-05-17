import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final _phoneController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Credit card controllers (for business registration)
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCVVController = TextEditingController();
  final _cardHolderController = TextEditingController();

  // Registration state
  bool _isBusinessAccount = false;
  int _currentStep = 0; // 0: Phone, 1: Verification code, 2: Personal info
  String? _selectedSubscription;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _verificationCodeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCVVController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _submitPhoneNumber() {
    // Validate phone number
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }
    
    // In a real app, this would call an API to send verification code
    setState(() {
      _currentStep = 1;
    });
    
    // Show a snackbar indicating a code was sent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verification code sent to ${_phoneController.text}')),
    );
  }

  void _verifyCode() {
    // Validate verification code
    if (_verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the verification code')),
      );
      return;
    }
    
    // In a real app, this would verify the code via API
    setState(() {
      _currentStep = 2;
    });
  }

  void _completeRegistration() {
    // Validate form
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    
    // Additional validation for business accounts
    if (_isBusinessAccount) {
      if (_selectedSubscription == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a subscription plan')),
        );
        return;
      }
      
      if (_cardNumberController.text.isEmpty ||
          _cardExpiryController.text.isEmpty ||
          _cardCVVController.text.isEmpty ||
          _cardHolderController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all payment details')),
        );
        return;
      }
    }
    
    // Show loading
    setState(() {
      _isSubmitting = true;
    });
    
    // In a real app, this would submit registration data to API
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isSubmitting = false;
      });
      
      // Navigate to home page after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Container()), // Would be HomePage in real app
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Account type selector
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildAccountTypeButton(
                        title: 'Personal',
                        isSelected: !_isBusinessAccount,
                        onTap: () {
                          setState(() {
                            _isBusinessAccount = false;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildAccountTypeButton(
                        title: 'Business',
                        isSelected: _isBusinessAccount,
                        onTap: () {
                          setState(() {
                            _isBusinessAccount = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Registration steps
              if (_currentStep == 0)
                _buildPhoneStep()
              else if (_currentStep == 1)
                _buildVerificationStep()
              else
                _buildPersonalInfoStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${_isBusinessAccount ? 'Business' : 'Personal'} Registration',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Enter your phone number to receive a verification code',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32),
        
        // Phone number field
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 32),
        
        // Credit card fields for business account
        if (_isBusinessAccount) ...[
          Text(
            'Payment Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          // Credit card number
          TextField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: 'XXXX XXXX XXXX XXXX',
              prefixIcon: Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          
          // Card holder name
          TextField(
            controller: _cardHolderController,
            decoration: InputDecoration(
              labelText: 'Card Holder Name',
              hintText: 'Name as it appears on card',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 16),
          
          // Expiry date and CVV in a row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cardExpiryController,
                  decoration: InputDecoration(
                    labelText: 'Expires (MM/YY)',
                    hintText: 'MM/YY',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _cardCVVController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: 'XXX',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 3,
                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          
          // Subscription plans
          Text(
            'Select Subscription Plan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          // Monthly plan
          _buildSubscriptionOption(
            title: 'Monthly',
            price: '€10',
            description: 'Billed monthly, cancel anytime',
            value: 'monthly',
          ),
          SizedBox(height: 12),
          
          // Annual plan
          _buildSubscriptionOption(
            title: 'Annual',
            price: '€100',
            description: 'Billed annually, save 16%',
            value: 'annual',
            isBestValue: true,
          ),
          SizedBox(height: 32),
        ],
        
        // Continue button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _submitPhoneNumber,
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 24),
        
        // Login link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () {
                // Navigate back to login page
                Navigator.pop(context);
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscriptionOption({
    required String title,
    required String price,
    required String description,
    required String value,
    bool isBestValue = false,
  }) {
    final isSelected = _selectedSubscription == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSubscription = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: _selectedSubscription,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSubscription = newValue;
                });
              },
              activeColor: AppColors.primary,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (isBestValue) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Best Value',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Phone Verification',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Enter the 6-digit code sent to ${_phoneController.text}',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32),
        
        // Verification code field
        TextField(
          controller: _verificationCodeController,
          decoration: InputDecoration(
            labelText: 'Verification Code',
            hintText: 'Enter 6-digit code',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        SizedBox(height: 16),
        
        // Resend code button
        TextButton.icon(
          icon: Icon(Icons.refresh),
          label: Text('Resend Code'),
          onPressed: () {
            // In a real app, this would request a new code via API
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('New verification code sent')),
            );
          },
        ),
        SizedBox(height: 32),
        
        // Verify button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _verifyCode,
          child: Text(
            'Verify',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Please complete your profile information',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32),
        
        // First name field
        TextField(
          controller: _firstNameController,
          decoration: InputDecoration(
            labelText: 'First Name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 16),
        
        // Last name field
        TextField(
          controller: _lastNameController,
          decoration: InputDecoration(
            labelText: 'Last Name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 16),
        
        // Password field
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          obscureText: true,
        ),
        SizedBox(height: 16),
        
        // Confirm password field
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          obscureText: true,
        ),
        SizedBox(height: 32),
        
        // Register button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _isSubmitting ? null : _completeRegistration,
          child: _isSubmitting
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Complete Registration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}