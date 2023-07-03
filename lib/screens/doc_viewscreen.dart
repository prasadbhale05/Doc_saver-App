import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:http/http.dart';

class DocViewScreen extends StatelessWidget {
  static String routeName = '/docViewScreen';
  const DocViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as DocViewScreenArgs;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.fileName),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return args.fileType == 'pdf'
                ? PdfView(path: snapshot.data!)
                : Image.file(File(snapshot.data!));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        future: getDocumentData(args),
      ),
    );
  }
}

Future<String> getDocumentData(DocViewScreenArgs docViewScreenArgs) async {
  // To store downloaded file in a particular path in our device!

  final dirPath = await getApplicationSupportDirectory();
  File file = File("${dirPath.path}/${docViewScreenArgs.fileName}");

  if (await file.exists()) {
    return file.path;
  } else {
    // Downloading the file from firebase!
    final response = await get(Uri.parse(docViewScreenArgs.fileUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }
}

class DocViewScreenArgs {
  final String fileUrl, fileName, fileType;
  DocViewScreenArgs({
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
  });
}
