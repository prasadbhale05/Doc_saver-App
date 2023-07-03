import 'package:doc_saver_app/helper/sizedbox_helper.dart';
import 'package:doc_saver_app/provider/auth_provider.dart';
import 'package:doc_saver_app/provider/userInfo_provider.dart';
import 'package:doc_saver_app/widgets/custom_button.dart';
import 'package:doc_saver_app/widgets/custom_textfield.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:doc_saver_app/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static String routeName = '/settingscreen';
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserInfoProvider>(context, listen: false);
    provider.getUserName();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ScreenBackground(
        child: Column(
          children: [
            Consumer<UserInfoProvider>(builder: (context, provider, child) {
              return SettingsCard(
                title: provider.userName,
                leadingIcon: Icons.person,
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    TextEditingController controller = TextEditingController();
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: controller,
                                        hintText: "Enter new username!",
                                        prefixIcon: Icons.person,
                                        validator: (value) {
                                          return null;
                                        },
                                        labelText: "Username",
                                      ),
                                      SizedBoxHelper.sizedBox20,
                                      CustomButton(
                                        onPressed: () {
                                          provider.updateUsername(
                                              controller.text, context);
                                        },
                                        title: "Update username",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                ),
              );
            }),
            SettingsCard(
              title: provider.user!.email!,
              leadingIcon: Icons.email,
            ),
            SettingsCard(
              title: "Logout",
              trailing: IconButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false)
                      .logout(context);
                },
                icon: Icon(
                  Icons.logout,
                ),
              ),
              leadingIcon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
