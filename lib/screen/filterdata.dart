import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoeslymain/model/productmodel.dart';
// Replace with your product model import

class FilterData {
  final String starRating;
  final int sizeFilter; // Size you want to filter by

  FilterData({required this.starRating, required this.sizeFilter});

  Future<List<Product>> fetchFilteredProducts() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("productspecial")
          .where("starRating", isEqualTo: starRating)
          .get();

      List<Product> products = snapshot.docs
          .where((doc) =>
              (doc["sizes"] as List<dynamic>).contains(sizeFilter))
          .map((doc) {
        return Product(
          productId: doc.id,
          name: doc["name"],
          price: double.parse(doc["price"].toString()),
          image: doc["image"],
          starRating: doc["starRating"],
          review: doc["review"],
        );
      }).toList();

      return products;
    } catch (e) {
      print('Error fetching filtered products: $e');
      return []; // Return an empty list or handle error as needed
    }
  }
}
