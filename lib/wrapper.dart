import 'package:flutter/material.dart';
import 'package:authentication_otp_app/homepage.dart';
import 'package:authentication_otp_app/login.dart';
import 'package:authentication_otp_app/otp.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key, required String title});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String _currentPage = 'login';
  String? _phoneNumber;
  String? _verificationId;

  void goToLogin() {
    setState(() {
      _currentPage = 'login';
      _phoneNumber = null;
      _verificationId = null;
    });
  }

  void goToOtp(String phoneNumber, String verificationId) {
    setState(() {
      _currentPage = 'otp';
      _phoneNumber = phoneNumber;
      _verificationId = verificationId;
    });
  }

  void goToHomepage() {
    setState(() {
      _currentPage = 'homepage';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case 'login':
        return PhoneHome(
          onCodeSent: (phoneNumber, verificationId) {
            goToOtp(phoneNumber, verificationId);
          },
        );
      
      case 'otp':
        return OtpPage(
          vid: _verificationId ?? 'default_verification_id',
          onVerificationSuccess: () {
            goToHomepage();
          },
          onBackToLogin: () {
            goToLogin();
          },
        );
      
      case 'homepage':
        return Homepage(
          phoneNumber: _phoneNumber,
          onLogout: () {
            goToLogin();
          },
        );
      
      default:
        return PhoneHome(
          onCodeSent: (phoneNumber, verificationId) {
            goToOtp(phoneNumber, verificationId);
          },
        );
    }
  }
}