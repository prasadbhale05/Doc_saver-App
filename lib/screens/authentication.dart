import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:doc_saver_app/provider/auth_provider.dart';
import 'package:doc_saver_app/screens/forgetpass_screen.dart';
import 'package:doc_saver_app/widgets/custom_button.dart';
import 'package:doc_saver_app/widgets/custom_textfield.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static String routeName = '/authscreen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: ScreenBackground(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _key,
                child: ListView(
                  children: [
                    Image.asset(
                      'assets/icon_image.png',
                      height: 150,
                    ),
                    SizedBoxHelper.sizedBox20,
                    if (!provider.isLogin)
                      CustomTextField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username!';
                          } else {
                            return null;
                          }
                        },
                        controller: usernameController,
                        hintText: "Enter your username",
                        labelText: "Username",
                        prefixIcon: Icons.person,
                      ),
                    SizedBoxHelper.sizedBox20,
                    CustomTextField(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid e-mail';
                        } else {
                          return null;
                        }
                      },
                      controller: emailController,
                      hintText: "Enter your email",
                      labelText: "Email",
                      prefixIcon: Icons.email,
                    ),
                    SizedBoxHelper.sizedBox20,
                    CustomTextField(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid password';
                        } else if (value.length < 8) {
                          return 'Please enter min.8 characters';
                        } else {
                          return null;
                        }
                      },
                      controller: passwordController,
                      obscureText: provider.obscureText,
                      hintText: "Enter your password",
                      labelText: "Password",
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        onPressed: () {
                          provider.setObscurePassword();
                        },
                        icon: Icon(
                          provider.obscureText
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    SizedBoxHelper.sizedBox20,
                    if (!provider.isLogin)
                      CustomTextField(
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid password';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match!';
                          } else {
                            return null;
                          }
                        },
                        controller: confirmpassController,
                        obscureText: provider.obscurePassword,
                        hintText: "Enter your password",
                        labelText: "Confirm Password",
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          onPressed: () {
                            provider.setObscureConfirmPassword();
                          },
                          icon: Icon(
                            provider.obscurePassword
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    SizedBoxHelper.sizedBox20,
                    provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                if (provider.isLogin) {
                                  provider.signIn(
                                    context,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                } else {
                                  provider.signUp(context,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      username: usernameController.text);
                                }
                              }
                            },
                            title: provider.isLogin ? 'Login' : 'Register',
                          ),
                    MaterialButton(
                      onPressed: () {
                        provider.setIsLogin();
                      },
                      child: Text(
                        provider.isLogin
                            ? "Don't have an account? Register"
                            : "Already have an account? Log in",
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ForgetPassScreen.routeName);
                      },
                      child: const Text("Forgot password?"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
