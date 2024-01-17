import 'file.dart';
import 'folder.dart';

class OneDriveItem {
  final String name;
  final int size;
  final File? file;
  final Folder? folder;

  const OneDriveItem({
    required this.name,
    required this.size,
    required this.file,
    required this.folder,
  });

  factory OneDriveItem.fromJson(Map<String, dynamic> json) {
    return OneDriveItem(
      name: json['name'],
      size: json['size'],
      file: json.containsKey('file') ? File.fromJson(json['file']) : null,
      folder:
          json.containsKey('folder') ? Folder.fromJson(json['folder']) : null,
    );
  }
}
