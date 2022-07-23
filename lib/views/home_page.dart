import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:hackers_diary/services/firebase_crud.dart';
import 'package:hackers_diary/views/create_blog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();

  Stream? blogsStream;

  Widget BlogList() {
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
            style: TextStyle(fontSize: 23, color: Colors.white),
          ),
        ),
      ),
      body: BlogList(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateBlog(),
              ));
            },
            elevation: 9,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imageUrl, authorName, title, description;
  BlogsTile(
      {Key? key,
      required this.imageUrl,
      required this.authorName,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 160,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  authorName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
