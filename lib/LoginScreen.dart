import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yurbancustomers/BaseURL.dart';
import 'package:yurbancustomers/DashboardScreen.dart';
import 'package:yurbancustomers/Models/LoginModel.dart';
import 'package:yurbancustomers/RegisterScreen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

 Future<void> _login() async {
 
      String username = phoneController.text;
      String password = _passwordController.text;

               LoginModel patologin = LoginModel(
                Username: username,
                Password: password,
              
            );
       print(patologin.toJson());
      try {
      
        final response = await http.post(
         Uri.parse(BaseURL.LOGIN),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(patologin.toJson()),
        );
        print(response.statusCode);
        print(response.body);
       
        if (response.statusCode == 200) {
          // Successful login
          
            SharedPreferences prefs = await SharedPreferences.getInstance();
          final Map<String, dynamic> responseData = json.decode(response.body);
    
          prefs.setString("PID", responseData['pid'].toString());
          prefs.setString("CUSTOMERFNAME", responseData['fname'].toString());
          prefs.setString("CUSTOMERLNAME", responseData['lname'].toString());
          prefs.setString("CUSTOMEREMAIL", responseData['email'].toString());
          prefs.setString("CUSTOMERPHONE", responseData['userphone'].toString());
            prefs.setString("CUSTOMEROLE", responseData['role'].toString());
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  DashboardScreen()),
            );
    
        
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid username or password',
                style: TextStyle(color: Colors.red.shade300, fontSize: 18.0),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } 

     
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Yurban Customer',
                    style: TextStyle(
                      fontSize: 30, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent, // Changed color for emphasis
                    ),
                  ),
                  SizedBox(height: 40), // Increased spacing
                  _buildPhoneField(),
                  SizedBox(height: 20),
                  _buildPasswordField(),
                  SizedBox(height: 30),
                  _buildLoginButton(),
                  SizedBox(height: 20),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone, // Changed to phone type
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded borders
        ),
        prefixIcon: const Icon(Icons.phone, color: Colors.redAccent), // Icon color change
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Phone Number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.number, // Kept as number for PIN
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded borders
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.redAccent), // Icon color change
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.redAccent, // Icon color change
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length != 4) {
          return 'PIN must be 4 digits';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _login,
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 20, // Increased font size here
            fontWeight: FontWeight.bold, // Optional: make the text bold
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          primary: Colors.redAccent, // Updated button color
          onPrimary: Colors.white, // Button text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded button corners
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // Navigate to forgot password screen
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.redAccent), // Changed color for emphasis
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? "),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()), // Navigate to RegisterScreen
                );
              },
              child: Text(
                'Register',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Changed color for emphasis
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
