// lib/home_screen.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DisasterPredictorHomePage extends StatefulWidget {
  @override
  _DisasterPredictorHomePageState createState() =>
      _DisasterPredictorHomePageState();
}

class _DisasterPredictorHomePageState extends State<DisasterPredictorHomePage> {
  File? _image;
  String _prediction = '';
  double _probability = 0.0;
  bool _isLoading = false;

  final picker = ImagePicker();

  // Update this URL to point to the new API endpoint
  final String apiUrl = 'https://safezy-flask.onrender.com/api/predict';

  // For Bottom Navigation
  int _currentIndex = 0;

  // Sample locations for the map
  final List<LatLng> _markers = [
    // Example random points; you can update or remove as needed
    LatLng(19.0760, 72.8777), // Mumbai
    LatLng(28.7041, 77.1025), // Delhi
    LatLng(22.5726, 88.3639), // Kolkata
    LatLng(13.0827, 80.2707), // Chennai
  ];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = '';
        _probability = 0.0;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare the request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath('file', _image!.path),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        setState(() {
          _prediction = jsonResponse['prediction'];
          _probability = jsonResponse['probability'] * 100; // Convert to %
          _isLoading = false;
        });
      } else {
        // Attempt to parse the error message from the response
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        setState(() {
          _isLoading = false;
          _prediction =
              'Error: ${jsonResponse['error'] ?? response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _prediction = 'Error: $e';
      });
    }
  }

  /// HOME TAB
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          /// 1) Prediction Section at the top
          Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _image == null
                      ? const Text(
                          'No image selected.',
                          style: TextStyle(fontSize: 16),
                        )
                      : Image.file(
                          _image!,
                          height: 200,
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt, size: 20),
                        label: const Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 195, 224, 248),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo, size: 20),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 194, 251, 196),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _uploadImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 200, 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Predict Disaster'),
                        ),
                  const SizedBox(height: 20),
                  if (_prediction.isNotEmpty) ...[
                    Text(
                      'Prediction: $_prediction',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Probability: ${_probability.toStringAsFixed(2)}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// 2) Feature Cards (with subtle colors & smaller icons)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
            children: [
              _buildFeatureCard(
                Icons.image,
                'Upload Image',
                Colors.blue.shade100,
              ),
              _buildFeatureCard(
                Icons.map,
                'View Map',
                Colors.green.shade100,
              ),
              _buildFeatureCard(
                Icons.info,
                'About',
                Colors.orange.shade100,
              ),
              _buildFeatureCard(
                Icons.settings,
                'Settings',
                Colors.purple.shade100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// MAP TAB (center of India)
  Widget _buildMapTab() {
    return FlutterMap(
      options: MapOptions(
        /// Center map on India approximately
        initialCenter: LatLng(20.5937, 78.9629),
        initialZoom: 5.0,
      ),
      children: [
        /// Tile Layer
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.safezyapp',
        ),

        /// Marker Layer
        MarkerLayer(
          markers: _markers
              .map(
                (point) => Marker(
                  width: 30.0,
                  height: 30.0,
                  point: point,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  /// ABOUT TAB
  Widget _buildAboutTab() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Safezy App helps in predicting disasters by analyzing images. '
        'Utilize the app to stay informed and take necessary precautions. '
        'Our mission is to safeguard communities by leveraging advanced '
        'machine learning technologies.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  /// SETTINGS TAB
  Widget _buildSettingsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Dark Mode'),
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: 'English',
              items:
                  <String>['English', 'Spanish', 'French'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  /// FEATURE CARDS - More subtle
  Widget _buildFeatureCard(IconData icon, String label, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          // Define actions for each feature
          switch (label) {
            case 'Upload Image':
              _pickImage(ImageSource.gallery);
              break;
            case 'View Map':
              setState(() {
                _currentIndex = 1; // Navigate to Map Tab
              });
              break;
            case 'About':
              setState(() {
                _currentIndex = 2; // Navigate to About Tab
              });
              break;
            case 'Settings':
              setState(() {
                _currentIndex = 3; // Navigate to Settings Tab
              });
              break;
            default:
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// BOTTOM NAVIGATION
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  /// MAIN BUILD
  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentIndex) {
      case 0:
        body = _buildHomeTab();
        break;
      case 1:
        body = _buildMapTab();
        break;
      case 2:
        body = _buildAboutTab();
        break;
      case 3:
        body = _buildSettingsTab();
        break;
      default:
        body = _buildHomeTab();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safezy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Action for notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Action for user profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile is under construction')),
              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Color.fromARGB(199, 216, 255, 155),
      ),
      body: body,
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Action for FAB - capture from camera
                _pickImage(ImageSource.camera);
              },
              backgroundColor: Color.fromARGB(255, 211, 195, 255),
              child: const Icon(Icons.camera_alt),
            )
          : null,
    );
  }
}
