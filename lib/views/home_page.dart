import 'package:flutter/material.dart';
import 'package:hackers_diary/views/create_blog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Hackers Diary",
            style: TextStyle(fontSize: 23, color: Colors.white),
          ),
        ),
      ),
      body: Container(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateBlog(),
              ));
            },
            elevation: 0,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
