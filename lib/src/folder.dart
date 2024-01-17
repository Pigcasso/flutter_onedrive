class Folder {
  final int childCount;

  Folder({required this.childCount});

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      childCount: json['childCount'],
    );
  }
}
