import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String customerFName = '';
  String customerLName = '';
  String customerPhone = '';
    String   CUSTOMEREMAIL = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      customerPhone = prefs.getString("CUSTOMERPHONE") ?? ''; 
      customerFName = prefs.getString("CUSTOMERFNAME") ?? '';   
      customerLName = prefs.getString("CUSTOMERLNAME") ?? ''; 
       CUSTOMEREMAIL = prefs.getString("CUSTOMEREMAIL") ?? ''; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "First Name: $customerFName",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Last Name: $customerLName",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Phone: $customerPhone",
              style: TextStyle(fontSize: 18),
            ),

              SizedBox(height: 10),
            Text(
              "Email: $CUSTOMEREMAIL",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
