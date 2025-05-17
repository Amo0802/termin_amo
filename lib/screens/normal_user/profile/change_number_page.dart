import 'package:flutter/material.dart';
import 'package:termin_amo/utils/app_colors.dart';

class ChangeNumberPage extends StatefulWidget {
  const ChangeNumberPage({Key? key}) : super(key: key);

  @override
  _ChangeNumberPageState createState() => _ChangeNumberPageState();
}

class _ChangeNumberPageState extends State<ChangeNumberPage> {
  final _phoneController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  
  bool _isLoading = false;
  bool _isVerificationCodeSent = false;
  bool _isVerifying = false;

  // Mock current phone number - in a real app this would come from a user service
  @override
  void initState() {
    super.initState();
    // Pre-fill with current value
    _phoneController.text = "+1 123-456-7890";
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  void _requestVerificationCode() {
    // Validate phone number
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call to send verification code
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _isVerificationCodeSent = true;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code sent to ${_phoneController.text}')),
      );
    });
  }

  void _verifyCodeAndUpdateNumber() {
    // Validate verification code
    if (_verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the verification code')),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // Simulate API call to verify code and update number
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isVerifying = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number updated successfully')),
      );
      
      // Return to previous screen
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Text(
              'Update your phone number',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Enter your new phone number below',
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
              enabled: !_isVerificationCodeSent, // Disable after sending code
            ),
            SizedBox(height: 16),
            
            if (!_isVerificationCodeSent)
              // Request verification code button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _requestVerificationCode,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Send Verification Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            
            if (_isVerificationCodeSent) ...[
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
              Center(
                child: TextButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text('Resend Code'),
                  onPressed: () {
                    // In a real app, this would request a new code via API
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('New verification code sent')),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              
              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isVerifying ? null : _verifyCodeAndUpdateNumber,
                  child: _isVerifying
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Verify and Update',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}