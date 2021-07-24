import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/text.md');
  }

  Future<String> readfile() async {
    try {
      final file = await _localFile;

      // Read file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return "Failed";
    }
  }

  Future<File> writeFile(String text) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(text);
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey _formKey = GlobalKey();
  final TextEditingController controller = TextEditingController();

  _onWrite(String text) {
    setState(() {
      print(text);
    });
  }

  void printLatest() {
    print(controller.text);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // controller.addListener(printLatest);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Markdown Text"),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [textInput(context), markdownPreview(context)],
        ),
      ),
    );
  }

  Widget textInput(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black))),
      child: TextFormField(
        onChanged: (text) {
          printLatest();
        },
        controller: controller,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        minLines: null,
        maxLines: null,
        expands: true,
      ),
      width: MediaQuery.of(context).size.width / 2,
    ));
  }

  Widget markdownPreview(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Text(controller.text),
    );
  }
}
