import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_scaffold.dart';

class ImagesUpload extends StatelessWidget {
  const ImagesUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        appBar: AppBar(title: const Text("Okay, Just the last step")),
        body: Column(
          children: const [Text("Upload your images here")],
        ));
  }
}
