import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _payoutController = TextEditingController();

  // Variables
  bool _isLoading = false;
  String? _selectedRole;
  String? _selectedShift;
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    // _emailController.dispose();
    _payoutController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var uri = Uri.parse(
          'https://eabsendjangobackend-production.up.railway.app/api/employee/profile/');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);
        setState(() {
          _nameController.text = userData['employee_name'] ?? '';
          // _emailController.text = userData['user_id']['email'] ?? '';
          _payoutController.text = userData['user_payout'] ?? '';
          _selectedRole = userData['user_role']?['role_id']?.toString();
          _selectedShift = userData['user_shift']?['id']?.toString();
          _selectedLocation = userData['user_location']?['id']?.toString();
        });
      } else {
        _showSnackBar('Failed to load user data', context);
      }
    } catch (e) {
      _showSnackBar('Error: $e', context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var uri = Uri.parse(
          'https://eabsendjangobackend-production.up.railway.app/api/employee/profile/');
      var response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'employee_name': _nameController.text,
          'user_payout': _payoutController.text,
          'user_role': _selectedRole,
          'user_shift': _selectedShift,
          'user_location': _selectedLocation,
        }),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          _showSnackBar('Profile updated successfully', context);
        } else {
          _showSnackBar('Update failed: ${response.body}', context);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error: $e', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        // const SizedBox(height: 16),
                        // TextFormField(
                        //   controller: _emailController,
                        //   decoration: InputDecoration(
                        //     labelText: 'Email',
                        //     prefixIcon: const Icon(Icons.email_outlined),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //   ),
                        //   keyboardType: TextInputType.emailAddress,
                        //   readOnly: true, // Email should not be editable
                        // ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _payoutController,
                          decoration: InputDecoration(
                            labelText: 'Payout',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter payout amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Add dropdowns for Role, Shift, and Location here
                        // You'll need to fetch the options from your API
                        // and populate these dropdowns
                        // Example:
                        // DropdownButtonFormField(
                        //   value: _selectedRole,
                        //   items: [DropdownMenuItem(child: Text('Role 1'), value: '1')],
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _selectedRole = value as String?;
                        //     });
                        //   },
                        //   decoration: InputDecoration(
                        //     labelText: 'Role',
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _updateProfile(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Update Profile',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
