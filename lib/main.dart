import 'package:flutter/material.dart';
import 'package:hostel_management_system/login_page.dart';
import 'package:hostel_management_system/studentdashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hostel_management_system/admindashboard.dart';
import 'package:hostel_management_system/guarddashboard.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://maxopfltnhewikimnnsb.supabase.co", // Replace with your Supabase project URL
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1heG9wZmx0bmhld2lraW1ubnNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE5NTY1NzAsImV4cCI6MjA1NzUzMjU3MH0.srJyWWoXAs2G4RGCC_z1yM0nzR_ehQaQzk_qFEU53lk", // Replace with your Supabase anon key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hostel Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      final userId = session.user.id;

      // Fetch role from Supabase
      final userData = await supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();

      final role = userData['role'];

      // Navigate based on role
      if (role == 'student') {
        navigateTo(StudentDashboard());
      } else if (role == 'admin' || role == 'staff') {
        navigateTo(AdminDashboard());
      } else if (role == 'guard') {
        navigateTo(GuardDashboard());
      } else {
        // If role is not defined, log out and go back to login screen
        supabase.auth.signOut();
        navigateTo(LoginScreen());
      }
    } else {
      navigateTo(LoginScreen());
    }
  }

  void navigateTo(Widget screen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => screen));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Loading screen while checking authentication
    );
  }
}