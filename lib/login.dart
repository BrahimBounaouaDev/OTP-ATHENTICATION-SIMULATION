import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';

class PhoneHome extends StatefulWidget {
  final Function(String, String)? onCodeSent;
  
  const PhoneHome({Key? key, this.onCodeSent}) : super(key: key);

  @override
  State<PhoneHome> createState() => _PhoneHomeState();
}

class _PhoneHomeState extends State<PhoneHome> {
  TextEditingController phonenumber = TextEditingController();
  String countryCode = '+213';
  bool isLoading = false;

  void sendcode() async {
    print('🎯 تم الضغط على الزر!');
    
    String fullPhoneNumber = countryCode + phonenumber.text;
    print('📱 الرقم المدخل: $fullPhoneNumber');
    
    // الشرط الوحيد - فقط الرقم +213674738032 مسموح
    if (fullPhoneNumber != '+213674738032') {
      Get.snackbar(
        'رقم غير مسموح ❌',
        'يُسمح فقط بالرقم: +213674738032\nالرقم المدخل: $fullPhoneNumber',
        backgroundColor: Colors.orange[800],
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(20),
        borderRadius: 12,
      );
      return;
    }
    
    if (phonenumber.text.isEmpty || phonenumber.text.length < 8) {
      Get.snackbar(
        'خطأ في الرقم',
        'الرجاء إدخال رقم هاتف صحيح',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    Get.snackbar(
      'تم الإرسال بنجاح ✅',
      'تم إرسال رمز التحقق إلى: $fullPhoneNumber\nاستخدم الرمز: 123456',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );

    // استخدام callback للانتقال إلى OTP
    if (widget.onCodeSent != null) {
      widget.onCodeSent!(fullPhoneNumber, "manual_verification_id");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && phonenumber.text.isEmpty) {
        setState(() {
          phonenumber.text = "674738032";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAllowedNumber = (countryCode + phonenumber.text) == '+213674738032';
    
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
                _buildPhoneInput(),
                SizedBox(height: 30),
                _buildButton(isAllowedNumber),
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
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey[700]),
            ),
            Spacer(),
            Text(
              "Step 1 of 2",
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
            "Enter Your Phone Number",
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
            "We'll send you a one-time password to verify your mobile number",
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
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20, top: 20,
            child: Icon(Icons.phone_iphone_rounded, size: 80, color: Color(0xFF1976D2)),
          ),
          Positioned(
            left: 20, bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_user_rounded, size: 40, color: Color(0xFF1976D2)),
                SizedBox(height: 8),
                Text("Secure Verification", style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PHONE NUMBER", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600], letterSpacing: 1.0)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              // Country Code Picker - مفتوح للتغيير
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: CountryCodePicker(
                  onChanged: (country) {
                    setState(() {
                      countryCode = country.dialCode!;
                    });
                    print('🌍 تم تغيير الدولة إلى: ${country.name} - ${country.dialCode}');
                  },
                  initialSelection: 'DZ',
                  favorite: ['+213','DZ', '+1', 'US', '+44', 'UK', '+33', 'FR'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  showDropDownButton: true,
                  hideMainText: false,
                  showFlagMain: true,
                  showFlag: true,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(width: 1, height: 30, color: Colors.grey[300]),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: phonenumber,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: "أدخل أي رقم هاتف",
                    hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (value) {
                    setState(() {});
                    print('📱 رقم الهاتف: $value');
                  },
                ),
              ),
              
              // زر المسح
              if (phonenumber.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        phonenumber.clear();
                      });
                    },
                    child: Icon(
                      Icons.clear_rounded,
                      size: 20,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Standard carrier rates may apply",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        
        // معلومات التصحيح
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "معلومات الرقم:",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
              ),
              Text(
                "الرقم الكامل: $countryCode${phonenumber.text}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                "الحالة: ${(countryCode + phonenumber.text) == '+213674738032' ? '✅ مسموح' : '❌ غير مسموح'}",
                style: TextStyle(
                  fontSize: 12, 
                  color: (countryCode + phonenumber.text) == '+213674738032' ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(bool isAllowed) {
    bool isEnabled = phonenumber.text.length >= 8 && !isLoading;
    
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? sendcode : null,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: isEnabled
                    ? LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF42A5F5)])
                    : LinearGradient(colors: [Colors.grey[300]!, Colors.grey[400]!]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isEnabled ? [
                  BoxShadow(
                    color: Color(0xFF1976D2).withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ] : [],
              ),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "استلام الرمز",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isEnabled ? Colors.white : Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: isEnabled ? Colors.white : Colors.grey[600],
                            size: 20,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),

        // زر التعبئة التلقائية للرقم المسموح
        SizedBox(height: 20),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                countryCode = '+213';
                phonenumber.text = "674738032";
              });
              Get.snackbar(
                'تم التعبئة ✅',
                'تم تعبئة الرقم المسموح: +213674738032',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            },
            child: Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_fix_high, size: 16, color: Colors.green),
                    SizedBox(width: 8),
                    Text("تعبئة الرقم المسموح", style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Text("By continuing, you agree to our", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text("Terms of Service", style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              Text(" and ", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              GestureDetector(
                onTap: () {},
                child: Text("Privacy Policy", style: TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}