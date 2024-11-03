import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yurbancustomers/BaseURL.dart';
import 'package:yurbancustomers/LoginScreen.dart';
import 'package:yurbancustomers/MyRideScreen.dart';
import 'package:yurbancustomers/ProfileScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black, // Set the background color of the entire drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red, // Header color
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_car, // Car icon
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8), // Spacing between icon and text
                    Text(
                      'YUrban Ride',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                 onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_car, color: Colors.white),
                title: Text(
                  'My Rides',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyRideScreen()),
                  );
                },
              ),
               ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4, // Responsive height
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'Map Here', // Placeholder for the map
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SizedBox(height: 16), // Spacing
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestRideScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Button background color
              onPrimary: Colors.white, // Button text color
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Request Ride',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        SizedBox(height: 16), // Additional spacing
      ],
    );
  }
}

class RequestRideScreen extends StatefulWidget {
  @override
  _RequestRideScreenState createState() => _RequestRideScreenState();
}

class _RequestRideScreenState extends State<RequestRideScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  final TextEditingController passengersController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String CUSTOMERFNAME = '';
  String CUSTOMERLNAME = '';
  String CUSTOMERPHONE = '';
    String? Customerid  = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Customerid  = (prefs.getString("PID") ?? '') ;
      CUSTOMERPHONE = prefs.getString("CUSTOMERPHONE") ?? '';
      CUSTOMERFNAME = prefs.getString("CUSTOMERFNAME") ?? '';
      CUSTOMERLNAME = prefs.getString("CUSTOMERLNAME") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Ride'),
      ),
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4, // Responsive height
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Map Here', // Placeholder for the map
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(height: 16), // Spacing
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Full width
                children: [
                  TextFormField(
                    controller: pickupController,
                    decoration: InputDecoration(
                      labelText: 'Your Pick-up Point',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your pick-up point';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16), // Spacing
                  TextFormField(
                    controller: dropoffController,
                    decoration: InputDecoration(
                      labelText: 'Your Drop-off Point',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your drop-off point';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16), // Spacing
                  TextFormField(
                    controller: passengersController,
                    decoration: InputDecoration(
                      labelText: 'Number of Passengers',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of passengers';
                      }
                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'Please enter a valid number of passengers';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20), // Spacing
                  ElevatedButton(
                    onPressed: postRideRequest,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Button background color
                      onPrimary: Colors.white, // Button text color
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Confirm Ride'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> postRideRequest() async {
    String? pickuplocation = pickupController.text; 
    String? dropofflocation = dropoffController.text; 
    String? numberofpassagers = passengersController.text; 
    String? userphone = CUSTOMERPHONE;
    String? userfname = CUSTOMERFNAME;
    String? userlname = CUSTOMERLNAME;

   
    // Construct JSON object
    Map<String, dynamic> postData = {
       "Customerid": Customerid,
      "userphone": userphone,
      "userfname": userfname,
      "userlname": userlname,
      "pickuplocation": pickuplocation,
      "dropofflocation": dropofflocation,
      "numberofpassagers": numberofpassagers,
    };
    
    // Convert JSON to string
    String jsonString = json.encode(postData);
    print('JSON Data Log: $jsonString');

    // Send HTTP POST request
    final response = await http.post(
      Uri.parse(BaseURL.RideRequest),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    print(response.statusCode);
    print(response.body);

    // Handle response
    if (response.statusCode == 200) {
      // If successful,
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Request Submitted."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
           
    } else {
      // If failed, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to submit data."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
