import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  final String? phoneNumber;
  final VoidCallback? onLogout;
  
  const Homepage({super.key, this.phoneNumber, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: onLogout,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text("مرحباً بك!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("${phoneNumber ?? 'رقم غير معروف'}", style: TextStyle(fontSize: 20, color: Colors.grey)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'أهلاً وسهلاً',
                  'تم تسجيل الدخول بنجاح!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: Text('ابدء الاستخدام'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onLogout,
        child: Icon(Icons.logout),
        backgroundColor: Colors.green,
      ),  
    );
  }
}