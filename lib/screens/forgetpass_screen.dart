import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:doc_saver_app/provider/auth_provider.dart';
import 'package:doc_saver_app/widgets/custom_button.dart';
import 'package:doc_saver_app/widgets/custom_textfield.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPassScreen extends StatefulWidget {
  static String routeName = '/forgetpassscreen';
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  TextEditingController emailController = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: ListView(
          children: [
            SizedBoxHelper.sizedBox100,
            Image.asset(
              'assets/icon_image.png',
              height: 150,
            ),
            const Text(
              'Enter your e-mail to reset the password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBoxHelper.sizedBox20,
            Form(
              key: _key,
              child: CustomTextField(
                controller: emailController,
                hintText: 'Enter your E-mail',
                labelText: 'E-mail',
                prefixIcon: Icons.email,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value!';
                  }
                  return null;
                },
              ),
            ),
            SizedBoxHelper.sizedBox20,
            Consumer<AuthProvider>(
              builder: (context, provider, child) {
                return provider.isLoadingForgetPassword
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            provider.forgetPassword(
                                emailController.text, context);
                          }
                        },
                        title: 'Forget Password',
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
