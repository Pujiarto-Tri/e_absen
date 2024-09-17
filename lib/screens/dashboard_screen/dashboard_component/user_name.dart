import 'package:flutter/material.dart';

class UserNameDashboard extends StatelessWidget {
  final String username;

  const UserNameDashboard({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Selamat Datang,",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                // Navigate to the profile screen
                Navigator.pushNamed(context, '/profile', arguments: username);
              },
              icon: const CircleAvatar(
                backgroundImage: AssetImage(
                    'lib/assets/images/profile.png'), // Replace with your image path
                radius: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
