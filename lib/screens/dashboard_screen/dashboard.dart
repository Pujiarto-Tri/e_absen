import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_component.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  final String accessToken;

  const DashboardScreen({super.key, required this.accessToken});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  double _opacity = 0;
  String? employeeData;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = widget.accessToken;

    // Store the token for future use
    await prefs.setString('access_token', accessToken);

    // API call to fetch employee data (PUT request)
    final response = await http.get(
      Uri.parse(
          'https://eabsendjangobackend-production.up.railway.app/api/employee/profile/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        employeeData = data['employee_name'] ?? data['user_id']['email'];
      });
    } else {
      // Handle errors
      setState(() {
        employeeData = 'Error fetching employee data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Blue box as a background
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            color: const Color.fromARGB(255, 131, 153, 189),
          ),
          // The list content that overlays the blue box
          SafeArea(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: CustomScrollView(
                slivers: [
                  NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      setState(() {
                        _opacity = max(
                          0,
                          min(
                            1,
                            (_opacity + notification.scrollDelta!) /
                                (MediaQuery.of(context).size.height * 0.2),
                          ),
                        );
                      });
                      return true;
                    },
                    child: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(
                          height: 3,
                        ),
                        // Display employee name or email
                        UserNameDashboard(
                          username: employeeData ?? 'Loading...',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const AbsenWidget(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
