import 'dart:io';
import 'package:cross_file_image/cross_file_image.dart'; // for Xfile -> file
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hackers_diary/controllers/firebase_crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  late String authorName, title, description;
  CrudMethods crudMethods = CrudMethods();
  bool isLoading = false;

  XFile? selectedImage;
  Future getImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      selectedImage = image;
    });
  }

  void uploadBlog() async {
    // Progress Bar
    if (selectedImage != null) {
      setState(() {
        isLoading = true;
      });

      Reference ref = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(10)}.jpg");

      UploadTask task = ref.putFile(File(selectedImage!.path));
      TaskSnapshot snapshot = await task;
      var imageUrl = await snapshot.ref.getDownloadURL();

      Map<String, String> blogmap = {
        "ImageUrl": imageUrl,
        "AuthorName": authorName,
        "Title": title,
        "Description": description,
      };

      crudMethods.addData(blogmap).then(
            (value) => Navigator.of(context).pop(),
          );
    } else {
      // print Error
    }
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
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Icon(Icons.send_outlined),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: selectedImage != null
                          ? SizedBox(
                              height: 160,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: XFileImage(selectedImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Icon(Icons.add_a_photo),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (String? val) {
                        authorName = val!;
                      },
                      decoration: const InputDecoration(
                        hintText: "Author Name",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (String? val) {
                        title = val!;
                      },
                      decoration: const InputDecoration(
                        hintText: "Title",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (String? val) {
                        description = val!;
                      },
                      decoration: const InputDecoration(
                        hintText: "Description",
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
