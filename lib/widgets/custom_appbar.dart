import 'package:doc_saver_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';

import '../helper/sizedbox_helper.dart';
import 'custom_textfield.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  const CustomAppBar(
      {super.key, required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Container(
        color: const Color(0xFF1e5376),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/icon_text.png",
                      width: 150,
                    ),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context)
                            .pushNamed(SettingScreen.routeName);
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBoxHelper.sizedBox20,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: CustomTextField(
                    controller: controller,
                    hintText: "Enter the title of document",
                    prefixIcon: Icons.search,
                    validator: (value) {
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: onSearch,
                      icon: const Text("Go"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
