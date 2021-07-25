import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  final TextEditingController controller = TextEditingController();

  Future<File> onWrite() {
    print(controller.text);
    setState(() {});

    return widget.storage.writeFile(controller.text);
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readfile().then((String value) {
      setState(() {
        controller.text = value;
      });
    });
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
          onWrite();
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
        child: Markdown(
          padding: EdgeInsets.all(10),
          data: controller.text,
        ));
  }

  FutureBuilder futureBuilder() {
    return FutureBuilder(
        future: widget.storage._localFile,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Markdown(data: snapshot.data);
          }
          return Container();
        });
  }
}
