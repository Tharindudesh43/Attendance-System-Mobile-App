import 'package:attendance_system_flutter_application/Pages/DiscoverPage.dart';
import 'package:attendance_system_flutter_application/Pages/SelectAuthPage.dart'
    show Selectauthpage;
import 'package:attendance_system_flutter_application/Services/MongoDB_Services.dart'
    show MongodbServices;
import 'package:attendance_system_flutter_application/Services/NotificationServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  try {
    await Firebase.initializeApp();
    await MongodbServices.connect();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await NotificationServices.initLocalNotifications();
    await NotificationServices.initFirebaseMessaging();
  } catch (e) {
    debugPrint("❌ Error initializing Firebase or MongoDB: $e");
  }
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marky',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking the auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Container(
                height: 200,
                width: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 8),
              ),
            ),
          );
        }

        // If user is not signed in
        if (snapshot.data == null) {
          return const Selectauthpage();
        }

        // If user is signed in
        return Discoverpage(pagenumber: 0);
      },
    );
  }
}
