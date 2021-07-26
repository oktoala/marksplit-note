import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    RegExp exp = RegExp(r"^(.*/)([^/]*)$");
    final directory = await getApplicationDocumentsDirectory();
    await for (var entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity.path.contains(".md")) {
        print(entity.path);
        var split = entity.path.split("/");
        print(split[split.length - 1]);
      }
    }
    // print("Dir : ${directory.path}");
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
