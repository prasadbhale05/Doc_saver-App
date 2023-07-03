import 'package:doc_saver_app/models/filecard_model.dart';
import 'package:doc_saver_app/provider/document_provider.dart';
import 'package:doc_saver_app/screens/doc_viewscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/sizedbox_helper.dart';

class FileCard extends StatelessWidget {
  final FileCardModel model;
  const FileCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 4),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                model.fileType == "pdf"
                    ? Image.asset(
                        "assets/icon_pdf_type.png",
                        width: 50,
                      )
                    : Image.asset(
                        "assets/icon_image_type.png",
                        width: 50,
                      ),
                SizedBoxHelper.sizedBox_5,
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        model.subTitle,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Date: ${model.date.substring(0, 10)}",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              model.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              TextButton(
                                onPressed: () {
                                  Provider.of<DocumentProvider>(context,
                                          listen: false)
                                      .deleteDocument(
                                    model.id,
                                    model.fileName,
                                    context,
                                  )
                                      .then((value) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  'Ok',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                            backgroundColor: Colors.red,
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      DocViewScreen.routeName,
                      arguments: DocViewScreenArgs(
                        fileUrl: model.fileUrl,
                        fileName: model.fileName,
                        fileType: model.fileType,
                      ),
                    );
                  },
                  child: Text(
                    'View',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
