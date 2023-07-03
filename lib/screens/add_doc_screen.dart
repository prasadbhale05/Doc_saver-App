import 'package:doc_saver_app/provider/document_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/sizedbox_helper.dart';
import '../widgets/custom_floatingaction_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/screen_background.dart';

class AddDocumentScreen extends StatefulWidget {
  static String routeName = "/addDocumentScreen";
  const AddDocumentScreen({Key? key}) : super(key: key);

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DocumentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Document"),
        centerTitle: true,
      ),
      floatingActionButton:
          Consumer<DocumentProvider>(builder: (context, provider, child) {
        return provider.isFileUploading
            ? const CircularProgressIndicator()
            : CustomFloatingActionButton(
                iconData: Icons.check,
                title: "Upload",
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _provider.sendDocumentData(
                    context: context,
                  );
                },
              );
      }),
      body: ScreenBackground(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Consumer<DocumentProvider>(builder: (context, provider, child) {
                return CustomTextField(
                  controller: provider.titleController,
                  hintText: "Title",
                  prefixIcon: Icons.title,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                  labelText: "Please enter the title",
                );
              }),
              SizedBoxHelper.sizedBox20,
              Consumer<DocumentProvider>(builder: (context, provider, child) {
                return CustomTextField(
                  controller: provider.noteController,
                  hintText: "Note",
                  prefixIcon: Icons.note,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter note';
                    }
                    return null;
                  },
                  labelText: "Please enter the Note",
                );
              }),
              SizedBoxHelper.sizedBox20,
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _provider.pickDocument(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  ),
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<DocumentProvider>(
                          builder: (context, provider, child) {
                        return Text(provider.selectedFileName);
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.grey,
                          ),
                          Text(
                            "Upload file",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
