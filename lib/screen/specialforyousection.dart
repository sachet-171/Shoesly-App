import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shoeslymain/widgets/singleproduct.dart';
import 'detailscreen.dart';
 //making of singleproduct class for privide responsive UI  and fetched the data

class SpecialForYouSection extends StatefulWidget {
  @override
  _SpecialForYouSectionState createState() => _SpecialForYouSectionState();
}

class _SpecialForYouSectionState extends State<SpecialForYouSection> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  }
  //data fetched from productspecial collection
  Future<List<Product>> fetchProducts() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("productspecial")
          .get();

      List<Product> products = snapshot.docs.map((doc) {
        return Product(
          productId: doc.id, 
          name: doc["name"],
          price: double.parse(doc["price"].toString()),
          image: doc["image"], 
          starRating: doc["starRating"],
          review: doc["review"], description: doc['description'],
        );
      }).toList();

      return products;
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception("Failed to fetch products");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found'));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: snapshot.data!.map((product) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => DetailScreen(
                       
                        name: product.name,
                        price: product.price,
                        productId: product.productId,
                        starRating: product.starRating,
                        review: product.review,
                        image: product.image, // Ensure 'image' is passed
                      ),
                    ));
                  },
                  child: SingleProduct(
                 
                    image: product.image, 
                    name: product.name,
                    price: product.price,
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
   
class Product {
  final String productId; 
  final String image;
  final String name;
  final double price;
  final String review;
  final String starRating;

  Product({
    required this.productId,
    required this.image,
    required this.name,
    required this.price,
    required this.review,
    required this.starRating, required description,
  });
}
