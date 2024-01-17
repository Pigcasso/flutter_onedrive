import 'onedrive_item.dart';

class OneDriveItemCollectionResponse {
  final List<OneDriveItem> value;

  OneDriveItemCollectionResponse({
    required this.value,
  });

  factory OneDriveItemCollectionResponse.fromJson(Map<String, dynamic> json) {
    final value = (json['value'] as List<dynamic>)
        .map((e) => OneDriveItem.fromJson(e))
        .toList();
    return OneDriveItemCollectionResponse(
      value: value,
    );
  }
}
