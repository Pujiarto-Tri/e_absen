import 'dart:math';
import 'package:flutter/material.dart';
import 'dashboard_component.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  final String username;

  const DashboardScreen({super.key, required this.username});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  double _opacity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Blue box as a background
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height *
                0.3, // Adjust height as needed
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
                        ), // Adjust the height to position content
                        UserNameDashboard(
                          username: widget.username,
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
