import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String image;
  final double price;
  final String name;
  final String productId;
  final String starRating;
  final String review;
   
  Product({
    required this.image,
    required this.price,
    required this.name,
    required this.productId,
    required this.starRating,
    required this.review,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      image: data['image'] ?? '',
      price: (data['price'] ?? 0).toDouble(), 
      name: data['name'] ?? '',
      productId: doc.id,
      starRating: data['starRating']?.toString() ?? '', 
      review: data['review']?.toString() ?? '', 
    );
  }
}
