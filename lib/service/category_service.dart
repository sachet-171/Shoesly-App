import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/category_model.dart';


class CategoryService {
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<List<Category>> getCategories() async {
    QuerySnapshot querySnapshot = await categoryCollection.get();
    return querySnapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
  }
}
