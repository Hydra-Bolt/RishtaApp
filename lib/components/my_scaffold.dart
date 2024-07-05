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
        Image.asset(
          'assets/images/app_background.png',
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
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
