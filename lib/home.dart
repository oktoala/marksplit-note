import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:io';
import 'dart:async';
import 'package:markdown_note/model/storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController controller = TextEditingController();
  late List<String> listItem = [];
  var namaFile = "test";

  Future<File> onWrite() {
    setState(() {});

    return widget.storage.writeFile(controller.text, namaFile);
  }

  void refresh() async {
    listItem = await widget.storage.getFile();
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readfile(namaFile).then((String value) {
      setState(() {
        controller.text = value;
      });
    });
    refresh();
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
      drawer: Text("Haha"),
      appBar: AppBar(
        title: Text("MarkSplit Note"),
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
    return Scrollbar(
        child: Container(
      padding: EdgeInsets.only(left: 10, top: 2),
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

  Widget drawer = Drawer();
}
