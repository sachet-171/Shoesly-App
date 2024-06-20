import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// use to filter a product using starts
class FilterProductScreen extends StatelessWidget {
  final double starRating;

  FilterProductScreen({required this.starRating});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Products'),
      ),
      //call starRating from  these collections
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("products")
            .doc("YVmEUV8GdSmpfuQLHeYX")
            .collection("specialforyourproduct")
            .where("starRating", isEqualTo: starRating)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products found with star rating $starRating'));
          }

          var productDocs = snapshot.data!.docs;
          var products = productDocs
              .map((doc) => Product(
                    image: doc["image"],
                    price: doc["price"],
                    name: doc["name"],
                    productId: doc.id,
                    starRating: doc["starRating"],
                    review: doc["review"],
                  ))
              .toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                leading: Image.network(
                  product.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name),
                subtitle: Text('\$ ${product.price} USD'),
                // Add more details as needed
              );
            },
          );
        },
      ),
    );
  }
}

class Product {
  final String image;
  final double price;
  final String name;
  final String productId;
  final double starRating;
  final int review;

  Product({
    required this.image,
    required this.price,
    required this.name,
    required this.productId,
    required this.starRating,
    required this.review,
  });
}
