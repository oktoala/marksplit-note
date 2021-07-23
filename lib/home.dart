import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Markdown Text"),
      ),
      body: Row(
        children: [textInput(context), markdownPreview(context)],
      ),
    );
  }

  Widget textInput(BuildContext context) {
    return Container(
      color: Colors.red,
      constraints:
          BoxConstraints(minWidth: MediaQuery.of(context).size.width / 2),
    );
  }

  Widget markdownPreview(BuildContext context) {
    return Container(
      color: Colors.blue,
      constraints:
          BoxConstraints(minWidth: MediaQuery.of(context).size.width / 2),
    );
  }
}
