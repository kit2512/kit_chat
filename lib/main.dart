import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kit_chat/firebase_options.dart';
import 'package:kit_chat/providers/auth_provider.dart';
import 'package:kit_chat/screens/screens.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const _BuildFirstPage(),
      ),
    );
  }
}

class _BuildFirstPage extends StatelessWidget {
  const _BuildFirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.state == AuthState.authenticated) {
          return child!;
        } else {
          return const SignInScreen();
        }
      },
      child: const HomeScreen(),
    );
  }
}
