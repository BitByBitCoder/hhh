import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostPage extends ConsumerWidget {
  final String data;
  final String title;
  const PostPage({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset('assets/images/dfd.jpg'),
          Divider(
            thickness: 3,
          ),
          SizedBox(
            height: 10,
          ),
          Text('Title:$title'),
          SizedBox(
            height: 10,
          ),
          Text('Description: $data')
        ],
      ),
    );
  }
}
