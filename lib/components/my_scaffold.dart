import 'package:flutter/material.dart';

class MyScaffold extends StatefulWidget {
  final Widget body;
  final AppBar appBar;
  const MyScaffold({
    super.key,
    required this.appBar,
    required this.body,
  });

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: widget.appBar.title,
            backgroundColor: Colors.transparent,
            elevation: 0, // Remove shadow if desired
            actions: widget.appBar.actions,
            centerTitle: widget.appBar.centerTitle,
            leading: widget.appBar.leading,
          ),
          body: widget.body,
        ),
      ],
    );
  }
}
