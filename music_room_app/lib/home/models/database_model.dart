enum Action{save, delete}

abstract class DatabaseModel {
  Map<String, dynamic> toMap();
  String get docId;
  List<String> get wrappedCollectionsIds;
}