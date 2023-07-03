class FileCardModel {
  String title, subTitle, date, fileType, fileUrl, fileName, id;

  FileCardModel({
    required this.title,
    required this.subTitle,
    required this.date,
    required this.fileType,
    required this.fileUrl,
    required this.fileName,
    required this.id,
  });

  factory FileCardModel.fromJson(Map<dynamic, dynamic> json, String id) {
    return FileCardModel(
      id: id,
      title: json["title"].toString(),
      subTitle: json["note"].toString(),
      date: json["date"].toString(),
      fileType: json["fileType"].toString(),
      fileUrl: json["fileUrl"].toString(),
      fileName: json["fileName"].toString(),
    );
  }
}
