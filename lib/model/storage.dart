import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<List<String>> getFile() async {
    List<String> listItem = [];
    final dir = await getApplicationDocumentsDirectory();
    await for (var item in dir.list(recursive: true, followLinks: false)) {
      if (item.path.contains(".md")) {
        var splitDir = item.path.split("/");
        var textMd = splitDir[splitDir.length - 1];
        var text = textMd.split(".md");
        print(text[0]);
        listItem.add(text[0]);
      }
    }
    return listItem;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String namaFile) async {
    final path = await _localPath;
    return File('$path/$namaFile.md');
  }

  Future<String> readfile(String namaFile) async {
    try {
      final file = await _localFile(namaFile);

      // Read file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return "# Input Ada di kiri";
    }
  }

  Future<File> writeFile(String text, String namaFile) async {
    final file = await _localFile(namaFile);

    // Write the file
    return file.writeAsString(text);
  }
}
