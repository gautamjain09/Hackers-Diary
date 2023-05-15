import 'package:flutter/material.dart';
import 'package:hackers_diary/controllers/firebase_crud.dart';
import 'package:hackers_diary/widgets/blog_tile.dart';
import 'package:hackers_diary/screens/create_blog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = CrudMethods();
  Stream? blogsStream;

  Widget blogList() {
    return Container(
      child: blogsStream != null
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: blogsStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return BlogsTile(
                            imageUrl: snapshot.data!.docs[index]["ImageUrl"],
                            authorName: snapshot.data!.docs[index]
                                ["AuthorName"],
                            title: snapshot.data!.docs[index]["Title"],
                            description: snapshot.data!.docs[index]
                                ["Description"],
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Hackers Diary",
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: blogList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateBlog(),
            ),
          );
        },
        elevation: 0,
        child: const Icon(Icons.add),
      ),
    );
  }
}
