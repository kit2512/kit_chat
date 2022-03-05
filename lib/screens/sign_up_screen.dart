import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kit_chat/providers/providers.dart';
import 'package:kit_chat/resources/resources.dart';
import 'package:kit_chat/utils/utils.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpProvider>(
      create: (_) => SignUpProvider(),
      child: const BuildSignUpView(),
    );
  }
}

class BuildSignUpView extends StatelessWidget {
  const BuildSignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 32),
                SizedBox.square(
                  dimension: 80,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Consumer<SignUpProvider>(
                          builder: ((context, value, child) {
                        if (value.imageFile == null) {
                          return const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              "assets/images/user_dummy.png",
                            ),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage: MemoryImage(value.imageFile!),
                          );
                        }
                      })),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              Provider.of<SignUpProvider>(context,
                                      listen: false)
                                  .setFile(await getImage(ImageSource.gallery));
                            } on Exception catch (_) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text("Error picking image"),
                                  ),
                                );
                            }
                          },
                          child: const Icon(
                            Icons.add_a_photo,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  onChanged: Provider.of<SignUpProvider>(context).setName,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: Provider.of<SignUpProvider>(context).setEmail,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onChanged: Provider.of<SignUpProvider>(context).setPassword,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Provider.of<SignUpProvider>(context).isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : ElevatedButton(
                        child: const Text('Sign Up'),
                        onPressed: () async {
                          try {
                            await Provider.of<SignUpProvider>(context,
                                    listen: false)
                                .signUp();
                            Navigator.of(context).pop();
                          } on SignUpError catch (e) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(e.message),
                                ),
                              );
                          }
                        },
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Sign in"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
