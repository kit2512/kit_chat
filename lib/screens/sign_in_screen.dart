import 'package:flutter/material.dart';
import 'package:kit_chat/providers/providers.dart';
import 'package:kit_chat/resources/auth_methods.dart';
import 'package:kit_chat/screens/screens.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Log in",
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                      onChanged: loginProvider.setEmail,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                      obscureText: true,
                      onChanged: loginProvider.setPassword,
                    ),
                    loginProvider.isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : ElevatedButton(
                            onPressed: () async {
                              try {
                                await loginProvider.login();
                              } on LoginError catch (e) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(e.message),
                                    ),
                                  );
                              }
                            },
                            child: const Text("Log in"),
                          ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return const SignUpScreen();
                        }));
                      },
                      child: const Text("Sign up"),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
