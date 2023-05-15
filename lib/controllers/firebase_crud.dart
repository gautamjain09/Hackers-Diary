import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(blogData) async {
    try {
      FirebaseFirestore.instance.collection("Blogs").add(blogData);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("Blogs").snapshots();
  }
}
