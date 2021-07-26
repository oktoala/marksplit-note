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

  var namaFile = "test";

  Future<File> onWrite() {
    setState(() {});

    return widget.storage.writeFile(controller.text, namaFile);
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readfile(namaFile).then((String value) {
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
        title: Text("MarkSplit Note"),
      ),
      body: SafeArea(
        child: VerticalSplitView(
            left: textInput(context), right: markdownPreview(context)),
      ),
    );
  }

  Widget textInput(BuildContext context) {
    return Container(
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
      // width: MediaQuery.of(context).size.width / 2,
    );
  }

  Widget markdownPreview(BuildContext context) {
    return Container(
        // width: MediaQuery.of(context).size.width / 2,
        child: Markdown(
      padding: EdgeInsets.symmetric(vertical: 10),
      data: controller.text,
    ));
  }
}

class VerticalSplitView extends StatefulWidget {
  final Widget left;
  final Widget right;
  final double ratio;

  const VerticalSplitView(
      {Key? key, required this.left, required this.right, this.ratio = 0.5})
      : assert(left != null),
        assert(right != null),
        assert(ratio >= 0),
        assert(ratio <= 1),
        super(key: key);

  @override
  _VerticalSplitViewState createState() => _VerticalSplitViewState();
}

class _VerticalSplitViewState extends State<VerticalSplitView> {
  final _dividerWidth = 16.0;

  //from 0-1
  late double _ratio;
  late double _maxWidth;

  double width(String type, double ratio, double maxWidth) {
    if (type == "1") {
      return ratio * maxWidth;
    } else {
      return (1 - ratio) * maxWidth;
    }
  }

  @override
  void initState() {
    super.initState();
    _ratio = widget.ratio;
    _maxWidth = 500;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      assert(_ratio <= 1);
      assert(_ratio >= 0);
      if (_maxWidth == null) _maxWidth = constraints.maxWidth - _dividerWidth;
      if (_maxWidth != constraints.maxWidth) {
        _maxWidth = constraints.maxWidth - _dividerWidth;
      }
      return SizedBox(
        // width: constraints.maxWidth,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: width("1", _ratio, _maxWidth),
              child: widget.left,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                width: _dividerWidth,
                child: RotationTransition(
                  child: Icon(Icons.drag_handle),
                  turns: AlwaysStoppedAnimation(0.25),
                ),
              ),
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  _ratio += details.delta.dx / _maxWidth;
                  if (_ratio > 1)
                    _ratio = 1;
                  else if (_ratio < 0.0) _ratio = 0.0;
                });
              },
            ),
            SizedBox(
              width: width("2", _ratio, _maxWidth),
              child: widget.right,
            ),
          ],
        ),
      );
    });
  }
}
