import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hostel_management_system/studentdashboard.dart';
import 'package:hostel_management_system/admindashboard.dart';
import 'package:hostel_management_system/guarddashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;

  Future<void> signInWithGoogle() async {
    try {
      final response = await supabase.auth.signInWithOAuth(OAuthProvider.google);

      if (supabase.auth.currentSession != null) { // ✅ Fix applied
        final userId = supabase.auth.currentSession!.user.id;

        final userData = await supabase
            .from('users')
            .select('role')
            .eq('id', userId)
            .single();

        final role = userData['role'];

        if (role == 'student') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentDashboard()));
        } else if (role == 'admin' || role == 'staff') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        } else if (role == 'guard') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GuardDashboard()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unauthorized Role')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 100),
            SizedBox(height: 20),
            Text(
              "Hostel Management System",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Icon(Icons.login),
              label: Text("Sign in with Google"),
              onPressed: signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
