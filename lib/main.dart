import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'firebase_options.dart';
import 'package:easyqueue_app/providers/auth_provider.dart' as my_auth;
import 'package:easyqueue_app/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => my_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyQueue',
      debugShowCheckedModeBanner: false,
      routes: {
        '/welcome': (_) => const WelcomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/admin': (_) => const AdminDashboardScreen(),
      },
      home: const AppEntryDecider(),
    );
  }
}

class AppEntryDecider extends StatelessWidget {
  const AppEntryDecider({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const WelcomeScreen();
    } else {
      // Load user role
      return const RoleRedirector();
    }
  }
}

class RoleRedirector extends StatefulWidget {
  const RoleRedirector({super.key});
  @override
  State<RoleRedirector> createState() => _RoleRedirectorState();
}

class _RoleRedirectorState extends State<RoleRedirector> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserRole().then((_) {
      final role = userProvider.role;
      Navigator.pushReplacementNamed(
          context, role == 'admin' ? '/admin' : '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
