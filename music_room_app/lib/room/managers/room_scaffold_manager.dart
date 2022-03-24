import 'package:flutter/material.dart';

class RoomScaffoldManager with ChangeNotifier {
  RoomScaffoldManager(String title) {
    this.title = title;
  }

  late String _title;
  Future<void> Function(BuildContext)? _topRightFn;
  String? _funcText;

  String get title => _title;

  set title(String title) {
    _title = title;
    notifyListeners();
  }

  String? get funcText => _funcText;

  set funcText(String? funcText) {
    _funcText = funcText;
    notifyListeners();
  }

  Future<void> Function(BuildContext)? get topRightFn => _topRightFn;

  set topRightFn(Future<void> Function(BuildContext context)? topRightFn) {
    _topRightFn = topRightFn;
    notifyListeners();
  }

  void setScaffold(
      {required String title,
      String? funcText,
      Future<void> Function(BuildContext)? topRightFn}) {
    _title = title;
    _funcText = funcText;
    _topRightFn = topRightFn;
    notifyListeners();
  }

  void resetScaffold() {
    _title = 'Room';
    _funcText = null;
    _topRightFn = null;
    notifyListeners();
  }
}
