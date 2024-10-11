import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? accessToken = prefs.getString('accessToken');

  runApp(MyApp(isLoggedIn: isLoggedIn, accessToken: accessToken));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? accessToken;

  const MyApp({super.key, required this.isLoggedIn, this.accessToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn && accessToken != null
          ? DashboardScreen.routeName
          : LoginScreen.routeName,
      routes: {
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(
            accessToken:
                accessToken ?? ''), // Safe fallback if username is null
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        CheckIn.routeName: (context) => const CheckIn(),
        CheckOut.routeName: (context) => const CheckOut(),
        EditProfileScreen.routeName: (context) =>
            EditProfileScreen(accessToken: accessToken ?? '')
      },
    );
  }
}
