import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final IconData leadingIcon;
  const SettingsCard({
    super.key,
    required this.title,
    this.trailing,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              spreadRadius: 4,
            ),
          ]),
      child: ListTile(
        title: Text(title),
        leading: Icon(leadingIcon),
        trailing: trailing,
      ),
    );
  }
}
