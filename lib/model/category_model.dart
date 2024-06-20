import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String brandId; // Could be brandId
  final String name;
  final String image;
  final double price;
   
  Category({
    required this.brandId,
    required this.name,
    required this.image,
    required this.price,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Category(
      brandId: data['brandId'] ?? '', // Adjust based on your Firestore field name
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
    );
  }
}
