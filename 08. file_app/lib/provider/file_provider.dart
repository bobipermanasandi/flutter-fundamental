import 'package:file_app/service/file_service.dart';
import 'package:flutter/widgets.dart';

class FileProvider extends ChangeNotifier {
  final FileService _service;

  FileProvider(this._service);

  String? _contents;

  String? get contents => _contents;

  String _message = "";

  String get message => _message;

  List<String> _filesName = [];

  List<String> get filesName => _filesName;

  Future<void> saveFile(String filename, String contents) async {
    try {
      await _service.writeFile(filename, contents);
      _message = "File is saved";
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
    }
  }

  Future<void> readFile(String filename) async {
    try {
      _contents = await _service.readFile(filename);
      _message = 'File is Opened';
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
    }
  }

  Future<void> getAllFilesInDirectory() async {
    try {
      _filesName = await _service.getFilesInDirectory();
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
    }
  }
}
