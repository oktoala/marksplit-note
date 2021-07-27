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
  late double halfWidth = MediaQuery.of(context).size.width / 2;
  late double textInputWidth = MediaQuery.of(context).size.width / 2;
  late double mdPreviewWidth = MediaQuery.of(context).size.width / 2;
  String currentView = "split";

  Future<File> onWrite() {
    setState(() {});

    return widget.storage.writeFile(controller.text, namaFile);
  }

  void refresh() async {
    listItem = await widget.storage.getFile();
    setState(() {});
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
      drawer: drawer(),
      appBar: AppBar(
        actions: [
          iconAction(() {
            setState(() {
              textInputWidth = halfWidth;
              mdPreviewWidth = halfWidth;
              currentView = "split";
            });
          },
              currentView == "split"
                  ? Icons.vertical_split
                  : Icons.vertical_split_outlined),
          iconAction(() {
            setState(() {
              textInputWidth = 0;
              mdPreviewWidth = halfWidth * 2;
              currentView = "read";
            });
          },
              currentView == "read"
                  ? Icons.remove_red_eye
                  : Icons.remove_red_eye_outlined),
          iconAction(() {
            setState(() {
              textInputWidth = halfWidth * 2;
              mdPreviewWidth = 0;
              currentView = "write";
            });
          }, currentView == "write" ? Icons.create : Icons.create_outlined)
        ],
        title: Text(
          "MarkSplit Note",
          style: TextStyle(fontSize: 16),
        ),
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
                border:
                    Border(right: BorderSide(width: 1, color: Colors.black))),
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
            width: textInputWidth));
  }

  Widget markdownPreview(BuildContext context) {
    return Container(
        width: mdPreviewWidth,
        child: Markdown(
          padding: EdgeInsets.all(10),
          data: controller.text,
        ));
  }

  Widget drawer() {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
            height: 89,
            child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(""))),
        Container(
          height: double.maxFinite,
          child: ListView.builder(
              itemCount: listItem.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(listItem[index]);
              }),
        ),
      ],
    ));
  }

  Widget iconAction(void Function() onpressed, IconData icon) {
    return IconButton(
        onPressed: onpressed,
        icon: Icon(
          icon,
          color: icon.codePoint > 60000 ? Colors.white60 : Colors.white,
        ));
  }
}
