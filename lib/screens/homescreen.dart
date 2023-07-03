import 'dart:async';

import 'package:doc_saver_app/models/filecard_model.dart';
import 'package:doc_saver_app/screens/add_doc_screen.dart';
import 'package:doc_saver_app/widgets/custom_appbar.dart';
import 'package:doc_saver_app/widgets/custom_floatingaction_button.dart';
import 'package:doc_saver_app/widgets/file_card.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/homescreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  StreamController<DatabaseEvent> streamController = StreamController();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  setStream() {
    FirebaseDatabase.instance
        .ref()
        .child('files_info/$userId')
        .orderByChild("title")
        .startAt(searchController.text)
        .endAt("${searchController.text}" "\uf8ff")
        .onValue
        .listen((event) {
      streamController.add(event);
    });
  }

  @override
  void initState() {
    setStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: CustomFloatingActionButton(
            title: "Add file",
            iconData: Icons.add,
            onTap: () {
              Navigator.of(context).pushNamed(AddDocumentScreen.routeName);
            }),
        appBar: CustomAppBar(
          controller: searchController,
          onSearch: () {
            setStream();
          },
        ),
        body: ScreenBackground(
          child: StreamBuilder<DatabaseEvent>(
              stream: streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  List<FileCardModel> list = [];
                  (snapshot.data!.snapshot.value as Map<dynamic, dynamic>)
                      .forEach((key, value) {
                    list.add(FileCardModel.fromJson(value, key));
                  });
                  return ListView(
                    children: list
                        .map(
                          (e) => FileCard(
                            model: FileCardModel(
                              id: e.id,
                              title: e.title,
                              subTitle: e.subTitle,
                              date: e.date,
                              fileType: e.fileType,
                              fileUrl: e.fileUrl,
                              fileName: e.fileName,
                            ),
                          ),
                        )
                        .toList(),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icon_no_file.png",
                        height: 100,
                      ),
                      const Text('No data'),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
