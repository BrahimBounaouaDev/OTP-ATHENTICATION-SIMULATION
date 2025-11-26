import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpPage extends StatefulWidget {
  final String vid;
  final VoidCallback? onVerificationSuccess;
  final VoidCallback? onBackToLogin;
  
  const OtpPage({Key? key, required this.vid, this.onVerificationSuccess, this.onBackToLogin}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  bool isLoading = false;
  bool isResending = false;
  int countdown = 60;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _setupOtpListeners();
    _fillDefaultOtp();
  }

  void _fillDefaultOtp() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        String defaultOtp = '123456';
        for (int i = 0; i < defaultOtp.length; i++) {
          otpControllers[i].text = defaultOtp[i];
        }
        setState(() {});
      }
    });
  }

  void _setupOtpListeners() {
    for (int i = 0; i < otpControllers.length; i++) {
      otpControllers[i].addListener(() {
        if (otpControllers[i].text.length == 1 && i < otpControllers.length - 1) {
          FocusScope.of(context).requestFocus(focusNodes[i + 1]);
        }
        if (otpControllers[i].text.isEmpty && i > 0) {
          FocusScope.of(context).requestFocus(focusNodes[i - 1]);
        }
      });
    }
  }

  void _startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && countdown > 0) {
        setState(() {
          countdown--;
        });
        _startCountdown();
      }
    });
  }

  String getOtpText() {
    return otpControllers.map((controller) => controller.text).join();
  }

  verifyOtp() async {
    String otp = getOtpText();
    
    if (otp == '123456') {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(Duration(seconds: 1));
      
      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        'Success',
        'Phone number verified successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      if (widget.onVerificationSuccess != null) {
        widget.onVerificationSuccess!();
      }
      return;
    }
    
    if (otp.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter complete OTP code',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'Error',
      'Invalid OTP code',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  resendOtp() async {
    setState(() {
      isResending = true;
      countdown = 60;
    });

    await Future.delayed(Duration(seconds: 2));

    _startCountdown();
    setState(() {
      isResending = false;
    });

    Get.snackbar(
      'OTP Sent',
      'New verification code has been sent',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 40),
                _buildIllustration(),
                SizedBox(height: 40),
                _buildOtpInput(),
                SizedBox(height: 30),
                _buildResendSection(),
                SizedBox(height: 40),
                _buildVerifyButton(),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (widget.onBackToLogin != null) {
                  widget.onBackToLogin!();
                } else {
                  Get.back();
                }
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey[700]),
            ),
            Spacer(),
            Text(
              "Step 2 of 2",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Enter Verification Code",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ),
        SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "We've sent a 6-digit code to your phone number",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F5E8), Color(0xFFC8E6C9)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20, top: 20,
            child: Icon(Icons.security_rounded, size: 70, color: Color(0xFF388E3C)),
          ),
          Positioned(
            left: 20, bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.sms_rounded, size: 40, color: Color(0xFF388E3C)),
                SizedBox(height: 8),
                Text("Secure OTP", style: TextStyle(color: Color(0xFF388E3C), fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
          ),
          Positioned(
            top: 30, left: 30,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Text("6 DIGITS", style: TextStyle(color: Color(0xFF388E3C), fontWeight: FontWeight.w700, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("VERIFICATION CODE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 1.0)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return Container(
              width: 50, height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: focusNodes[index].hasFocus ? Color(0xFF1976D2) : Colors.grey[300]!,
                  width: focusNodes[index].hasFocus ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: otpControllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87),
                decoration: InputDecoration(counterText: "", border: InputBorder.none, contentPadding: EdgeInsets.zero),
                onChanged: (value) { setState(() {}); },
              ),
            );
          }),
        ),
        SizedBox(height: 16),
        Center(child: Text("Enter the 6-digit code sent to your device", style: TextStyle(fontSize: 14, color: Colors.grey[600]))),
      ],
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        if (countdown > 0)
          Text("Resend code in $countdown seconds", style: TextStyle(fontSize: 14, color: Colors.grey[600]))
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Didn't receive the code? ", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              GestureDetector(
                onTap: countdown == 0 && !isResending ? resendOtp : null,
                child: Text("Resend OTP", style: TextStyle(fontSize: 14, color: countdown == 0 && !isResending ? Color(0xFF1976D2) : Colors.grey[400], fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        if (isResending)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)))),
          ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    bool isOtpComplete = getOtpText().length == 6;

    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity, height: 56,
          decoration: BoxDecoration(
            gradient: isOtpComplete && !isLoading
                ? LinearGradient(colors: [Color(0xFF388E3C), Color(0xFF4CAF50)])
                : LinearGradient(colors: [Colors.grey[300]!, Colors.grey[400]!]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isOtpComplete && !isLoading ? [BoxShadow(color: Color(0xFF388E3C).withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))] : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isOtpComplete && !isLoading ? verifyOtp : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: isLoading ? 0 : 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Verify OTP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isOtpComplete && !isLoading ? Colors.white : Colors.grey[600])),
                        SizedBox(width: 8),
                        Icon(Icons.verified_rounded, color: isOtpComplete && !isLoading ? Colors.white : Colors.grey[600], size: 20),
                      ],
                    ),
                  ),
                  if (isLoading)
                    SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        TextButton(
          onPressed: () {
            if (widget.onBackToLogin != null) {
              widget.onBackToLogin!();
            } else {
              Get.back();
            }
          },
          child: Text("Change Phone Number", style: TextStyle(color: Color(0xFF1976D2), fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded, size: 16, color: Colors.grey[500]),
              SizedBox(width: 8),
              Text("Your information is secure and encrypted", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          SizedBox(height: 20),
          Text("Having trouble receiving the code?", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          SizedBox(height: 4),
          GestureDetector(
            onTap: () { _showHelpDialog(); },
            child: Text("Get Help", style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Need Help?"),
        content: Text("If you're having trouble receiving the verification code, please check your network connection or try again in a few moments."),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("OK")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in otpControllers) { controller.dispose(); }
    for (var focusNode in focusNodes) { focusNode.dispose(); }
    super.dispose();
  }
}